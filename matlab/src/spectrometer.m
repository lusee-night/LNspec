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

    
    A1N=0; A2N=0; A3N=0; A4N=0; X12RN=0; X12IN=0; X13RN=0; X13IN=0; X14RN=0; X14IN=0; X23RN=0; X23IN=0; X24RN=0; X24IN=0; X34RN=0; X34IN=0;
    if {Nnotch}>0
        [ch1_notch_real, noutbin, nready] = average_instance:N1_(real(ch1_val), bin, cready,{Nnotch}, 0);
        [ch1_notch_imag, noutbin, nready] = average_instance:N2_(imag(ch1_val), bin, cready,{Nnotch}, 0);
        [ch2_notch_real, noutbin, nready] = average_instance:N3_(real(ch2_val), bin, cready,{Nnotch}, 0);
        [ch2_notch_imag, noutbin, nready] = average_instance:N4_(imag(ch2_val), bin, cready,{Nnotch}, 0);
        if nready
            assert(noutbin==bin);
    
            ch1_notch = complex(ch1_notch_real, ch1_notch_imag)/sqrt({Nnotch});
            ch2_notch = complex(ch2_notch_real, ch2_notch_imag)/sqrt({Nnotch});
            ch3_notch = ch1_notch;
            ch4_notch = ch2_notch;
            [A1N,A2N,A3N,A4N,X12RN,X12IN,X13RN,X13IN,X14RN,X14IN,X23RN,X23IN,X24RN,X24IN,X34RN,X34IN] = ...
                 correlate (ch1_notch, ch2_notch, ch3_notch, ch4_notch);

        end
    end

    [pk1, outbin, ready] = average_instance:P1_(A1, bin, cready,{Navg}, A1N);
    [pk2, outbin, ready] = average_instance:P2_(A2, bin, cready,{Navg}, A2N);
    [pkr, outbin, ready] = average_instance:P3_(X12R, bin, cready,{Navg},X12RN);
    [pki, outbin, ready] = average_instance:P4_(X12I, bin, cready, {Navg},X12IN);
 
    pks = [pk1,pk2,pkr,pki];
    c=c+1;
end

