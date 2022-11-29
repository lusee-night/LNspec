function [w1,w2,w3,w4] = weight_streamer()
    persistent l pfb_weights
    coder.extrinsic('get_pfb_weights_4096_4');
    if isempty(l)
        pfb_weights = coder.const(get_pfb_weights_4096_4(settings_Nfft,settings_Ntaps));
        l = 0;
    end
    w1 = pfb_weights(l+1); 
    w2 = pfb_weights(mod(l+4096,16384)+1); 
    w3 = pfb_weights(mod(l+8192,16384)+1);
    w4 = pfb_weights(mod(l+12288,16384)+1);
    l = l+1;
    if (l == 16384)
        l = 0;
    end
end
