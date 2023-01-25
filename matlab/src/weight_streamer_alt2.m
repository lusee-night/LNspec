function [w1,w2,w3,w4] = weight_streamer_alt2()
    persistent l ndx pfb_weights buf1 buf2 buf3 buf4;
    coder.extrinsic('get_pfb_weights_{Nfft}_{Ntaps}');
    if isempty(l)
        assert({Ntaps}==4)
        buf1 = coder.const(get_pfb_weights_separate_1_{Nfft}_{Ntaps}({Nfft},{Ntaps}));
        buf2 = coder.const(get_pfb_weights_separate_2_{Nfft}_{Ntaps}({Nfft},{Ntaps}));
        buf3 = coder.const(get_pfb_weights_separate_3_{Nfft}_{Ntaps}({Nfft},{Ntaps}));
        buf4 = coder.const(get_pfb_weights_separate_4_{Nfft}_{Ntaps}({Nfft},{Ntaps}));
        l = int16(0);
        ndx = int16(0);
    end

    b1 = buf1(l+1);
    b2 = buf2(l+1);
    b3 = buf3(l+1);
    b4 = buf4(l+1);

    l1 = (ndx==0);
    l2 = (ndx==1);
    l3 = (ndx==2);
    l4 = (ndx==3);
    
    w1 = b1*l1+b2*l2+b3*l3+b4*l4;
    w2 = b2*l1+b3*l2+b4*l3+b1*l4;
    w3 = b3*l1+b4*l2+b1*l3+b2*l4;
    w4 = b4*l1+b1*l2+b2*l3+b3*l4;
    
    l = count_up_instance:wsl:over={Nfft}_(l);
    if l==0
        ndx = count_up_instance:wsndx:over={Ntaps}_(ndx);
    end
end
