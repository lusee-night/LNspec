#!/usr/bin/env python
import numpy as np

Nfft   = 4096
Nchan  = Nfft // 2
Ntaps  = 4
Nblock = Ntaps*Nfft
Navg   = 4
overNavg = 1/Navg

base_funcs = "spectrometer weight_streamer sfft correlate average  ".split()
base_funcs += "spectrometer_tb read_samples".split()



def make_get_pfb_weights():
    fname = f"get_pfb_weights_{Nfft}_{Ntaps}.m"
    print (f"*** Generating {fname}.")
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

def process_file(fromf, tof):
    fromfn = f"src/{fromf}.m"
    tofn = f"{tof}.m"
    print (f"*** Processing {fromfn} -> {tofn} ")
    lines = open(fromfn).readlines()
    ders = []
    def fix_vars(s):
        s = s.format(Nfft = Nfft, Nchan = Nchan, Ntaps = Ntaps, Navg = Navg,overNavg = overNavg, Nblock = Nblock)
        i = s.find("__instance:")
        if (i>0):
            j=s.rfind("__")
            insta = s[i+len("__instance:"):j]
            s = s[:i]+"__instance_"+insta+"_"+s[j+2:]
            k = max(s[:i].rfind(" "), s[:i].rfind("="))
            tomake = s[k+1:i]+"__instance_"+insta+"_"
            frommake = s[k+1:i]
            ders.append((frommake,tomake))
        return s
                    
    lines = [fix_vars(line) for line in lines]
    if (fromf!=tof):
        lines[0] = lines[0].replace(fromf,tof)    
    open(tofn,'w').writelines(lines)
    return ders
    
        
if __name__=="__main__":
    derived_files=[]
    print ("Base files:")
    for func in base_funcs:
        new_der = process_file(func,func)
        derived_files+=new_der
    print ("Derived files:")
    for fromf,tof in derived_files:
        process_file (fromf,tof)
    print ("PFB weights:")
    make_get_pfb_weights()
        
        

