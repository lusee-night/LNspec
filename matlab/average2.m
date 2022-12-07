function [outpk,ready_out] = average2(P1,P2,PR,PI, count, ready_in)
    persistent  Nac P1A P2A PRA PIA stream;

    if isempty(Nac)
        Nac = 0;
        P1A = zeros(2048);
        P2A = zeros(2048);
        PRA = zeros(2048);
        PIA = zeros(2048);
        stream = 0;
    end

    if (stream>0) & ready_in
        assert(false)
    end

    if (ready_in)
        P1A (count) = P1A(count) + P1;
        P2A (count) = P2A(count) + P2;
        PRA (count) = PRA(count) + PR;
        PIA (count) = PIA(count) + PI;
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
        outpk = [P1A(stream) P2A(stream) PRA(stream) PIA(stream)];
        P1A(stream) = 0;
        P2A(stream) = 0;
        PRA(stream) = 0;
        PIA(stream) = 0;
        
        stream = stream + 1;
        if stream>2048
            stream  = 0;
        end
    else
        ready_out = false;
        outpk = [0 0 0 0];
    end

end

