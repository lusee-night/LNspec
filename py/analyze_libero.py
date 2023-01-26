#!/usr/bin/env python
import glob, sys
from xml.dom import minidom

codegendir = sys.argv[1]

for libdir in sorted(glob.glob(codegendir+
                               "/*/hdlsrc/libero_prj")):
    #print (libdir)
    mod = libdir[:libdir.rfind('hdlsrc/')].split("/")[-2]
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
    try:
        max_freq = runstatus_p.getElementsByTagName('data')[7].firstChild.data
        slack = runstatus_p.getElementsByTagName('data')[8].firstChild.data
    except:
        max_freq = "?"
        slack = "?"
    print (f"{mod:<25}, {max_freq:<10}, {slack:<5} ns , {sig_usage}")
    
