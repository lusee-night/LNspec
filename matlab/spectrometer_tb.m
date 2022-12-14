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

samples1 = read_samples('samples/Raw_data_ADC_A_6MHz');
samples2 = read_samples('samples/Raw_data_ADC_B_1MHz');


while Npk<2;
    sample1 = int16(28000*sin(0.4+omega1*t/settings_Nfft*2*pi)+2000*sin(0.9+omegax*t/settings_Nfft*2*pi));
    sample2 = int16(28000*sin(0.7+omega2*t/settings_Nfft*2*pi)+2000*cos(0.9+omegax*t/settings_Nfft*2*pi));

    [pks, ready] = spectrometer(sample1,sample2);
    
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

disp(t)
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

