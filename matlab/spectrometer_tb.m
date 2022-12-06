clear all;

t = 0;
dt = 1;
omega1 = 20;
omega2 = 40;
omegax = 50;
count = 1;
Npk = 0;
pk=zeros(4,settings_Nchan);
clf;

wf1 = weight_fold; 
weight_fold1 = @wf1.process;
wf2 = weight_fold; 
weight_fold2 = @wf2.process;

integrated = false;

while Npk<2;
    sample1 = int16(28000*sin(omega1*t/settings_Nfft*2*pi)+2000*sin(omegax*t/settings_Nfft*2*pi));
    sample2 = int16(28000*sin(omega2*t/settings_Nfft*2*pi)+2000*cos(omegax*t/settings_Nfft*2*pi));

    if (integrated)
        [pks, ready] = spectrometer(sample1,sample2);
    else
        [w1,w2,w3,w4] = weight_streamer();
        acc1 = weight_fold1(sample1, w1, w2, w3, w4);
        acc2 = weight_fold2(sample2, w1, w2, w3, w4);
        
        val = complex(acc1,acc2);
        [fft_out, fft_valid] = sfft(val');

        [P1,P2,PX,PR, bin, cready] = correlate(fft_out,fft_valid);
        [pks, ready] = average(P1,P2,PX,PR, bin, cready);
    end
    
    if ready
        pk(:,count) = pks;
        count = count + 1;
        if (count>settings_Nchan)
            count = 1;
            Npk = Npk + 1;
            disp(Npk);
        end
    end
    t = t + dt;
end


freq = 1:settings_Nchan;
pk1 = (pk(1,:) + pk(2,:) + 2 * pk(3,:))/4.0;
pk2 = (pk(1,:) + pk(2,:) - 2 * pk(3,:))/4.0;
pkXR = pk(4,:)/2;
pkXI = (pk(1,:)-pk(2,:))/4.0;
clf;

plot(freq,pk1,'bo-');
hold on
plot(freq,pk2,'ro-');
xlim([0 100]);

%semilogy(freq,pk2,'ro-');

