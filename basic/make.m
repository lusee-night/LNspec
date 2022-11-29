clear all
setenv('TMPDIR', getenv('PWD')+"/tmp")

% Create a 'fixpt' config with default settings
fixptcfg = coder.config('fixpt');
fixptcfg.TestBenchName = 'variance_tb';
% change settings
fixptcfg.SafetyMargin = 2;
fixptcfg.LaunchNumericTypesReport = true;

% Create an 'hdl' config with default settings
hdlcfg = coder.config('hdl');
hdlcfg.TestBenchName = 'variance_tb';
codegen -float2fixed fixptcfg -config hdlcfg variance_hdl
