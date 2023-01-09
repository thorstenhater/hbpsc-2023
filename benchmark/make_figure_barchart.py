#!/usr/bin/env python3

import io
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

table = '''
| Simulator | Translator         | Timestep         | Run time (sim s / bio s) | Relative speed  |
|-----------|--------------------|------------------|--------------------------|-----------------|
| Arbor     | nmlcc (optimised)  | 0.025            | 1.36                     | fastest         |
| Arbor     | nmlcc              | 0.025            | 1.55                     | 14.220% slower  |
| Arbor     | jnml               | 0.025            | 3.00                     | 121.379% slower |
| EDEN      | nml                | 0.025            | 4.50                     | 232.152% slower |
| NEURON    | Hay et al. (cvode) | Adaptive (cvode) | 2.22                     |                 |
| NEURON    | Hay et al.         | 0.025            | 9.75                     | 619.610% slower |
| NEURON    | jnml               | 0.025            | 11.83                    | 773.229% slower |
'''

df = pd \
    .read_table(io.StringIO(table), sep="|", header=0, index_col=None, skipinitialspace=True) \
    .dropna(axis=1, how='all') \
    .iloc[1:]

sim = [x.strip() for x in df.iloc[:, 0]]
trans = [x.strip() for x in df.iloc[:, 1]]
rt = np.array([float(x) for x in df.iloc[:, 3]]) * 3
rtmin = rt.min()
rtmax = rt.max()

x = [
    9-1.0,
    8-1.0,
    7-1.0,

    5-0.5,

    3,
    2,
    1,
]

xmid = [
    x[1],
    x[3],
    x[5]
]

for i, (y, t) in enumerate(zip(x, trans)):
    # banner = f'$\\bf{{{rt[i]/rtmin:.2f}x}}$'
    # banner = f'{rt[i]/rtmin:.1f}x'
    # banner = f'{rtmax/rt[i]:.1f}x'
    banner = f'$\\mathbf{{{rtmax/rt[i]:.1f}{{\\times}}}}$'
    #plt.text(0 + 0.4, y, f'{banner}', ha='left', va='center', color='white')
    plt.text(rt[i] - 0.4, y, f'{banner}', ha='right', va='center', color='white')
    t = t.replace('et al.', '$et$ $al.$')
    plt.text(rt[i] + 0.4, y, f'{t}', ha='left', va='center', color='black')

color = [dict(
    Arbor='#d86310',
    EDEN='green',
    NEURON='#2C6872'
    )[x] for x in sim]

plt.xlim([0, 45])
plt.ylim([x[-1]-0.5,x[0]+0.6])
plt.xticks(np.arange(0, 45, 10))
plt.yticks(xmid, ['Arbor', 'EDEN', 'NEURON'], rotation=90, va='center')
plt.tick_params(axis='y', which='both', left=False)
# plt.tick_params(axis='x', which='both', bottom=False)
plt.barh(x, rt, 1.01, color=color)
plt.xlabel('Simulation time (s)')

ax = plt.gca()
ax.spines['top'].set_visible(False)
ax.spines['right'].set_visible(False)
ax.spines['bottom'].set_visible(False)
ax.spines['left'].set_visible(False)

# df = pd.read_csv('results/results_nmlcc_nmlcc-pynml_4b_0.025_0.csv')
# x = df['t/ms']
# y = df['U/mV']
# ix = ax.inset_axes((0.5, 0.7, 0.5, 0.3))
# ix.axis('off')
# ix.plot(x, y, color='black')

plt.savefig('./barchart.svg', bbox_inches = 'tight', pad_inches = 0)
plt.savefig('./barchart.pdf', bbox_inches = 'tight', pad_inches = 0)
print('pdf-crop-margins -v -p 0 barchart.pdf')

plt.show() 
