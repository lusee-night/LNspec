clear all

resp = system("python make.py");
if (resp == 1)
    system("python3.10 make.py");
end

setenv('TMPDIR', getenv('PWD')+"/tmp")
setenv('GCC', "gcc-10")


[fixptcfg,hdlcfg] = makecfg ();
codegen -float2fixed fixptcfg -config hdlcfg -args {} weight_streamer

% [fixptcfg,hdlcfg] = makecfg ();
% codegen -float2fixed fixptcfg -config hdlcfg -args {int16(0),double(0),double(0),double(0),double(0)} weight_fold_instance_1

% [fixptcfg,hdlcfg] = makecfg ();
% codegen -float2fixed fixptcfg -config hdlcfg -args {complex(0,0)} sfft 

% [fixptcfg,hdlcfg] = makecfg ();
% codegen -float2fixed fixptcfg -config hdlcfg -args {complex(0,0),true} deinterlace_instance_12

% [fixptcfg,hdlcfg] = makecfg ();
% codegen -float2fixed fixptcfg -config hdlcfg -args {complex(0,0),complex(0,0),int16(0),true} noaverage_instance_P1

%[fixptcfg,hdlcfg] = makecfg ();
%codegen -float2fixed fixptcfg -config hdlcfg -args {complex(0,0),complex(0,0),int16(0),true} average_instance_P1

% [fixptcfg,hdlcfg] = makecfg ();
% codegen -float2fixed fixptcfg -config hdlcfg -args {int16(0),int16(0)} spectrometer


disp("Finished!")

function [fixptcfg,hdlcfg] = makecfg ()
    % Create a 'fixpt' config with default settings
    fixptcfg = coder.config('fixpt');
    fixptcfg.TestBenchName = 'spectrometer_tb';

    fixptcfg.ProposeFractionLengthsForDefaultWordLength=true;
    fixptcfg.DefaultWordLength=32;
    fixptcfg.ProposeWordLengthsForDefaultFractionLength=false;
    fixptcfg.DefaultFractionLength=4;

    % change settings
    %fixptcfg.LaunchNumericTypesReport = true;

    % Create an 'hdl' config with default settings
    hdlcfg = coder.config('hdl');
    hdlcfg.TestBenchName = 'spectrometer_tb';

    hdlcfg.MATLABSourceComments = true;

    hdlcfg.GenerateHDLTestBench = true;
    hdlcfg.EnableRate = "InputDataRate"; %"DUTBaseRate";
    %hdlcfg.MinimizeClockEnables = true;

    hdlcfg.SimIndexCheck = true;
    hdlcfg.AdaptivePipelining = true;
    hdlcfg.DistributedPipelining = false;
    hdlcfg.InputPipeline = 0;
    hdlcfg.OutputPipeline = 0;

    hdlcfg.SynthesisTool = 'MicroSemi Libero SoC';
    hdlcfg.SynthesisToolChipFamily = 'PolarFire';
    hdlcfg.SynthesisToolDeviceName = 'MPF500TS';
    hdlcfg.SynthesisToolPackageName = 'FCG1152';
    hdlcfg.SynthesisToolSpeedValue = '-1';
    hdlcfg.TargetFrequency =  100;
    hdlcfg.SynthesizeGeneratedCode = true;
    hdlcfg.PlaceAndRoute = true;
end

