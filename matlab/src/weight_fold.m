function val = weight_fold (sample, w1,w2,w3,w4 )
    persistent buf1 buf2 buf3 buf4 ndx bndx

    sample = double(sample);
    if isempty(buf1)
        buf1 = zeros(1, {Nfft});
        buf2 = zeros(1, {Nfft});
        buf3 = zeros(1, {Nfft});
        buf4 = zeros(1, {Nfft});
        ndx = 0;
        bndx = 0;
    end
    
    assert({Ntaps}==4);

    v1 = ramwrap_instance:{parent}_1_(ndx, sample, bndx==0);
    v2 = ramwrap_instance:{parent}_2_(ndx, sample, bndx==1);
    v3 = ramwrap_instance:{parent}_3_(ndx, sample, bndx==2);
    v4 = ramwrap_instance:{parent}_4_(ndx, sample, bndx==3);

    val = v1*w1+v2*w2+v3*w3+v4*w4;

    ndx = ndx + 1;
    if (ndx=={Nfft})
        ndx = 0; 
        bndx = bndx + 1;
        if (bndx=={Ntaps})
            bndx=0;
        end
    end
        
end


