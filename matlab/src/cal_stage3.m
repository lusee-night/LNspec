function [goutreal1, goutimag1, goutreal2, goutimag2, goutreal3, goutimag3, goutreal4, goutimag4, gphase, gout_ready] = cal_stage3 (calbin, kar, foutreal1, foutimag1, foutreal2, foutimag2, foutreal3, foutimag3, foutreal4, foutimag4, corout1, corout2, corout3, corout4, fout_ready)

    persistent state accum cur fd sd phase phase_st phase_mult2 Nacc3

    if isempty(state)
        state = 0;
        accum = complex(zeros({Nchan},4),zeros({Nchan},4));
        cur = complex(zeros({Nchan},4),zeros({Nchan},4));
        fd = 0;
        sd = 0;
        phase = 0;
        phase_st = complex (0,0);
        phase_mult2 = complex (0,0);
        Nacc3 = 0;
    end

    goutreal1 = 0;
    goutimag1 = 0;
    goutreal2 = 0;
    goutimag2 = 0;
    goutreal3 = 0;
    goutimag3 = 0;
    goutreal4 = 0;
    goutimag4 = 0;
    gphase = 0.0;
    gout_ready = false;

    if (calbin>0) 

        if (fout_ready && (state > 0))
            fprintf ("Can't keep up\n Die.\n");
        end

        if (state==1)

            if (calbin == 1)             
                phase_st = exp(complex(0,phase));
                phase_mult2 = phase_st*phase_st;
            else
                phase_st = phase_st * phase_mult2;
            end
            
            accum(calbin,:) = phase_st*accum(calbin,:) + cur(calbin,:);
            if (calbin == 91)
                fprintf ("And now: %i %g %g %g \n", calbin, real(accum(calbin,1)), real(phase_st), real (cur(calbin,1)))
            end
            if (calbin == {Ncal})
                state = 0;
            end
            Nacc3 = Nacc3 + 1;
            if Nacc3 == {NavgCal3}
                goutreal1 = real(accum(calbin,1));
                goutimag1 = imag(accum(calbin,1));
                goutreal2 = real(accum(calbin,2));
                goutimag2 = imag(accum(calbin,2));
                goutreal3 = real(accum(calbin,3));
                goutimag3 = imag(accum(calbin,3));
                goutreal4 = real(accum(calbin,4));
                goutimag4 = imag(accum(calbin,4));
                gout_ready = true;
                accum = complex(zeros({Nchan},4),zeros({Nchan},4));
            end
            
        end 

        %% there could be an else here, since as per above, we either have state>>0 OR fout_ready or None, but not both!!

        if (fout_ready)
            cur (calbin,:) = [complex(foutreal1, foutimag1), complex(foutreal2, foutimag2), complex(foutreal3, foutimag3), complex(foutreal4, foutimag4)];
            chwe = [corout1, corout2, corout3, corout4];
            prod = kar*cur(calbin,:) .* chwe .* conj(accum(calbin,:));
            %fprintf("PROD: %i %g %g %g\n", calbin, real(chwe(1)), real(cur(calbin,1)), real(accum(calbin,1)));
            fd = fd + imag(sum(prod));
            sd = sd + real(sum(prod*kar));
            if calbin == {Ncal}
                state = 1;
                if (sd~=0)
                    phase = fd/sd;
                else
                    phase = 0; %% will happen on first sample
                end
                
                gphase = phase;
                
                fprintf("GPHASE: %g %g  %g\n", fd, sd, gphase*1e6);
            end
        end


    end
end 