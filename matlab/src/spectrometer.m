function [pks, outbin, ready] = spectrometer (sample1, sample2)

    persistent c
    if isempty(c)
        c=0;
    end
    
    [w1,w2,w3,w4] = weight_streamer();
    %[w1,w2,w3,w4] = weight_streamer_alt1();
    %[w1,w2,w3,w4] = weight_streamer_alt2();

    acc1 = weight_fold_instance:1_(sample1, w1, w2, w3, w4);
    acc2 = weight_fold_instance:2_(sample2, w1, w2, w3, w4);

    val = complex(acc1,acc2);
    [fft_val, fft_valid] = sfft(val');
    
    [ch1_val, ch2_val, bin, cready ] = deinterlace_instance:12_(fft_val, fft_valid);

    [pk1, outbin, ready] = average_instance:P1:part=real_(ch1_val, ch1_val, bin, cready);
    [pk2, outbin, ready] = average_instance:P2:part=real_(ch2_val, ch2_val, bin, cready);
    [pkr, outbin, ready] = average_instance:P3:part=real_(ch1_val, ch2_val, bin, cready);
    [pki, outbin, ready] = average_instance:P4:part=imag_(ch1_val, ch2_val, bin, cready);
    pks = [pk1,pk2,pkr,pki];
    c=c+1;
end

