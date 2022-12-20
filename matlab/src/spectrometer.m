function [pks, ready] = spectrometer (sample1, sample2)

    persistent c
    if isempty(c)
        c=0;
    end
    
    [w1,w2,w3,w4] = weight_streamer();
    acc1 = weight_fold_func__instance:1__(sample1, w1, w2, w3, w4);
    acc2 = weight_fold_func__instance:2__(sample2, w1, w2, w3, w4);
    
    val = complex(acc1,acc2);
    [fft_val, fft_valid] = sfft(val');
    
    [P1, P2, PR, PI, bin, cready] = correlate(fft_val,fft_valid);

    [pk1, ready] = average__instance:P1__(P1,bin,cready);
    [pk2, ready] = average__instance:P2__(P2,bin,cready);
    [pkr, ready] = average__instance:P3__(PR,bin,cready);
    [pki, ready] = average__instance:P4__(PI,bin,cready);
    pks = [pk1,pk2,pkr,pki];
    %[pks, ready] = average2(P1,P2,PX,PR, bin, cready);
    c=c+1;
end

