#!/usr/bin/env python
import numpy as np
Nfft = 4096
Ntaps = 4
fname = f"weights/pfb_weights_{Nfft}_{Ntaps}.dat"

Ntot = Nfft*Ntaps;
xp = -Ntot/2+0.5+np.arange(Ntot)
xp = xp/Nfft*np.pi
f = open(fname,'w')
for i, x in enumerate(xp):
    v = np.sin(x)/x if x!=0 else 1.0
    f.write(f"{v:10.8};\n")

f.close()

    


