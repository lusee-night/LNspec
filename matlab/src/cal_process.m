function [drift, have_lock_out, foutreal1, foutimag1, foutreal2, foutimag2, foutreal3, foutimag3, foutreal4, foutimag4, corout1, corout2, corout3, corout4, fout_ready] = ...
        cal_process (outreal1, outimag1, powertop1, powerbot1, drift_FD1, drift_SD1, ...
                     outreal2, outimag2, powertop2, powerbot2, drift_FD2, drift_SD2, ...
                     outreal3, outimag3, powertop3, powerbot3, drift_FD3, drift_SD3, ...
                     outreal4, outimag4, powertop4, powerbot4, drift_FD4, drift_SD4, ...
                     calbin, readyout, drift, update_drift, weight)
    persistent FD SD top bot Nac2 have_lock lastcor


    %% user selectable settings


    SNRon = 3;
    SNRoff = 2;
    Nsettle = 3; %% fix
    delta_drift_search = 0.05;
    delta_drift_max = 1.2;
    delta_drift_cor_A = 2;
    delta_drift_cor_B = 20;

    if isempty(FD)
        FD = zeros(1,4);
        SD = zeros(1,4);
        top = zeros(1,4);
        bot = zeros(1,4);
        Nac2 = 1;
        pwr = 0;
        have_lock = 0;
        lastcor = zeros(1,4);
    end

    foutreal1 = 0;
    foutimag1 = 0;
    foutreal2 = 0;
    foutimag2 = 0;
    foutreal3 = 0;
    foutimag3 = 0;
    foutreal4 = 0;
    foutimag4 = 0;
    corout1 = 0;
    corout2 = 0;
    corout3 = 0;
    corout4 = 0;
    fout_ready = false;
    have_lock_out = have_lock;

    if readyout
        FD(1) = FD(1) + drift_FD1*weight;
        SD(1) = SD(1) + drift_SD1*weight;
        FD(2) = FD(2) + drift_FD2*weight;
        SD(2) = SD(2) + drift_SD2*weight;
        FD(3) = FD(3) + drift_FD3*weight;
        SD(3) = SD(3) + drift_SD3*weight;
        FD(4) = FD(4) + drift_FD4*weight;
        SD(4) = SD(4) + drift_SD4*weight;

        top(1) = top(1) + powertop1*weight;
        bot(1) = bot(1) + powerbot1*weight;
        top(2) = top(2) + powertop2*weight;
        bot(2) = bot(2) + powerbot2*weight;
        top(3) = top(3) + powertop3*weight;
        bot(3) = bot(3) + powerbot3*weight;
        top(4) = top(4) + powertop4*weight;
        bot(4) = bot(4) + powerbot4*weight;

        if (have_lock==Nsettle)
            foutreal1 = outreal1;
            foutimag1 = outimag1;
            foutreal2 = outreal2;
            foutimag2 = outimag2;
            foutreal3 = outreal3;
            foutimag3 = outimag3;
            foutreal4 = outreal4;
            foutimag4 = outimag4;
            corout1 = lastcor(1);
            corout2 = lastcor(2);
            corout3 = lastcor(3);
            corout4 = lastcor(4);
            fout_ready = true;
        end

        if (update_drift)

            phase_drift_per_ppm = 50e3*{Nfft}/102.4e6 *(1/1e6)*2*pi;
            alpha_to_pdrift = {Navg}*phase_drift_per_ppm;
            fprintf('cdrift = %f -> ', drift/alpha_to_pdrift);
            FDX = 0; 
            SDX = 0;
    
            on_detection = false;
            off_detection = true;
            snrar = zeros(4,1); % debug only
            for i=1:4
                snr = top(i)/bot(i);
                aha = (snr-delta_drift_cor_A)/delta_drift_cor_B;
                if aha < 0
                    aha = 0;
                end
                if aha>2 
                    aha = 2;
                end
                cor = aha-aha*aha/4;
                lastcor(i) = cor;
                FDX = FDX + cor * cor * FD(i);
                SDX = SDX + cor * SD(i);
                if (snr>SNRon)
                    on_detection = true; % a single above threshold mean we turn on
                end
                if (snr>SNRoff)
                    off_detection = false; % a single above threshold means we keep integrating
                end
                %% debugging help
                snrar(i) = snr;
            end

            if (have_lock>0)
                have_lock = min(have_lock + 1, Nsettle);
                if (off_detection)
                    have_lock = 0;
                end
                
            else
                if (on_detection)
                    have_lock = 1;
                end
            end

            if (have_lock>0)
                delta_drift = FDX/SDX;            
            else 
                delta_drift = delta_drift_search*alpha_to_pdrift;
            end

            

            drift = drift + delta_drift;
            % if we hit the boundary on either end we go to the bottom (since we drift up when not in lock)
            if (abs(drift)>delta_drift_max*alpha_to_pdrift)
                drift = -delta_drift_max*alpha_to_pdrift;
            end

            fprintf('%f (%i), pwr = %f %f\n', drift/alpha_to_pdrift,have_lock, snrar(1), snrar(2));
            
            FD = zeros(1,4);
            SD = zeros(1,4);
            top = zeros(1,4);
            bot = zeros(1,4);
            Nac2 = 1;
    end   
end