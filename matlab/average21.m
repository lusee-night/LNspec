function [outpk,ready_out] = average21(P1, count, ready_in)
    persistent  Nac P1A stream;

    if isempty(Nac)
        Nac = 0;
        P1A = zeros(1,2048);
        stream = 0;
    end


    if (ready_in)
        P1A (count) = P1A(count) + P1;
    end
    
    if ready_in & (count == 1)
        Nac = Nac + 1;
        if (Nac == 4);
            stream = 1;
            Nac = 0;
        end
    end

    if stream > 0 
        ready_out = true;
        outpk = P1A(stream);
        P1A(stream) = 0;

        stream = stream + 1;
        if stream>2048
            stream  = 0;
        end
    else
        ready_out = false;
        outpk = 0;
    end

end

