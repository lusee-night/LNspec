function [outpk, ready] = spectrometer (sample)
    persistent c  buf tout pfb_weights;
    if isempty(c)
        buf = zeros(coder.const(settings_Ntaps), coder.const(settings_Nfft));
        c = uint16(0); % we use 0-ordered for c
        tout = coder.const(settings_Ntaps);
        outpk = zeros(1,coder.const(settings_Nchan));
        pfb_weights = coder.const(get_pfb_weights_256_4(settings_Nfft,settings_Ntaps));
        ready = false;
    end
    k = mod(c,coder.const(settings_Nfft))+1;
    l = c+1;
    for i=1:coder.const(settings_Ntaps)
        buf(i,k) = buf(i,k) + sample * pfb_weights(l);
        %buf (i,k) = buf(i,k) + 1 * l;
        l = l + coder.const(settings_Nfft);
        if (l>coder.const(settings_Ntot))
            l = mod(l,coder.const(settings_Ntot));
        end
    end
    if k==coder.const(settings_Nfft)
        [outpk, ready] = pk_accum(buf(tout,:));
        buf(tout,:) = zeros(1,coder.const(settings_Nfft));
        tout = tout - 1;
        if tout == 0
            tout = coder.const(settings_Ntaps);
        end
    else
        outpk = zeros(1,coder.const(settings_Nchan));
        ready = false;
    end
    c = mod(c+1, coder.const(settings_Ntot));
end

