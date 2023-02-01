function [outpk, outbin, ready_out] = average(ch1_val, ch2_val, count, ready_in, ch1_val_notch, ch2_val_notch, nready)
    persistent  Nac buf1 buf2 to1adr to2adr to1val to2val overN Nac_t ticktock;

    if isempty(Nac)
        Nac = {Navg}; 
        buf1 = zeros(1,{Nchan}/2+1);
        buf2 = zeros(2,{Nchan}/2+1);
        to1adr = int16({Nchan}/2+1);
        to2adr = int16({Nchan}/2+1);
        to1val = 0;
        to2val = 0;
        ticktock = true;
    end
        
    ready_out = false;
    outbin = int16(0);
    outpk = 0;
    P = {part}(coder.hdl.pipeline(ch1_val*coder.hdl.pipeline(conj(ch2_val))));
    if (ready_in)
        ticktock = ~ticktock;
        if (count == {Nchan}-1)
            ticktock = true;
        end
    end
    
    if ticktock
        if (ready_in)
            to1adr = int16((count+1)/2);
        else
            to1adr = int16({Nchan}/2+1);
        end
        to1val = buf1(to1adr)+P;
        if (Nac == 1) & (ready_in)
            assert(nready)
            Pn = {part}(coder.hdl.pipeline(ch1_val_notch*coder.hdl.pipeline(conj(ch2_val_notch))));
            outpk = to1val-Pn*({overNavg});
            outbin = count;
            to1val = 0;
            ready_out=true;
        end
        buf2(to2adr) = to2val;
    else
        if (ready_in)
            to2adr = int16(count/2+1);
        else
            to2adr = int16({Nchan}/2+1);
        end
        to2val = buf2(to2adr)+P;
        if (Nac == 1) & (ready_in)
            assert(nready)
            Pn = {part}(coder.hdl.pipeline(ch1_val_notch*coder.hdl.pipeline(conj(ch2_val_notch))));
            outpk = to2val-Pn*({overNavg});
            outbin = count;
            to2val = 0;
            ready_out=true;
        end
        buf1(to1adr) = to1val;
    end

    Nac = Nac - coder.hdl.pipeline(((ready_in) & (count == 1)));
    if (Nac == 0);
        Nac = {Navg};
    end

end

    

