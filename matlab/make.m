clear all

clean_dir();

resp = system("python3 make.py");
if (resp == 1)
    system("python3.10 make.py");
end

setenv('TMPDIR', getenv('PWD')+"/tmp")
setenv('GCC', "gcc-10")


% [fixptcfg,hdlcfg] = makecfg ();
% codegen -float2fixed fixptcfg -config hdlcfg -args {} weight_streamer
% 
% [fixptcfg,hdlcfg] = makecfg ();
% codegen -float2fixed fixptcfg -config hdlcfg -args {int16(0),double(0),double(0),double(0),double(0)} weight_fold_instance_1

% [fixptcfg,hdlcfg] = makecfg ();
% codegen -float2fixed fixptcfg -config hdlcfg -args {complex(0,0)} sfft 
% 
% [fixptcfg,hdlcfg] = makecfg ();
% codegen -float2fixed fixptcfg -config hdlcfg -args {complex(0,0),true} deinterlace_instance_12

% [fixptcfg,hdlcfg] = makecfg ();
% codegen -float2fixed fixptcfg -config hdlcfg -args {double(0),int16(0),true, 16, 0.0} average_instance_P1

% [fixptcfg,hdlcfg] = makecfg ();
% codegen -float2fixed fixptcfg -config hdlcfg -args {int16(0),int16(0)} spectrometer

[fixptcfg,hdlcfg] = makecfg ();
codegen -float2fixed fixptcfg -config hdlcfg -args {complex(0,0),complex(0,0),complex(0,0),complex(0,0)} correlate


disp("Finished!")

function [fixptcfg,hdlcfg] = makecfg ()
    % Create a 'fixpt' config with default settings
    fixptcfg = coder.config('fixpt');
    fixptcfg.TestBenchName = 'spectrometer_tb';

    fixptcfg.ProposeFractionLengthsForDefaultWordLength=true;
    fixptcfg.DefaultWordLength=32;
    fixptcfg.ProposeWordLengthsForDefaultFractionLength=false;
    fixptcfg.DefaultFractionLength=4;

    fixptcfg.addTypeSpecification('correlate', 'A1', numerictype(0,32,-16));
    fixptcfg.addTypeSpecification('correlate', 'A2', numerictype(0,32,-16));
    fixptcfg.addTypeSpecification('correlate', 'A3', numerictype(0,32,-16));
    fixptcfg.addTypeSpecification('correlate', 'A4', numerictype(0,32,-16));
    fixptcfg.addTypeSpecification('correlate', 'X12', numerictype(1,32,-16));
    fixptcfg.addTypeSpecification('correlate', 'X13', numerictype(1,32,-16));
    fixptcfg.addTypeSpecification('correlate', 'X14', numerictype(1,32,-16));
    fixptcfg.addTypeSpecification('correlate', 'X23', numerictype(1,32,-16));
    fixptcfg.addTypeSpecification('correlate', 'X24', numerictype(1,32,-16));
    fixptcfg.addTypeSpecification('correlate', 'X34', numerictype(1,32,-16));    
    fixptcfg.addTypeSpecification('correlate', 'X12R', numerictype(1,32,-16));
    fixptcfg.addTypeSpecification('correlate', 'X13R', numerictype(1,32,-16));
    fixptcfg.addTypeSpecification('correlate', 'X14R', numerictype(1,32,-16));
    fixptcfg.addTypeSpecification('correlate', 'X23R', numerictype(1,32,-16));
    fixptcfg.addTypeSpecification('correlate', 'X24R', numerictype(1,32,-16));
    fixptcfg.addTypeSpecification('correlate', 'X34R', numerictype(1,32,-16));
    fixptcfg.addTypeSpecification('correlate', 'X12I', numerictype(1,32,-16));
    fixptcfg.addTypeSpecification('correlate', 'X13I', numerictype(1,32,-16));
    fixptcfg.addTypeSpecification('correlate', 'X14I', numerictype(1,32,-16));
    fixptcfg.addTypeSpecification('correlate', 'X23I', numerictype(1,32,-16));
    fixptcfg.addTypeSpecification('correlate', 'X24I', numerictype(1,32,-16));
    fixptcfg.addTypeSpecification('correlate', 'X34I', numerictype(1,32,-16));
    fixptcfg.addTypeSpecification('correlate', 'ch1_val', numerictype(1,32, 5));
    fixptcfg.addTypeSpecification('correlate', 'ch2_val', numerictype(1,32, 5));
    fixptcfg.addTypeSpecification('correlate', 'ch3_val', numerictype(1,32, 5));
    fixptcfg.addTypeSpecification('correlate', 'ch4_val', numerictype(1,32, 5));


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
    hdlcfg.AdaptivePipelining = false;
    hdlcfg.DistributedPipelining = false;
    hdlcfg.RegisterInputs = false;
    hdlcfg.RegisterOutputs = false;
    hdlcfg.InputPipeline = 0;
    hdlcfg.OutputPipeline = 0;
    %hdlcfg.ConstantMultiplierOptimization = 'CSD';
    %hdlcfg.LoopOptimization = 'UnrollLoops';

    hdlcfg.SynthesisTool = 'MicroSemi Libero SoC';
    hdlcfg.SynthesisToolChipFamily = 'PolarFire';
    hdlcfg.SynthesisToolDeviceName = 'MPF500TS';
    hdlcfg.SynthesisToolPackageName = 'FCG1152';
    hdlcfg.SynthesisToolSpeedValue = '-1';
    hdlcfg.TargetFrequency =  150;
    hdlcfg.SynthesizeGeneratedCode = false;
    hdlcfg.PlaceAndRoute = false;
end

function clean_dir()
    if isfolder('codegen')
        rmdir 'codegen'  's';
    end
    
    dir_list = dir('*.m');
    for i = 1 : length(dir_list)
        name = dir_list(i).name;
        if matches(name,'make.m') == 0
            delete(name);
        end
    end
    disp("Directory cleaned")
end