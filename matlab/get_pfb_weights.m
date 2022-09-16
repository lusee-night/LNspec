function out = get_pfb_weights(Nfft,Ntaps)
    Ntot = Nfft*Ntaps;
    xp = -Ntot/2+0.5:+Ntot/2;
    xp = (double(xp)/double(Nfft))*pi;
    out = zeros(1,Ntot)+1;
    for i=1:Ntot
        x = xp(i);
        if (x~=0)
            out(i)=sin(x)/x;
        end
    end
end
