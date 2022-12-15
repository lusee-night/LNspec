clear all;

t = 1;
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
N1 = length(samples1);
N2 = length(samples2);

while Npk<2;
    sample1 = samples1(mod(t,N1)+1);
    sample2 = samples2(mod(t,N2)+1);

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
freq = (1:settings_Nchan)*50/2048;
%pk1 = (pk(1,:) + pk(2,:) + 2 * pk(3,:))/4.0;
%pk2 = (pk(1,:) + pk(2,:) - 2 * pk(3,:))/4.0;
%pkXR = pk(4,:)/2;
%pkXI = (pk(1,:)-pk(2,:))/4.0;
pk1 = pk(1,:);
pk2 = pk(2,:);
pkXR = pk(3,:);
pkXI = pk(4,:);

clf;

semilogy(freq,pk1,'bo-');
hold on
semilogy(freq,pk2,'ro-');
xlim([0 10]);
xlabel('freq [MHz]')
ylabel('power')
%semilogy(freq,pk2,'ro-');

