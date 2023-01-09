function val = weight_fold (sample, w1,w2,w3,w4 )
    persistent buf1 buf2 buf3 buf4 ndx bndx
    
    if isempty(buf1)
        buf1 = zeros(1, {Nfft});
        buf2 = zeros(1, {Nfft});
        buf3 = zeros(1, {Nfft});
        buf4 = zeros(1, {Nfft});
        ndx = 0;
        bndx = 0;
    end
    
    assert({Ntaps}==4);

    if (bndx==0)
        buf1(ndx+1) = sample;
    elseif (bndx==1)
        buf2(ndx+1) = sample;
    elseif (bndx==2)
        buf3(ndx+1) = sample;
    else
        buf4(ndx+1) = sample;
    end

    val = buf1(ndx+1)*w1+buf2(ndx+1)*w2+buf3(ndx+1)*w3+buf4(ndx+1)*w4;
    
    ndx = ndx + 1;
    if (ndx=={Nfft})
        ndx = 0; 
        bndx = bndx + 1;
        if (bndx=={Ntaps})
            bndx=0;
        end
    end
        
end


