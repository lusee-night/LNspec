function [outpk,ready_out] = average22(P1, count, ready_in)
    persistent  Nac P1A P1S stream;

    if isempty(Nac)
        Nac = 0;
        P1A = zeros(1,2048);
        stream = 0;
    end
    ready_out = false;
    outpk = 0;
    
    
    if (ready_in)
        P1A (count) = P1A(count) + P1;
    
        if (count == 1)
            Nac = Nac + 1;
            if (Nac == 4);
                ready_out = true;
                outpk = P1A(1);
                P1A(1) = 0;
                stream = 2;
                Nac = 0;
            end
        end
    else    
        if (stream>0)
            ready_out = true;
            outpk = P1A(stream);
            P1A(stream)=0;
            stream = stream + 1;
            if stream>2048
                stream  = 0;
            end
        end
    end

end

