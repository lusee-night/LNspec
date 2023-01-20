function [w1,w2,w3,w4] = weight_streamer_alt1()
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
    if (ndx==0)
        w1 = b1; w2=b2; w3=b3; w4=b4;
    elseif (ndx==1)
        w1 = b2; w2=b3; w3=b4; w4=b1;
    elseif (ndx==2)
        w1 = b3; w2=b4; w3=b1; w4=b2;
    else 
        w1 = b4; w2=b1; w3=b2; w4=b3;
    end

    l = count_up__instance:wsl:over={Nfft}__(l);
    if l==0
        ndx = count_up__instance:wsndx:over={Ntaps}__(ndx);
    end
end
