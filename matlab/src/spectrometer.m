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

    % placeholder
    ch3_val = ch1_val;
    ch4_val = ch2_val;
    
    [A1,A2,A3,A4,X12R,X12I,X13R,X13I,X14R,X14I,X23R,X23I,X24R,X24I,X34R,X34I] = correlate (ch1_val, ch2_val, ch3_val, ch4_val);
    
    [pk1, outbin, ready] = average_instance:P1_(A1, bin, cready);
    [pk2, outbin, ready] = average_instance:P2_(A2, bin, cready);
    [pkr, outbin, ready] = average_instance:P3_(X12R, bin, cready);
    [pki, outbin, ready] = average_instance:P4_(X12I, bin, cready);
    pks = [pk1,pk2,pkr,pki];
    c=c+1;
end

