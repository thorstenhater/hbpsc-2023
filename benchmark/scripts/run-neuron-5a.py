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
// A simulation of L5 Pyramidal Cell under a train of somatic pulses
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
tstop = 1000

//=================== creating cell object ===========================
load_file("import3d.hoc")
objref L5PC

strdef morphology_file
morphology_file = "../L5bPyrCellHayEtAl2011/NEURON/morphologies/cell1.asc"

load_file("../L5bPyrCellHayEtAl2011/NEURON/models/L5PCbiophys3.hoc")
load_file("../L5bPyrCellHayEtAl2011/NEURON/models/L5PCtemplate.hoc")
L5PC = new L5PCtemplate(morphology_file)

//==================== stimulus settings ===========================

stimdist = 830 //distance of apical dendrite recording site
pulsenum = 5
freqs = 120
durs = 5

// Note: this pulse amplitude yields the correct behaviour in 64 bit NEURON environment.
// In 32 bit NEURON environements, due to difference in float precision, this amplitude may need to be
// modified slightly (amps = 1.94 nA).
amps = 1.99

access L5PC.soma
objref stim1
stim1 = new List()

for(i=0;i<pulsenum;i+=1) {
  stim1.append(new IClamp(0.5))
  stim1.o[i].amp = amps
  stim1.o[i].del = tstop/4 + i*1000/freqs
  stim1.o[i].dur = durs
}

//==================== recording settings ===========================

objref vdend,vsoma,vsoma_t

vsoma = new Vector()
vdend = new Vector()
vsoma_t = new Vector()

access L5PC.soma
cvode.record(&v(0.5),vsoma,vsoma_t)

objref istim
istim = new List()

for(i2=0;i2<pulsenum;i2+=1) {
 istim.append(new Vector())
 cvode.record(&stim1.o[i2].i,istim.o[i2],vsoma_t)
}

objref sl
sl = new List()
double siteVec[2]
sl = L5PC.locateSites("apic",stimdist)

maxdiam = 0
for(i=0;i<sl.count();i+=1){
	dd1 = sl.o[i].x[1]
  dd = L5PC.apic[sl.o[i].x[0]].diam(dd1)
  if (dd > maxdiam) {
    j = i
    maxdiam = dd 
  }
}

siteVec[0] = sl.o[j].x[0]
siteVec[1] = sl.o[j].x[1]

access L5PC.apic[siteVec[0]] 
cvode.record(&v(siteVec[1]),vdend,vsoma_t)

//======================= plot settings ============================

objref gV

gV = new Graph()
gV.size(0,tstop,-85,50)
graphList[0].append(gV)
gV.addvar("distal apical","v(0.5)",2,1)
access L5PC.soma
gV.addvar("soma","v(0.5)",1,1)

objref gI

gI = new Graph()
gI.size(0,tstop,-3,3)
graphList[0].append(gI)

objref s

s = new Shape(L5PC.all)
//fictive stimulus to visualize recording site
access L5PC.apic[siteVec[0]] 
objref stim2
stim2 = new IClamp(siteVec[1])
stim2.amp = 0
stim2.del = 0
stim2.dur = 0
s.point_mark(stim2,2)
s.show(0)

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
        simtime_ms=1000,
        figure='5a'
        ))
    print(logline, file=f)


h('''

for(i2=0;i2<pulsenum;i2+=1) {
  istim.o[i2].plot(gI,vsoma_t)
}

''')
