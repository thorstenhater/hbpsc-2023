#!/usr/bin/env python3
import arbor as A

import subprocess as sp
from pathlib import Path
from time import perf_counter as pc

here = Path(__file__).parent

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
    sp.run(f'arbor-build-catalogue local {cat}', shell=True, check=True)
    return A.load_catalogue(fn)

class recipe(A.recipe):
    def __init__(self):
        A.recipe.__init__(self)
        self.props = A.neuron_cable_properties()
        cat = compile(here / 'local-catalogue.so', here / 'cat')
        self.props.catalogue.extend(cat, 'local_')
        self.cell_to_morph = {'L5PC': 'morphology_L5PC', }
        self.gid_to_cell = ['L5PC', ]
        self.i_clamps = {'Input_0': (699.999988079071, 2000.0, 0.7929999989997327), }
        self.gid_to_inputs = {
                                 0: [("seg_0_frac_0.5", "Input_0"), ], }
        self.gid_to_synapses = {
                               }
        self.gid_to_detectors = {
                               }
        self.gid_to_connections = {
                               }
        self.gid_to_labels = {
                                0: [(0, 0.5), ],
                               }

    def num_cells(self):
        return 1

    def cell_kind(self, _):
        return A.cell_kind.cable

    def cell_description(self, gid):
        cid = self.gid_to_cell[gid]
        mrf = self.cell_to_morph[cid]
        nml = A.neuroml(f'{here}/mrf/{mrf}.nml').morphology(mrf, allow_spherical_root=True)
        lbl = A.label_dict()
        lbl.append(nml.segments())
        lbl.append(nml.named_segments())
        lbl.append(nml.groups())
        lbl['all'] = '(all)'
        if gid in self.gid_to_labels:
            for seg, frac in self.gid_to_labels[gid]:
                lbl[f'seg_{seg}_frac_{frac}'] = f'(on-components {frac} (segment {seg}))'
        dec = A.load_component(f'{here}/acc/{cid}.acc').component
        dec.discretization(A.cv_policy_every_segment())
        if gid in self.gid_to_inputs:
            for tag, inp in self.gid_to_inputs[gid]:
                lag, dur, amp = self.i_clamps[inp]
                dec.place(f'"{tag}"', A.iclamp(lag, dur, amp), f'ic_{inp}@{tag}')
        if gid in self.gid_to_synapses:
            for tag, syn in self.gid_to_synapses[gid]:
                dec.place(f'"{tag}"', A.synapse(syn), f'syn_{syn}@{tag}')
        if gid in self.gid_to_detectors:
            for tag in self.gid_to_detectors[gid]:
                dec.place(f'"{tag}"', A.spike_detector(-40), f'sd@{tag}') # -40 is a phony value!!!
        return A.cable_cell(nml.morphology, lbl, dec)

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

ctx = A.context()
mdl = recipe()
ddc = A.partition_load_balance(mdl, ctx)
sim = A.simulation(mdl, ctx, ddc)
hdl = sim.sample((0, 0), A.regular_schedule(0.1))

print('Running simulation for 1s...')
t0 = pc()
sim.run(1000, 0.0025)
t1 = pc()
print(f'Simulation done, took: {t1-t0:.3f}s')

print('Trying to plot...')
try:
  import pandas as pd
  import seaborn as sns

  for data, meta in sim.samples(hdl):
    df = pd.DataFrame({'t/ms': data[:, 0], 'U/mV': data[:, 1]})
    sns.relplot(data=df, kind='line', x='t/ms', y='U/mV', ci=None).savefig('result.pdf')
  print('Ok')
except:
  print('Failure, are seaborn and matplotlib installed?')
