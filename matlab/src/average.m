function [outpk, outbin, ready_out] = average(P, bin, ready_in, Navg, notch_avg)
    persistent  Nac buf1 buf2 to1adr to2adr to1val to2val Nac_t ticktock norm;

    if isempty(Nac)
        Nac = Navg; 
        buf1 = zeros(1,{Nchan}/2+1);
        buf2 = zeros(2,{Nchan}/2+1);
        to1adr = int16({Nchan}/2+1);
        to2adr = int16({Nchan}/2+1);
        to1val = 0;
        to2val = 0;
        ticktock = false;
        % In matlab, we normalize by multiplying by the correct
        % factor. In VHDL, we instead do division by right-shifting.
        % For notch average, we have 1/N*sqrt(N) = 1/sqrt(N)
        if notch_avg
            norm = 1/sqrt(Navg);
        else
            norm = 1/Navg;  
        end
    end
    
    ready_out = false;
    outbin = int16(0);
    outpk = 0;
    ticktock = (mod(bin,2)==1);

    if ticktock
        assert(mod(bin,2)==1)
        if (ready_in)
            to1adr = bin/2+0.5;
        else
            to1adr = int16({Nchan}/2+1);
        end
        to1val = buf1(to1adr)+real(P);
        if (Nac == 1) & (ready_in)
            outpk = to1val*norm;
            outbin = bin;
            to1val = 0;
            ready_out=true;
        end
        buf2(to2adr) = real(to2val);
    else
        if (ready_in)
            to2adr = bin/2+1;
        else
            to2adr = int16({Nchan}/2+1);
        end
        to2val = buf2(to2adr)+real(P);
        value = to2val;
        if (Nac == 1) & (ready_in)
            outpk = to2val*norm;
            outbin = bin;
            to2val = 0;
            ready_out=true;
        end
        buf1(to1adr) = real(to1val);
    end

    Nac = Nac - ((ready_in) & (bin == 0));
    if (Nac == 0);
        Nac = Navg;
        ticktock = true;
    end

end