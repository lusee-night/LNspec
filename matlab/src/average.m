function [outpk, outbin, ready_out] = average(P, bin, ready_in)
    persistent  Nac buf1 buf2 to1adr to2adr to1val to2val overN Nac_t ticktock;

    if isempty(Nac)
        Nac = {Navg}; 
        buf1 = zeros(1,{Nchan}/2+1);
        buf2 = zeros(2,{Nchan}/2+1);
        to1adr = int16({Nchan}/2+1);
        to2adr = int16({Nchan}/2+1);
        to1val = 0;
        to2val = 0;
        ticktock = false;
    end
        
    ready_out = false;
    outbin = int16(0);
    outpk = 0;
    %if (ready_in)
    %    ticktock = ~ticktock;
    %end
    ticktock = mod(bin,2);

    if ticktock
        assert(mod(bin,2)==1)
        if (ready_in)
            to1adr = bin/2+1.5;
        else
            to1adr = int16({Nchan}/2+1);
        end
        to1val = buf1(to1adr)+P;
        if (Nac == 1) & (ready_in)
            outpk = to1val;
            outbin = bin;
            to1val = 0;
            ready_out=true;
        end
        buf2(to2adr) = to2val;
    else
        if (ready_in)
            to2adr = bin/2+1;
        else
            to2adr = int16({Nchan}/2+1);
        end
        to2val = buf2(to2adr)+P;
        value = to2val;
        if (Nac == 1) & (ready_in)
            outpk = to2val;
            outbin = bin;
            to2val = 0;
            ready_out=true;
        end
        buf1(to1adr) = to1val;
    end

    Nac = Nac - ((ready_in) & (bin == 0));
    if (Nac == 0);
        Nac = {Navg};
        ticktock = true;
    end

end