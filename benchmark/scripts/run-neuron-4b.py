import os
# needs to find the x64_86 directory
# prior to neuron import!
os.chdir('../generated')

import json
from time import perf_counter as pc
from neuron import h, gui

import sys
if len(sys.argv) == 2:
    dt = float(sys.argv[1])
else:
    dt = None

h('''
//Author: Etay Hay, 2011
//  Models of Neocortical Layer 5b Pyramidal Cells Capturing a Wide Range of
//  Dendritic and Perisomatic Active Properties
//  (Hay et al., PLoS Computational Biology, 2011) 
//
// A simulation of L5 Pyramidal Cell under a prolonged step current
// Edited by L Landsmeer (2022) to fit into simulation benchmark

load_file("nrngui.hoc")

objref cvode
cvode = new CVode()
''')

if dt is None:
    h('cvode.active(1)')
else:
    h('cvode.active(0)')
    h.dt = dt

h('''

//======================== settings ===================================

v_init = -80

//step 1: 0.619
//step 2: 0.793
//step 3: 1.507
step_amp = 0.793
tstop = 3000

//=================== creating cell object ===========================
load_file("import3d.hoc")
objref L5PC

strdef morphology_file
morphology_file = "../L5bPyrCellHayEtAl2011/NEURON/morphologies/cell1.asc"

load_file("../L5bPyrCellHayEtAl2011/NEURON/models/L5PCbiophys3.hoc")
load_file("../L5bPyrCellHayEtAl2011/NEURON/models/L5PCtemplate.hoc")
L5PC = new L5PCtemplate(morphology_file)

//==================== stimulus settings ===========================

objref st1

st1 = new IClamp(0.5)
st1.dur = 2000
st1.del = 700
st1.amp = step_amp

L5PC.soma st1

//==================== recording settings ==========================
objref vvec, tvec

vvec = new Vector()
tvec = new Vector()

access L5PC.soma
cvode.record(&v(0.5),vvec,tvec)

objref apcvec, apc
apcvec = new Vector()
apc = new APCount(0.5)
apc.thresh= -10
apc.record(apcvec)

//======================= plot settings ============================

objref gV

gV = new Graph()
gV.size(0,tstop,-80,40)
graphList[0].append(gV)
access L5PC.axon
access L5PC.soma
gV.addvar("soma","v(0.5)",1,1)

//============================= simulation ================================
init()
''')

t0 = pc()
h('''
run()
''')
t1 = pc()
print(f'Simulation done, took: {t1-t0:.3f}s')

with open(f'../results/runtimes', 'a') as f:
    logline = json.dumps(dict(
        method='neuron',
        version='neuron',
        walltime_s=(t1-t0),
        dt='cvode' if dt is None else dt,
        simtime_ms=3000,
        figure='4b',
        ))
    print(logline, file=f)


h('''

print "spike count = ", apcvec.size()



''')
