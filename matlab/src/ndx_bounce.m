function lp = ndx_bounce(l)
    if (l<{Nfft}*{Ntaps}/2)
        lp = l;
    else
        lp = {Nfft}*{Ntaps}-l-1;
    end
end

