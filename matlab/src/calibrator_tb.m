clear all;

fprintf("reading data\n")
notch_data = read_notch_bin('samples/notch_03.bin',6400);
Ns = size(notch_data,1);
fprintf('Ns = %d\n', Ns);
phase_drift_per_ppm = 50e3*{Nfft}/102.4e6 *(1/1e6)*2*pi;
alpha_to_pdrift = {Navg}*phase_drift_per_ppm;
drift = 0.25 * alpha_to_pdrift;
FD = 0;
SD = 0;
top = 0;
bot = 0;

for ic = 1:Ns
    got_ready = false;
    for jc = 1:{Nchan}
        ch1_notch_real = notch_data(ic,2*jc-1);
        ch1_notch_imag = notch_data(ic,2*jc);
        % Let ch2 be randm
        ch2_notch_real = randn;
        ch2_notch_imag = randn;


        [calbin, phase_cor, kar, tick, readyout, update_drift, readycal] = cal_phaser_alt (jc, drift, true);

        [outreal1, outimag1, powertop1, powerbot1, drift_FD1, drift_SD1] = ....
            cal_average_instance:C1_(ch1_notch_real, ch1_notch_imag, calbin, phase_cor, kar, tick, readyout, readycal);
        [outreal2, outimag2, powertop2, powerbot2, drift_FD2, drift_SD2] = ...
            cal_average_instance:C2_(ch2_notch_real, ch2_notch_imag, calbin, phase_cor, kar, tick, readyout, readycal);
        
        [drift, foutreal1, foutimag1, foutreal2, foutimag2, fourreal3, foutimag3, foutreal4, foutimag4, fout_ready] = ...
        cal_process (outreal1, outimag1, powertop1, powerbot1, drift_FD1, drift_SD1, ...
                     outreal2, outimag2, powertop2, powerbot2, drift_FD2, drift_SD2, ...
                     outreal1, outimag1, powertop1, powerbot1, drift_FD1, drift_SD1, ...
                     outreal2, outimag2, powertop2, powerbot2, drift_FD2, drift_SD2, ...
                     calbin, readyout, drift, update_drift);
        if (fout_ready) & (calbin == 3)
           fprintf (' %g | %g %g | %g %g\n ', foutreal1,  abs(complex(foutreal1, foutimag1)), atan2(foutimag1, foutreal1), ...
                                         abs(complex(foutreal2, foutimag2)), atan2(foutimag2, foutreal2))
        end

    end


    for jc = 1:{Nchan}
        [calbin, phase_cor, kar, tick, readyout, update_drift, readycal] = cal_phaser_alt (jc, drift, false);
    end
end

