clear all;

t = 0;
dt = 1;

Npk = 0;
clf;

samples1 = read_samples_bin('samples/sky_pf_100.bin');
samples2 = read_samples_bin('samples/sky_100.bin');
%samples1 = read_samples('samples/Raw_data_ADC_A_6MHz');
%samples2 = read_samples('samples/Raw_data_ADC_B_1MHz');

N1 = length(samples1);
N2 = length(samples2);
pk=zeros(4,{Nchan});
while Npk<2;
    if (mod(t,5000)==0)
        fprintf ("t = %i\n",t);
    end
    
      sample1 = int16(samples1(mod(t,N1)+1));
      sample2 = int16(samples2(mod(t,N2)+1));
      
    [pks, outbin, ready] = spectrometer(sample1,sample2);

    if ready
        pk(:,outbin+1) = pks;
        if outbin==1
            Npk = Npk + 1;
            fprintf ('%i in the bag.\n',Npk);
        end
    end
    t = t + dt;
end

% Let's call again with a larger Navg to get demonstrate the range.



disp(t)
freq = (1:{Nchan})*102.4/{Nfft};
pk1 = pk(1,:);
pk2 = pk(2,:);
pkXR = pk(3,:);
pkXI = pk(4,:);

[fid,msg] = fopen('spectrometer_output.txt','wt');
assert(fid>=3,msg);
for i=1:{Nchan}
    fprintf(fid,'%d %d %d %d %d\n',freq(i), pk1(i),pk2(i),pkXR(i), pkXI(i));
end
fclose(fid);

clf;

semilogy(freq,pk1,'ro-');
hold on
semilogy(freq,pk2,'bo-');

xlim([0 1]);
xlabel('freq [MHz]')
ylabel('power')

