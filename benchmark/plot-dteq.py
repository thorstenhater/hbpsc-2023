#!/usr/bin/env python3

import pathlib
import numpy as np
import pandas as pd
import json
import matplotlib.pyplot as plt

df = pd.DataFrame.from_records(map(json.loads, open('./results/runtimes')))

for figure, sub in df.groupby('figure'):
    print(f'# Numerical analysis for figure {figure}')
    sub = sub[sub.version=='nmlcc']
    vs = []
    dts = []
    for dt, path in sorted(dict(sub.groupby('dt').min()['results']).items()):
        res = pd.read_csv(pathlib.Path('./scripts/') / path)
        t = res['t/ms']
        v = res['U/mV']
        dts.append(dt)
        vs.append(v)
        # plt.plot(t, v, label=f'dt={dt}ms')
    # plt.legend()
    # plt.show()
    vs = [((v - vs[0])) for v in vs[1:]]
    plt.boxplot(vs)
    plt.xticks(1 + np.arange(len(vs)), dts[1:])
    plt.show()
