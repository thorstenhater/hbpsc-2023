#!/usr/bin/env python3

import os, sys
import random
import json
import importlib.util
import pandas as pd
import subprocess as sp
from pathlib import Path
from time import perf_counter as pc

pid = os.getpid()
cpu = random.choice(list(os.sched_getaffinity(pid)))
os.sched_setaffinity(pid, {cpu})


ARBOR_BUILD_CATALOGUE = 'arbor-build-catalogue'


import arbor as A

PLOT = '--plot' in sys.argv
if PLOT: sys.argv.remove('--plot')

JNML = '--jnml' in sys.argv
if JNML: sys.argv.remove('--jnml')

if len(sys.argv) < 3:
    print('usage:', sys.argv[0],
            '[--plot]',
            '[--jnml]',
            'nmlcc|nmlcc-super',
            '4a|4b|5a',
            '<dt>',
            '<tstop>'
            )
    exit(1)

VERSION = sys.argv[1]
FIGURE = sys.argv[2]
dt = float(sys.argv[3]) if len(sys.argv) >= 4 else 0.025


alt_tstop = float(sys.argv[4]) if len(sys.argv) == 5 else None

nmlcc_root = Path('../generated') / VERSION

if JNML:
    cat_dir = Path('../jnml-arbor')
    cat_so_file = Path('../generated/jnml-arbor-catalogue.so')
    acc_path = '../jnml-arbor/L5PC.acc'
    VERSION = VERSION + '-pynml'
else:
    cat_dir = nmlcc_root / 'cat'
    cat_so_file = nmlcc_root / 'local-catalogue.so' 
    acc_path = f'{nmlcc_root}/acc/L5PC.acc'

HOC_FILE = {
        '4a': 'BAC_firing.hoc',
        '4b': 'Step_current_firing.hoc',
        '5a': 'critical_frequency.hoc'
        }

assert FIGURE in {'4b', '4a', '5a'}

def compile(fn, cat):
    fn = fn.resolve()
    cat = cat.resolve()
    recompile = False
    if fn.exists():
        for src in cat.glob('*.mod'):
            src = Path(src).resolve()
            if src.stat().st_mtime > fn.stat().st_mtime:
                recompile = True
                break
    else:
        recompile = True
    if recompile:
        sp.run(f'arbor-build-catalogue local {cat}', shell=True, check=True)
        os.rename('local-catalogue.so', fn)
    return A.load_catalogue(fn)

class recipe(A.recipe):
    def __init__(self):
        A.recipe.__init__(self)
        self.props = A.neuron_cable_properties()
        cat = compile(cat_so_file, cat_dir)
        self.props.catalogue.extend(cat, 'local_')
        self.cell_to_morph = {'L5PC': 'morphology_L5PC', }
        self.gid_to_cell = ['L5PC', ]
        if FIGURE == '4b':
            self.i_clamps = {'Input_0': (699.999988079071, 2000.0, 0.7929999989997327), }
        elif FIGURE == '4a':
            self.i_clamps = {'Input_0': (295.0, 5.0, 1.9), }
        elif FIGURE == '5a':
            self.i_clamps = {'Input_0': [(250 + i*1000/120, 5, 1.99) for i in range(5)]}
        self.gid_to_inputs = { 0: [("seg_0_frac_0.5", "Input_0"), ], }
        self.gid_to_synapses = { }
        self.gid_to_detectors = { }
        self.gid_to_connections = { }
        self.gid_to_labels = { 0: [(0, 0.5), ], }

    def num_cells(self):
        return 1

    def cell_kind(self, _):
        return A.cell_kind.cable

    def cell_description(self, gid):
        cid = self.gid_to_cell[gid]
        mrf = self.cell_to_morph[cid]
        nml = A.neuroml(f'{nmlcc_root}/mrf/{mrf}.nml').morphology(mrf, allow_spherical_root=True)
        lbl = A.label_dict()
        lbl.append(nml.segments())
        lbl.append(nml.named_segments())
        lbl.append(nml.groups())
        lbl['all'] = '(all)'
        if gid in self.gid_to_labels:
            for seg, frac in self.gid_to_labels[gid]:
                lbl[f'seg_{seg}_frac_{frac}'] = f'(on-components {frac} (segment {seg}))'
        dec = A.load_component(acc_path).component


        #  forsec all {
        #    nseg = 1 + 2*int(L/40)
        #    nSec = nSec + 1
        #  }
        dec.discretization(A.cv_policy_max_extent(20))

        if gid in self.gid_to_inputs:
            for tag, inp in self.gid_to_inputs[gid]:
                x = self.i_clamps[inp]
                if not isinstance(x, list):
                    x = [x]
                for lag, dur, amp in x:
                    dec.place(f'"{tag}"', A.iclamp(lag, dur, amp), f'ic_{inp}@{tag}')
        if gid in self.gid_to_synapses:
            for tag, syn in self.gid_to_synapses[gid]:
                dec.place(f'"{tag}"', A.synapse(syn), f'syn_{syn}@{tag}')
        if gid in self.gid_to_detectors:
            for tag in self.gid_to_detectors[gid]:
                dec.place(f'"{tag}"', A.spike_detector(-40), f'sd@{tag}') # -40 is a phony value!!!
        return A.cable_cell(nml.morphology, dec, lbl)

    def probes(self, _):
        # Example: probe center of the root (likely the soma)
        return [A.cable_probe_membrane_voltage('(location 0 0.5)')]

    def global_properties(self, kind):
        return self.props

    def connections_on(self, gid):
        res = []
        if gid in self.gid_to_connections:
            for src, dec, syn, loc, w, d in self.gid_to_connections[gid]:
                conn = A.connection((src, f'sd@{dec}'), f'syn_{syn}@{loc}', w, d)
                res.append(conn)
        return res


ctx = A.context(threads=1)
meter_manager = A.meter_manager()
meter_manager.start(ctx)
mdl = recipe()
meter_manager.checkpoint('recipe-create', ctx)
ddc = A.partition_load_balance(mdl, ctx)
meter_manager.checkpoint('load-balance', ctx)
sim = A.simulation(mdl, ctx, ddc)
meter_manager.checkpoint('simulation-init', ctx)
hdl = sim.sample((0, 0), A.regular_schedule(1))

if alt_tstop is not None:
    length = alt_tstop
elif FIGURE == '4b':
    length = 3000
else:
    length = 600
print(f'Running simulation for {length}ms...')

t0 = pc()
sim.run(length, dt)
t1 = pc()
print(f'Simulation done, took: {t1-t0:.3f}s')
meter_manager.checkpoint('simulation-run', ctx)

(data, meta), = sim.samples(hdl)
df = pd.DataFrame({'t/ms': data[:, 0], 'U/mV': data[:, 1]})
i = 0
while True:
    fn = f'../results/results_nmlcc_{VERSION}_{FIGURE}_{dt}_{i}.csv'
    if not os.path.exists(fn):
        break
    i = i + 1
df.to_csv(fn)
print('Saved results to', fn)

with open(f'../results/runtimes', 'a') as f:
    logline = json.dumps(dict(
        method='nmlcc',
        version=VERSION,
        walltime_s=(t1-t0),
        dt=dt,
        simtime_ms=length,
        figure=FIGURE,
        results=fn,
        ))
    print(logline, file=f)

print(A.meter_report(meter_manager, ctx))

if PLOT:
    import matplotlib.pyplot as plt
    plt.plot(data[:, 0], data[:, 1])
    plt.xlabel('t (ms)')
    plt.ylabel('U (mV)')
    plt.title(f'nmlcc figure {FIGURE}')
    plt.show()

