function [ch_val_notch, nready] = notch(ch_val, count, ready_in)
    persistent  Nac buf1 buf2 ticktock to1adr to1val to2adr to2val;

    if isempty(Nac)
        Nac = {Navg};
        buf1 = complex(zeros(1,{Nchan}/2+1));
        buf2 = complex(zeros(1,{Nchan}/2+1));
        to1adr = int16({Nchan}/2+1);
        to1val = complex(0,0);
        to2adr = int16({Nchan}/2+1);
        to2val = complex(0,0);
        ticktock = true;
    end
        
    nready = false;
    ch_val_notch = complex(0,0);

    if (ready_in)
        ticktock = ~ticktock;
        if (count == {Nchan}-1)
            ticktock = true;
        end
    end
    
    if ticktock
        if (ready_in)
            to1adr = int16(count/2+1);
        else
            to1adr = int16({Nchan}/2+1);
        end
        to1val = buf1(to2adr)+ch_val;
        if (Nac == 1) & (ready_in)
            nready = true;
            ch_val_notch = to1val;
            to1val = complex(0,0);
        end
        buf2(to2adr) = to2val;
    else
        if (ready_in)
            to2adr = int16(count/2+1);
        else
            to2adr = int16({Nchan}/2+1);
        end
        to2val = buf2(to2adr)+ch_val;
        if (Nac == 1) & (ready_in)
            nready = true;
            ch_val_notch = to2val;
            to2val = complex(0,0);
        end
        buf1(to1adr) = to1val;
    end

    Nac = Nac - coder.hdl.pipeline(((ready_in) & (count == 1)));
    if (Nac == 0);
        Nac = {Navg};
    end

end

