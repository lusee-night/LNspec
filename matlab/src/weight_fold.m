function val = weight_fold (sample, w1,w2,w3,w4 )
    persistent buf ndx bndx
    
    if isempty(buf)
        buf = zeros(1, {Nblock});
        ndx = 0;
        bndx = 0;
    end
    
    assert({Ntaps}==4);

    buf(ndx+1) = sample;

    val = buf(bndx+1)*w1+buf({Nfft}+bndx+1)*w2+buf({Nfft}*2+bndx+1)*w3+buf({Nfft}*3+bndx+1)*w4;
    
    ndx = ndx + 1;
    if (ndx=={Nblock})
        ndx = 0;
    end

    bndx = bndx + 1;
    if (bndx=={Nfft})
        bndx=0;
    end
end


