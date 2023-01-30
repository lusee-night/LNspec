function [outpk, outbin, ready_out] = noaverage(ch1_val, ch2_val, count, ready_in)
    persistent  Nac buf1 buf2 to1adr to2adr to1val to2val overN Nac_t ticktock;

    ready_out = ready_in;
    outbin = count;
    outpk = {part}(coder.hdl.pipeline(ch1_val*coder.hdl.pipeline(conj(ch2_val))));
end

