function val = chain_fold (sample, w1,w2,w3,w4 )
    persistent buf
    if isempty(buf)
        buf = zeros(1, {Nfold});
    end

    assert({Ntaps}==4);
    fsample=cast(sample,"double");

    val = buf(1)*w1+buf({Nfft}+1)*w2+buf(2*{Nfft}+1)*w3+fsample*w4;

    for i=1:{Nfold}-1
        buf(i) = buf(i+1);
    end
    
    buf({Nfold}) = fsample;
end


