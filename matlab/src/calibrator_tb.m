clear all;
use_ramp = false;

if use_ramp
    ramp_pfb_set;
    Ns=4000
else
    fprintf("reading data\n")
    notch_data = read_notch_bin('samples/bethe.input',10000);
    noise_data = read_notch_bin('samples/bethe.noise',10000);
    Ns = size(notch_data,1);
    fprintf('Ns = %d\n', Ns);
end

weights = importdata('samples/bethe.weights');
weights = weights(:,3);


phase_drift_per_ppm = 50e3*{Nfft}/102.4e6 *(1/1e6)*2*pi;
alpha_to_pdrift = {Navg}*phase_drift_per_ppm;
drift = 0.0 * alpha_to_pdrift;
FD = 0;
SD = 0;
top = 0;
bot = 0;


file_meta = fopen ('meta.dat','w');
file_data = fopen('output.dat', 'w');

for ic = 1:Ns
    got_ready = false;
    for jc = 1:{Nchan}
        if use_ramp 
            ch1_notch_real = real(ramp_pfb(jc))+randn*100;
            ch1_notch_imag = imag(ramp_pfb(jc))+randn*100;
            ch2_notch_real = real(ramp_pfb(jc))+randn*100;
            ch2_notch_imag = imag(ramp_pfb(jc))+randn*100;
        else
            ch1_notch_real = notch_data(ic,2*jc-1);
            ch1_notch_imag = notch_data(ic,2*jc);
            ch2_notch_real = noise_data(ic,2*jc-1);
            ch2_notch_imag = noise_data(ic,2*jc);
        end

        %% readyin means we have data coming from x16
        %% readycal means we are on a bit with a calibrator signal (ie %4 ==2)
        %% readyout means we are on the last cycle of stage2 average 
        %% update drift means we are on the last data inpout of the last cycle of stage2 average 
        

        [calbin, phase_cor, kar, tick, readyout, update_drift, readycal] = cal_phaser_alt (jc, drift, true);

        [outreal1, outimag1, powertop1, powerbot1, drift_FD1, drift_SD1] = ....
            cal_average_instance:C1_(ch1_notch_real, ch1_notch_imag, calbin, phase_cor, kar, tick, readyout, readycal);
        [outreal2, outimag2, powertop2, powerbot2, drift_FD2, drift_SD2] = ...
            cal_average_instance:C2_(ch2_notch_real, ch2_notch_imag, calbin, phase_cor, kar, tick, readyout, readycal);
        
        wndx = floor((jc+2)/4);
        if wndx > 0
            weight = weights(wndx);
        else
            weight = 0;
        end

        %fprintf(' %i %i %g  %g\n', calbin, readycal, ch1_notch_real, weight)

        [drift, have_lock, snr1, snr2, snr3, snr4, foutreal1, foutimag1, foutreal2, foutimag2, foutreal3, foutimag3, foutreal4, foutimag4, corout1, corout2, corout3, corout4,  fout_ready ] = ...
        cal_process (outreal1, outimag1, powertop1, powerbot1, drift_FD1, drift_SD1, ...
                     outreal2, outimag2, powertop2, powerbot2, drift_FD2, drift_SD2, ...
                     outreal2, outimag2, powertop2, powerbot2, drift_FD2, drift_SD2, ...
                     outreal2, outimag2, powertop2, powerbot2, drift_FD2, drift_SD2, ...
                     calbin, readyout, drift, update_drift, weight);

        [goutreal1, goutimag1, goutreal2, goutimag2, goutreal3, goutimag3, goutreal4, goutimag4, gphase, gNacc, gout_ready] = ... 
                cal_stage3 (calbin, have_lock, foutreal1, foutimag1, foutreal2, foutimag2, foutreal3, foutimag3, foutreal4, foutimag4, corout1, corout2, corout3, corout4, fout_ready);
       
        if (update_drift)
            fprintf(file_meta, '%g %g %g %g %g %g \n ', drift / alpha_to_pdrift, snr1, snr2, snr3, snr4, gphase);
        end 


        if gout_ready
            if (calbin==1)
                fprintf(file_data, '%g  ', gNacc);
            end
            fprintf(file_data, '%g %g ', goutreal1, goutimag1);
            if calbin == {Ncal}
                fprintf(file_data, '\n');
            end
        end

    end

    for jc = 1:{Nchan}
        [calbin, phase_cor, kar, tick, readyout, update_drift, readycal] = cal_phaser_alt (jc, drift, false);
    end
end

fclose(file_meta);
fclose(file_data);


