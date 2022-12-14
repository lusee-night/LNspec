function [pks, ready] = spectrometer (sample1, sample2)

    persistent c
    if isempty(c)
        c=0;
    end
    
    [w1,w2,w3,w4] = weight_streamer();
    acc1 = weight_fold_func1(sample1, w1, w2, w3, w4);

    acc2 = weight_fold_func2(sample2, w1, w2, w3, w4);
 
    %disp([c,acc1,acc2]);
    %assert(acc1==acc2)
    %acc2 = weight_fold_func2(sample2, w1, w2, w3, w4);
    
    val = complex(acc1,acc2);
    [fft_out, fft_valid] = sfft(val');
    
    [P1,P2,PX,PR, bin, cready] = correlate(fft_out,fft_valid);
    [pk1, ready] = average21(P1,bin,cready);
    [pk2, ready] = average22(P2,bin,cready);
    [pkr, ready] = average23(PX,bin,cready);
    [pki, ready] = average24(PR,bin,cready);
    pks = [pk1,pk2,pkr,pki];
    %[pks, ready] = average2(P1,P2,PX,PR, bin, cready);
    c=c+1;
end

