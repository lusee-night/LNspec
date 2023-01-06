function [w1,w2,w3,w4] = weight_streamer()
    persistent l pfb_weights
    coder.extrinsic('get_pfb_weights_{Nfft}_{Ntaps}');
    if isempty(l)
        pfb_weights = coder.const(get_pfb_weights_{Nfft}_{Ntaps}({Nfft},{Ntaps}));
        l = 0;
    end
    w1 = pfb_weights(l+1); 
    w2 = pfb_weights(mod(l+{Nfft},{Nblock})+1); 
    w3 = pfb_weights(mod(l+{Nfft}*2,{Nblock})+1);
    w4 = pfb_weights(mod(l+{Nfft}*3,{Nblock})+1);
    l = l+1;
    if (l == {Nfft})
        l = 0;
    end
end
