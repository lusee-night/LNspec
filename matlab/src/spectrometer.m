function [pks, outbin, ready] = spectrometer (sample1, sample2)

    persistent c
    if isempty(c)
        c=0;
    end
    
    [w1,w2,w3,w4] = weight_streamer();
    acc1 = weight_fold_func__instance:1__(sample1, w1, w2, w3, w4);
    acc2 = weight_fold_func__instance:2__(sample2, w1, w2, w3, w4);
    
    val = complex(acc1,acc2);
    [fft_val, fft_valid] = sfft(val');
    
    [ch1_val, ch2_val, bin, cready ] = deinterlace__instance:12__(fft_val, fft_valid);

    [pk1, outbin, ready] = average__instance:P1:part=real__(ch1_val, ch1_val, bin, cready);
    [pk2, outbin, ready] = average__instance:P2:part=real__(ch2_val, ch2_val, bin, cready);
    [pkr, outbin, ready] = average__instance:P3:part=real__(ch1_val, ch2_val, bin, cready);
    [pki, outbin, ready] = average__instance:P4:part=imag__(ch1_val, ch2_val, bin, cready);
    pks = [pk1,pk2,pkr,pki];
    %[pks, ready] = average2(P1,P2,PX,PR, bin, cready);
    c=c+1;
end

