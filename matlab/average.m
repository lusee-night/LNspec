function [outpk,ready_out] = average(P1,P2,PR,PI, count, ready_in)
    persistent  Nac accum outbuf stream;
    %assert(isa(count,'int16'))
    if isempty(Nac)
        Nac = 0;
        accum = zeros(4,coder.const(settings_Nchan));
        outbuf = zeros(4,coder.const(settings_Nchan));
        stream = 0;
    end
    if (ready_in)
        accum(1,count) = accum(1,count) + P1;
        accum(2,count) = accum(2,count) + P2;
        accum(3,count) = accum(3,count) + PR;
        accum(4,count) = accum(4,count) + PI;
    end
    
    if ready_in & (count == 1)
        Nac = Nac + 1;
        if (Nac == coder.const(settings_Navg));
            outbuf = accum;
            stream = 1;
            Nac = 0;
            accum = zeros(4,coder.const(settings_Nchan));
        end
    end
        
    if stream
        ready_out = true;
        outpk = outbuf(:,stream);
        stream = stream + 1;
        if stream>coder.const(settings_Nchan)
            stream  = 0;
        end
    else
        ready_out = false;
        outpk = zeros(4,1);
    end
end

