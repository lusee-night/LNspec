function [pks, ready] = spectrometer (sample1, sample2)

    persistent c
    if isempty(c)
        c=0;
    end
    
    [w1,w2,w3,w4] = weight_streamer();
    acc1 = weight_fold_func1(sample1, w1, w2, w3, w4);
    acc2 = weight_fold_func2(sample2, w1, w2, w3, w4);
    
    val = complex(acc1,acc2);
    [fft_val, fft_valid] = sfft(val');
    
    [P1, P2, PR, PI, bin, cready] = correlate(fft_val,fft_valid);

    [pk1, ready] = average21(P1,bin,cready);
    [pk2, ready] = average22(P2,bin,cready);
    [pkr, ready] = average23(PR,bin,cready);
    [pki, ready] = average24(PI,bin,cready);
    pks = [pk1,pk2,pkr,pki];
    %[pks, ready] = average2(P1,P2,PX,PR, bin, cready);
    c=c+1;
end

