function [outpk, ready] = spectrometer (sample1, sample2)
    persistent c  buf1 buf2 tout pfb_weights dfft bc;
    coder.extrinsic('get_pfb_weights_4096_4');
    coder.extrinsic('settings_Nfft');

    if isempty(c)
        buf1 = zeros(coder.const(settings_Ntaps), coder.const(settings_Nfft));
        buf2 = zeros(coder.const(settings_Ntaps), coder.const(settings_Nfft));
        c = uint16(0); % we use 0-ordered for c
        tout = coder.const(settings_Ntaps);
        pfb_weights = coder.const(get_pfb_weights_4096_4(settings_Nfft,settings_Ntaps));
        %dfft=dsphdl.FFT('FFTLength',coder.const(settings_Nfft),'BitReversedOutput',false);
        dfft=dsphdl.FFT('FFTLength',4096,'BitReversedOutput',false);
        bc = 0;
    end
    k = mod(c,coder.const(settings_Nfft))+1;
    l = c+1;
    for i=1:coder.const(settings_Ntaps)
        buf1(i,k) = buf1(i,k) + sample1 * pfb_weights(l);
        buf2(i,k) = buf2(i,k) + sample2 * pfb_weights(l);
        %buf (i,k) = buf(i,k) + 1 * l;
        l = l + coder.const(settings_Nfft);
        if (l>coder.const(settings_Ntot))
            l = mod(l,coder.const(settings_Ntot));
        end
    end
    val = complex(buf1(tout,k), buf2(tout,k));
    [fft_out, fft_valid] = dfft(val', true);
    buf1(tout,k)=0.0;
    buf2(tout,k)=0.0;

    %fprintf ("%i %i %f\n",bc,fft_valid,fft_out)
    
    if k==coder.const(settings_Nfft)
        tout = tout - 1;
        if tout == 0
            tout = coder.const(settings_Ntaps);
        end
    end
    c = mod(c+1, coder.const(settings_Ntot));
    [outpk,ready] =  pk_accum(fft_out, fft_valid);
    bc = bc + 1;
end

