function val = weight_fold_func1 (sample, w1,w2,w3,w4 )
    persistent buf1 c tout 
    if isempty(buf1)
            buf1 = zeros(1, 16384);
            c = uint16(1); % we use 0-ordered for c
            tout = uint16(1);
    end

    buf1(c) = buf1(c) + sample * w4;
    buf1(c+4096) = buf1(c+4096) + sample * w3;
    buf1(c+8192) = buf1(c+8192) + sample * w2;
    buf1(c+12288) = buf1(c+12288) + sample * w1;

    ndx = (tout-1)*4096+c;
    val = buf1(ndx);
    buf1 (ndx) = 0.0;
            
    c = c+1;
    if c==4097
        c = uint16(1);
        tout = tout + 1;
        if tout == 5
            tout = uint16(1);
        end
    end
end


