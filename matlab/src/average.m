function [outpk, outbin, ready_out] = average(ch1_val, ch2_val, count, ready_in, Navg)
    persistent  Nac buf1 buf2 to1adr to2adr to1val to2val overN Nac_t ticktock;

    if isempty(Nac)
        Nac = Navg; 
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
    P = {part}(ch1_val*conj(ch2_val))*(1/Navg); % part will be replaced by preprocessor
    if (ready_in)
        ticktock = ~ticktock;
    end
    
    if ticktock
        if (ready_in)
            to1adr = count/2+0.5;
        else
            to1adr = int16({Nchan}/2+1);
        end
        to1val = buf1(to1adr)+P;
        if (Nac == 1) & (ready_in)
            outpk = to1val;
            outbin = count;
            to1val = 0;
            ready_out=true;
        end
        buf2(to2adr) = to2val;
    else
        if (ready_in)
            to2adr = count/2+1;
        else
            to2adr = int16({Nchan}/2+1);
        end
        to2val = buf2(to2adr)+P;
        value = to2val;
        if (Nac == 1) & (ready_in)
            outpk = to2val;
            outbin = count;
            to2val = 0;
            ready_out=true;
        end
        buf1(to1adr) = to1val;
    end

    Nac = Nac - ((ready_in) & (count == 1));
    if (Nac == 0);
        Nac = Navg;
    end

end

