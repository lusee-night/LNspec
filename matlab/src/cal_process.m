function [drift, foutreal1, foutimag1, foutreal2, foutimag2, foutreal3, foutimag3, foutreal4, foutimag4, fout_ready] = ...
        cal_process (outreal1, outimag1, powertop1, powerbot1, drift_FD1, drift_SD1, ...
                     outreal2, outimag2, powertop2, powerbot2, drift_FD2, drift_SD2, ...
                     outreal3, outimag3, powertop3, powerbot3, drift_FD3, drift_SD3, ...
                     outreal4, outimag4, powertop4, powerbot4, drift_FD4, drift_SD4, ...
                     calbin, readyout, drift, update_drift)
    persistent FD SD top bot sig_real sig_imag Nac2

    if isempty(FD)
        FD = zeros(1,4);
        SD = zeros(1,4);
        sig_real = zeros(4,{Ncal});
        sig_imag = zeros(4,{Ncal});
        top = zeros(1,4);
        bot = zeros(1,4);
        Nac2 = 1;
    end

    foutreal1 = 0;
    foutimag1 = 0;
    foutreal2 = 0;
    foutimag2 = 0;
    foutreal3 = 0;
    foutimag3 = 0;
    foutreal4 = 0;
    foutimag4 = 0;
    fout_ready = false;

    if readyout
        FD(1) = FD(1) + drift_FD1;
        SD(1) = SD(1) + drift_SD1;
        FD(2) = FD(2) + drift_FD2;
        SD(2) = SD(2) + drift_SD2;
        FD(3) = FD(3) + drift_FD3;
        SD(3) = SD(3) + drift_SD3;
        FD(4) = FD(4) + drift_FD4;
        SD(4) = SD(4) + drift_SD4;

        top(1) = top(1) + powertop1;
        bot(1) = bot(1) + powerbot1;
        top(2) = top(2) + powertop2;
        bot(2) = bot(2) + powerbot2;
        top(3) = top(3) + powertop3;
        bot(3) = bot(3) + powerbot3;
        top(4) = top(4) + powertop4;
        bot(4) = bot(4) + powerbot4;

        sig_real(1,calbin) = sig_real(1,calbin)+outreal1;
        sig_imag(1,calbin) = sig_imag(1,calbin)+outimag1;
        sig_real(2,calbin) = sig_real(2,calbin)+outreal2;
        sig_imag(2,calbin) = sig_imag(2,calbin)+outimag2;
        sig_real(3,calbin) = sig_real(3,calbin)+outreal3;
        sig_imag(3,calbin) = sig_imag(3,calbin)+outimag3;
        sig_real(4,calbin) = sig_real(4,calbin)+outreal4;
        sig_imag(4,calbin) = sig_imag(4,calbin)+outimag4;

        if Nac2 == {NavgCal3}
            foutreal1 = sig_real(1,calbin);
            %if (calbin==3)
            %    fprintf ("here %g \n", foutreal1);
            %end

            foutimag1 = sig_imag(1,calbin);
            foutreal2 = sig_real(2,calbin);
            foutimag2 = sig_imag(2,calbin);
            foutreal3 = sig_real(3,calbin);
            foutimag3 = sig_imag(3,calbin);
            foutreal4 = sig_real(4,calbin);
            foutimag4 = sig_imag(4,calbin);
            sig_real (:,calbin) = zeros(4,1);
            sig_imag (:,calbin) = zeros(4,1);
            fout_ready = true;
        end

        if (update_drift)
            phase_drift_per_ppm = 50e3*{Nfft}/102.4e6 *(1/1e6)*2*pi;
            alpha_to_pdrift = {Navg}*phase_drift_per_ppm;
            %fprintf('cdrift = %f ->', drift/alpha_to_pdrift);
            FDX = 0; 
            SDX = 0;
            for i=1:4
                pwr = top(i)/bot(i);
                if pwr>10
                    FDX = FDX + FD(i);
                    SDX = SDX + SD(i);
                end 
            end

            drift = drift + FDX/SDX;
            %fprintf('%f \n', drift/alpha_to_pdrift);
            %fprintf('%f, pwr = %f ', drift/alpha_to_pdrift, pwr);
            
            FD = zeros(1,4);
            SD = zeros(1,4);
            top = zeros(1,4);
            bot = zeros(1,4);
            Nac2 = Nac2+1;
            if Nac2>{NavgCal3}
                Nac2 = 1;
            end
    end   
end