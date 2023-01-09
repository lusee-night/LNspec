function val = weight_fold (sample, w1,w2,w3,w4 )
    persistent buf1 buf2 buf3 buf4 ndx

    sample = double(sample);
    
    if isempty(buf1)
        buf1 = zeros(1, {Nfft});
        buf2 = zeros(1, {Nfft});
        buf3 = zeros(1, {Nfft});
        buf4 = zeros(1, {Nfft});
        ndx  = 0;
    end

    c = mod(ndx,4096)+1;

    val1 = buf1(c) + sample * w1;
    val2 = buf2(c) + sample * w2;
    val3 = buf3(c) + sample * w3;
    val4 = buf4(c) + sample * w4;

    if (ndx + 1) <= {Nfft}
       val = val1;
       val1 = 0;
    elseif  ((ndx + 1) <= ({Nfft}*2))
       val = val2;
       val2 = 0;
    elseif  ((ndx + 1) <= {Nfft}*3)
       val = val3;
       val3  = 0; 
    else 
       val = val4;
       val4 = 0;
    end    

    buf1(c) = val1;
    buf2(c) = val2;
    buf3(c) = val3;
    buf4(c) = val4;

    ndx = ndx + 1;
    if ndx == {Nblock}
        ndx = 0;
    end
end



