function [outpk, outbin, ready_out] = average(ch1_val, ch2_val, count, ready_in)
    persistent  Nac P1A stream overN;

    if isempty(Nac)
        Nac = 0;
        P1A = zeros(1,{Nchan});
        stream = 0;
        overN = {overNavg};
    end
    ready_out = false;
    outbin = 0;
    outpk = 0;
    
    if (ready_in)
        P1 = {part}(ch1_val*conj(ch2_val)); % part will be replaced by preprocessor
        P1A (count) = P1A(count) + P1*{overNavg};
    
        if (count == 1)
            Nac = Nac + 1;
            if (Nac == {Navg});
                ready_out = true;
                outpk = P1A(1);
                P1A(1) = 0;
                stream = 2;
                % outbin is zero anyways
                Nac = 0;
            end
        end
    else    
        if (stream>0)
            ready_out = true;
            outpk = P1A(stream);
            outbin = stream-1;
            P1A(stream)=0;
            stream = stream + 1;
            if stream>{Nchan}
                stream  = 0;
            end
        end
    end
end

