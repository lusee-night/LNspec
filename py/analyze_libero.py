#!/usr/bin/env python
import glob, sys
from xml.dom import minidom

codegendir = sys.argv[1]

for libdir in sorted(glob.glob(codegendir+"/*/hdlsrc/libero_prj")):
    mod = libdir.split("/")[2]
    res = glob.glob(libdir+"/*/designer/*/*_layout_log.log")
    if len(res)==0:
        continue

    usage = False
    sig_usage = ""
    for line in open(res[0]).readlines():
        if usage:
            line =  line.split("|")
            if len(line)==6:
                try:
                    perc = float(line[4])
                    if perc>5:
                        sig_usage += (line[1].strip()+f" ({perc:.1f}%) ")
                except ValueError:
                    pass
        else:
            if ("Resource Usage") in line:
                usage=True
                    
        
    runstatus = glob.glob(libdir+"/*/synthesis/synlog/report/*fpga_mapper_timing_report.xml")[0]
    runstatus_p = minidom.parse(runstatus)
    max_freq = runstatus_p.getElementsByTagName('data')[7].firstChild.data
    slack = runstatus_p.getElementsByTagName('data')[8].firstChild.data
    print (f"{mod:<25}, {max_freq:<15}, {slack:<15} ns, {sig_usage}")
    
