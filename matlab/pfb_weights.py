#!/usr/bin/env python
import numpy as np
Nfft = 4096
Ntaps = 4
fname = f"get_pfb_weights_{Nfft}_{Ntaps}.m"
f = open(fname,'w')
f.write(f"function out = get_pfb_weights_{Nfft}_{Ntaps}(Nfft,Ntaps)\n")
f.write(f"   assert(Nfft=={Nfft})\n")
f.write(f"   assert(Ntaps=={Ntaps})\n")
Ntot = Nfft*Ntaps;
xp = -Ntot/2+0.5+np.arange(Ntot)
xp = xp/Nfft*np.pi
f.write(f"   out = zeros(1,{Ntot});\n")
for i, x in enumerate(xp):
    v = np.sin(x)/x if x!=0 else 1.0
    f.write(f"   out({i+1}) = {v:10.8};\n")
f.write('end\n')
f.close()

    


