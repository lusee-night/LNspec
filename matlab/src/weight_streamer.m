function [w1,w2,w3,w4] = weight_streamer()
    persistent l1 l2 l3 l4 pfb_weights
    coder.extrinsic('get_pfb_weights_{Nfft}_{Ntaps}');
    if isempty(l1)
        pfb_weights = coder.const(get_pfb_weights_{Nfft}_{Ntaps}({Nfft},{Ntaps}));
        l1 = int16(0);
        l2 = int16({Nfft});
        l3 = int16({Nfft}*2);
        l4 = int16({Nfft}*3);
    end
    w1 = pfb_weights(l1+1); 
    w2 = pfb_weights(l2+1);
    w3 = pfb_weights(l3+1);
    w4 = pfb_weights(l4+1);
    l1 = count_up_instance:l1:over={Nblock}_(l1);
    l2 = count_up_instance:l2:over={Nblock}_(l2);
    l3 = count_up_instance:l3:over={Nblock}_(l3);
    l4 = count_up_instance:l4:over={Nblock}_(l4);
end
