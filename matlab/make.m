clear all

resp = system("python make.py");
if (resp == 1)
    system("python3.10 make.py");
end

setenv('TMPDIR', getenv('PWD')+"/tmp")
setenv('GCC', "gcc-10")

% Create a 'fixpt' config with default settings
fixptcfg = coder.config('fixpt');
fixptcfg.TestBenchName = 'spectrometer_tb';

fixptcfg.ProposeFractionLengthsForDefaultWordLength=true;
fixptcfg.DefaultWordLength=32;
fixptcfg.ProposeWordLengthsForDefaultFractionLength=false;
fixptcfg.DefaultFractionLength=4;

% change settings
fixptcfg.LaunchNumericTypesReport = true;

% Create an 'hdl' config with default settings
hdlcfg = coder.config('hdl');
hdlcfg.TestBenchName = 'spectrometer_tb';

hdlcfg.GenerateHDLTestBench = true;
hdlcfg.EnableRate = "InputDataRate"; %"DUTBaseRate";
hdlCfg.MinimizeClockEnables = true;
hdlcfg.SimIndexCheck = true;

%codegen -float2fixed fixptcfg -config hdlcfg -args {int16(0),double(0),double(0),double(0),double(0)} weight_fold__instance_1_
%codegen -float2fixed fixptcfg -config hdlcfg -args {complex(0,0)} sfft 
%codegen -float2fixed fixptcfg -config hdlcfg -args {complex(0,0),true} deinterlace__instance_12_
codegen -float2fixed fixptcfg -config hdlcfg -args {complex(0,0),complex(0,0),int16(0),true} average__instance_P1_
%codegen -float2fixed fixptcfg -config hdlcfg -args {int16(0),int16(0)} spectrometer
%codegen -float2fixed fixptcfg -config hdlcfg -args {} weight_streamer

disp("Finished!")