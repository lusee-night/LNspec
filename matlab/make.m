clear all
setenv('TMPDIR', getenv('PWD')+"/tmp")

% Create a 'fixpt' config with default settings
fixptcfg = coder.config('fixpt');
fixptcfg.TestBenchName = 'spectrometer_tb';
% change settings
fixptcfg.LaunchNumericTypesReport = true;

% Create an 'hdl' config with default settings
hdlcfg = coder.config('hdl');
hdlcfg.TestBenchName = 'variance_tb';
<<<<<<< HEAD
hdlcfg.GenerateHDLTestBench = true;
%codegen -float2fixed fixptcfg -config hdlcfg -args {int16(0),0,0,0,0} convolver
=======
codegen -float2fixed fixptcfg -config hdlcfg -args {int16(0),0,0,0,0} convolver
>>>>>>> 1aeb594a72550e9689cac4dae449f013c2559eea
%codegen -float2fixed fixptcfg -config hdlcfg -args {} weight_streamer
%codegen -float2fixed fixptcfg -config hdlcfg -args {complex(0,0)} sfft 
%codegen -float2fixed fixptcfg -config hdlcfg -args {complex(0,0),true} pk_accum




