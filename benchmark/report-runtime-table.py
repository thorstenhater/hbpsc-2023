#!/usr/bin/env python3

import sys
import numpy as np
import pandas as pd
import json
import matplotlib.pyplot as plt

if len(sys.argv) >= 2:
    filename = sys.argv[1]
else:
    filename = './results/runtimes'

df = pd.DataFrame.from_records(map(json.loads, open(filename)))

for figure, sub in df.groupby('figure'):
    print(f'# Performance analysis for figure {figure}')
    keys = ['dt']
    for g, sub in sub.groupby(keys):
        if g != 0.025 and g != 'cvode':
            continue
        config = dict(zip(keys, g)) if len(keys) > 1 else {keys[0]: g}
        config_line = ','.join(f'{k}={v}' for k, v in config.items())
        print(f' analysis for {config_line}')
        walltime_s = sub.groupby('version')['walltime_s'].min()
        counts = sub.groupby('version')['walltime_s'].count()
        simtime_s = sub.groupby('version')['simtime_ms'].first() / 1000
        slowdown = walltime_s/simtime_s
        for k, v in sorted(dict(100 * slowdown / slowdown.min()).items(), key=lambda x: x[1]):
            v = v - 100
            if np.isclose(v, 0):
                rel = f'(fastest)'
            else:
                rel = f'({v:.3f}% slower)'
            print('   ',
                    k.ljust(20),
                    f'{slowdown[k]:.2f} sim.s/bio.s'.ljust(20),
                    rel.ljust(20),
                    f'{counts[k]} trials'
                    )
    print()
