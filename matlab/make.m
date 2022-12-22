clear all

system("python make.py");
setenv('TMPDIR', getenv('PWD')+"/tmp")
setenv('GCC', "gcc-10")

% Create a 'fixpt' config with default settings
fixptcfg = coder.config('fixpt');
fixptcfg.TestBenchName = 'spectrometer_tb';
fixptcfg.DefaultWordLength=32;
% change settings
fixptcfg.LaunchNumericTypesReport = true;

% Create an 'hdl' config with default settings
hdlcfg = coder.config('hdl');
hdlcfg.TestBenchName = 'spectrometer_tb';

hdlcfg.GenerateHDLTestBench = true;
hdlcfg.EnableRate = "InputDataRate"; %"DUTBaseRate";
hdlCfg.MinimizeClockEnables = true;

%codegen -float2fixed fixptcfg -config hdlcfg -args {0,0,int16(1)} add_prod
%codegen -float2fixed fixptcfg -config hdlcfg -args {int16(0),0,0,0,0} weight_fold_func1
%codegen -float2fixed fixptcfg -config hdlcfg -args {} weight_streamer
%codegen -float2fixed fixptcfg -config hdlcfg -args {complex(0,0)} sfft 
%codegen -float2fixed fixptcfg -config hdlcfg -args {complex(0,0),true} correlate
%codegen -float2fixed fixptcfg -config hdlcfg -args {0.1, 0.1, 0.1, 0.1, int16(1), true} average2
%codegen -float2fixed fixptcfg -config hdlcfg -args {0.1,  int16(1), true} average21
codegen -float2fixed fixptcfg -config hdlcfg -args {int16(0),int16(0)} spectrometer





