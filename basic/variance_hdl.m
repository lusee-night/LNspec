function [var,ready] = variance_hdl (sample1)
    persistent c var_acc 

    if isempty(c)
        c=0;
        var_acc = 0.0; 
    end
    sample_d = double(sample1);
    var_acc = var_acc + (sample_d*sample_d)/(32768.*32768.); %* double(sample1);
    c = c + 1;
    if (c == 4096)
        var = var_acc / 4096;
        ready = true;
        c = 0;
        var_acc = 0;
    else
        ready = false;
        var = 0;
    end
end

