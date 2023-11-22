function [calbin, phase_cor, kar_out, tick_out, readyout, update_drift, readycal] = cal_phaser_alt(bin_in, cal_drift, readyin)
    persistent phase Nac tick phase_st phase_mult2 run_cordic cordic_out

    if isempty(phase)
        phase = 0.0;
        Nac = 1;
        tick = 1;
        phase_st = complex(1,0);
        phase_mult2 = phase_st*phase_st;
        run_cordic = false;
        cordic_out = complex(1,0);
    end

    calbin = 0;
    phase_cor = complex(0,0);
    kar_out = 0;
    tick_out = tick;
    readycal = false;
    update_drift = false;
    readyout = false;

    %% we should have spare cycles to do cordic stuff
    
    if run_cordic
        cordic_out = complex(mycos(-phase), mysin(-phase));
        run_cordic = false;
    end

    
    if readyin
        %modbin = mod(bin_in,4);
        % this really sucks balls
        modbin = bin_in-bitshift(bitshift(bin_in,-2),+2);
        if modbin==2
            calbin = (bin_in+2)/4;
            kk = (2*calbin-1);
            kar = kk*(Nac-1); 
            kar_out = kar;
            readycal = true;
            if (calbin == 1) 
                %phase_st = exp(complex(0,-phase));
                phase_st = cordic_out;
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
                % now we have new phase, get new sin / cos
                run_cordic = true;

                if Nac > {NavgCal2}
                    update_drift = true;
                    Nac = 1;
                end
            end
        end
    end
end
