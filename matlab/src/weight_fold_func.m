function val = weight_fold_func (sample, w1,w2,w3,w4 )
    persistent buf1 ndx
    if isempty(buf1)
        buf1 = zeros(1, {Nblock});
        ndx  = 0;
    end

    c = mod(ndx,{Nfft})+1;
    w = [w4 w3 w2 w1];
    for i=1:4
        buf1(c+{Nfft}*(i-1)) = buf1(c+{Nfft}*(i-1)) + sample*w(i);
    end

    val = buf1(ndx+1);
    buf1 (ndx+1) = 0.0;
            
    ndx = ndx + 1;
    if ndx == {Nblock}
        ndx = 0;
    end
end


