#!/usr/bin/env python
import math as m

Nfft   = 4096
Nchan  = Nfft // 2
Ntaps  = 4
Nblock = Ntaps*Nfft
Nfold  = (Ntaps-1)*Nfft
Navg   = 4
overNavg = 1/Navg

base_funcs = "spectrometer weight_streamer sfft deinterlace ".split()
base_funcs += "spectrometer_tb read_samples".split()



def make_get_pfb_weights():
    fname = f"get_pfb_weights_{Nfft}_{Ntaps}.m"
    print (f"*** Generating {fname}.")
    f = open(fname,'w')
    f.write(f"function out = get_pfb_weights_{Nfft}_{Ntaps}(Nfft,Ntaps)\n")
    f.write(f"   assert(Nfft=={Nfft})\n")
    f.write(f"   assert(Ntaps=={Ntaps})\n")
    Ntot = Nfft*Ntaps;
    xp = [(-Ntot/2+0.5+x)/Nfft*m.pi for x in range(Ntot)]
    f.write(f"   out = zeros(1,{Ntot});\n")
    for i, x in enumerate(xp):
        v = m.sin(x)/x if x!=0 else 1.0
        f.write(f"   out({i+1}) = {v:10.8};\n")
    f.write('end\n')
    f.close()

def process_file(fromf, tof, addrepl = None):
    fromfn = f"src/{fromf}.m"
    tofn = f"{tof}.m"
    kdic={"Nfft": Nfft, "Nchan": Nchan, "Ntaps": Ntaps, "Navg": Navg,
          "overNavg":overNavg, "Nblock": Nblock, "Nfold": Nfold}
    if addrepl is not None:
        for ent in addrepl.split(","):
            key,value = ent.split('=')
            kdic[key]=value
    print (f"*** processing {fromfn} -> {tofn} ")
    lines = open(fromfn).readlines()
    ders = []
    def fix_vars(s):
        s = s.format(**kdic)
        i = s.find("__instance:")
        if (i>0):
            j=s.rfind("__")
            splt = s[i:j].split(':')
            insta = splt[1]
            s = s[:i]+"__instance_"+insta+"_"+s[j+2:]
            k = max(s[:i].rfind(" "), s[:i].rfind("="))
            tomake = s[k+1:i]+"__instance_"+insta+"_"
            frommake = s[k+1:i]
            addrepl = f"parent={insta}"
            addrepl += ","+splt[2] if len(splt)>2 else ""
            ders.append((frommake,tomake,addrepl))
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
        derived_files+=process_file(func,func)
    print ("Derived files:")
    while len(derived_files)>0:
        new_derived_files = []
        for fromf,tof,addrepl in derived_files:
            new_derived_files += process_file (fromf,tof,addrepl)
        derived_files = new_derived_files
    print ("PFB weights:")
    make_get_pfb_weights()
        
        

