#!/usr/bin/env python
import numpy as np

Nfft=4096
omega_fundamental = 2*np.pi/Nfft
Nmake = Nfft * 256 ## sufficient number of blocks
time = np.arange(Nmake)
signal = np.zeros(Nmake)

Ntones = 11
offsets = np.linspace(-0.4,0.4,Ntones)
print (offsets)
for i,ofs in enumerate(offsets):
    signal += 100*np.cos(time*omega_fundamental*((4*i+2)+ofs)+np.random.uniform(0,2*np.pi))

## now write the signal out
print (signal.max())
with open('drifting_comb.bin','wb') as f:
    for num in np.round(signal).astype(int):
        f.write(int(num).to_bytes(2,'little',signed=True))
    

    
