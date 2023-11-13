function [calbin, phase_cor, kar_out, tick_out, readyout, update_drift, readycal] = cal_phaser(bin_in, cal_drift, readyin)
    persistent phase Nac tick phase_st phase_mult2

    if isempty(phase)
        phase = 0.0;
        Nac = 1;
        tick = 1;
    end

    calbin = 0;
    phase_cor = complex(0,0);
    kar_out = 0;
    tick_out = tick;
    readycal = false;
    update_drift = false;
    readyout = false;

    
    
    if readyin
        if mod(bin_in,4)==2
            calbin = (bin_in+2)/4;
            kk = (2*calbin-1);
            kar = kk*(Nac-1); 
            kar_out = kar;
            readycal = true;
            if (calbin == 1) 
                phase_st = exp(complex(0,-phase));
                phase_mult2 = phase_st*phase_st;
            else
                phase_st = phase_st * phase_mult2; 
            end 

            phase_cor = phase_st;
            if Nac == ({NavgCal2})
                readyout = true;
            end
            if calbin == {Ncal}           
                Nac = Nac + 1;
                tick = tick*(-1);
                phase = phase+cal_drift;
                if (phase>pi)
                    phase = phase-2*pi;
                end
                if (phase<-pi)
                    phase = phase+2*pi;
                end
                if Nac > {NavgCal2}
                    update_drift = true;
                    Nac = 1;
                end
            end
        end
    end
end
