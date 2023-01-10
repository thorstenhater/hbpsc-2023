import sys
import re
import os
import json
import pandas as pd
import matplotlib.pyplot as plt
from time import perf_counter as pc
import subprocess


# Eden exposes run and setup-time within the `out'
# local variable - but only shows it on error.
# Using this hack we can peek inside the local
# environment and retrieve the `out' variable
# from https://stackoverflow.com/questions/4214936
def call_function_get_frame(func, *args, **kwargs):
    frame = None
    trace = sys.gettrace()
    def snatch_locals(_frame, name, _):
        nonlocal frame
        if frame is None and name == 'call':
            frame = _frame
            sys.settrace(trace)
        return trace
    sys.settrace(snatch_locals)
    try:
        result = func(*args, **kwargs)
    finally:
        sys.settrace(trace)
    return frame, result

import eden_simulator

os.makedirs('../generated/eden', exist_ok=True)
os.chdir('../generated/eden')

frame, result = call_function_get_frame(
        eden_simulator.runEden,
        '../../L5bPyrCellHayEtAl2011/neuroConstruct/generatedNeuroML2/LEMS_TestL5PC.xml')
stdout = frame.f_locals['out']
PATTERN = r'Config: ([^ ]+) Setup: ([^ ]+) Run: ([^ ]+)\b'
m = re.search(PATTERN, stdout)
configtime = float(m.group(1))
setuptime = float(m.group(2))
runtime = float(m.group(3))
V = result
print(f'Simulation done, took: {runtime:.3f}s')

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
        walltime_s=runtime,
        setup_s=setuptime,
        config_s=configtime,
        dt=0.025,
        simtime_ms=3000,
        figure='4b',
        results=fn,
        ))
    print(logline, file=f)
