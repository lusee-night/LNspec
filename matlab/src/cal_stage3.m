function [goutreal1, goutimag1, goutreal2, goutimag2, goutreal3, goutimag3, goutreal4, goutimag4, gphase, gNacc, gout_ready] = cal_stage3 (calbin, have_lock, foutreal1, foutimag1, foutreal2, foutimag2, foutreal3, foutimag3, foutreal4, foutimag4, corout1, corout2, corout3, corout4, fout_ready)

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
    gNacc = 0;
    gout_ready = false;

    if (calbin>0) 

        if (fout_ready && (state > 0))
            %D%fprintf ("Can't keep up\n Die.\n");
        end


        if ((~have_lock) & (Nacc3>0))
            goutreal1 = real(accum(calbin,1));
            goutimag1 = imag(accum(calbin,1));
            goutreal2 = real(accum(calbin,2));
            goutimag2 = imag(accum(calbin,2));
            goutreal3 = real(accum(calbin,3));
            goutimag3 = imag(accum(calbin,3));
            goutreal4 = real(accum(calbin,4));
            goutimag4 = imag(accum(calbin,4));
            accum(calbin,:) = complex(zeros(1,4),zeros(1,4));
            gNacc = Nacc3;
            gout_ready = true;
            if (calbin == {Ncal})                
                Nacc3 = 0;
            end
        end
        

        if (state==1)

            if (calbin == 1)             
                %phase_st = exp(complex(0,-phase));
                phase_st = complex(mycos(-phase),mysin(-phase));
                phase_mult2 = phase_st*phase_st;
            else
                phase_st = phase_st * phase_mult2;
            end
            
            accum(calbin,:) = phase_st*accum(calbin,:) + cur(calbin,:);
            
            if (Nacc3 == ({NavgCal3}-1))
                goutreal1 = real(accum(calbin,1));
                goutimag1 = imag(accum(calbin,1));
                goutreal2 = real(accum(calbin,2));
                goutimag2 = imag(accum(calbin,2));
                goutreal3 = real(accum(calbin,3));
                goutimag3 = imag(accum(calbin,3));
                goutreal4 = real(accum(calbin,4));
                goutimag4 = imag(accum(calbin,4));
                accum(calbin,:) = complex(zeros(1,4),zeros(1,4));
                gNacc = Nacc3+1; % Nacc3 hasn't been augmeneted yet
                gout_ready = true;
            end

            if (calbin == {Ncal})
                state = 0;
                Nacc3 = Nacc3 + 1;
                if Nacc3 == {NavgCal3}
                    Nacc3 = 0;
                end
            end
        end 

        

        %% there could be an else here, since as per above, we either have state>>0 OR fout_ready or None, but not both!!

        if (have_lock & fout_ready)
            cur (calbin,:) = [complex(foutreal1, foutimag1), complex(foutreal2, foutimag2), complex(foutreal3, foutimag3), complex(foutreal4, foutimag4)];
            chwe = [corout1, corout2, corout3, corout4];
            kk = (2*calbin-1);
            prod = kk*cur(calbin,:) .* chwe .* conj(accum(calbin,:));
                        
            fd = fd + imag(sum(prod));
            sd = sd + real(sum(prod*kk));
            if calbin == {Ncal}
                state = 1;
                if (sd~=0)
                    phase = -fd/sd;
                else
                    phase = 0; %% will happen on first sample
                end
                
                gphase = phase;
                fd=0;
                sd=0;

                %D%fprintf("GPHASE: %g\n", gphase*1e6);
            end
        end


    end
end 