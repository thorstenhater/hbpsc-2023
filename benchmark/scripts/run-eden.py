import os
import json
import pandas as pd
import matplotlib.pyplot as plt
from time import perf_counter as pc

import eden_simulator

os.makedirs('../generated/eden', exist_ok=True)
os.chdir('../generated/eden')

t0 = pc()
V = eden_simulator.runEden('../../L5bPyrCellHayEtAl2011/neuroConstruct/generatedNeuroML2/LEMS_TestL5PC.xml')
t1 = pc()
print(f'Simulation done, took: {t1-t0:.3f}s')

k1 = 'CellGroup_1/0/L5PC/0/v'
k2 = 'CellGroup_1/0/L5PC/2313/v'
k3 = 'CellGroup_1/0/L5PC/2363/v'
t     = V['t']
v     = V[k1]
v2313 = V[k2]
v2363 = V[k3]

df = pd.DataFrame(V)
i = 0
while True:
    fn = f'../../results/results_eden_4b_0.025_{i}.csv'
    if not os.path.exists(fn):
        break
    i = i + 1
df.to_csv(fn)
print('Saved results to', fn)

plt.plot(t, v, label=k1)
plt.plot(t, v2313, label=k2)
plt.plot(t, v2363, label=k3)
plt.savefig(f'../../results/results_eden_4b_0.025_{i}.png')

with open(f'../../results/runtimes', 'a') as f:
    logline = json.dumps(dict(
        method='eden',
        version='eden',
        walltime_s=(t1-t0),
        dt=0.025,
        simtime_ms=3000,
        figure='4b',
        results=fn,
        ))
    print(logline, file=f)
