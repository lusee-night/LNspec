clear all;

t = 0;
dt = 1;

Npk = 0;
Npk_z5 = 0;
clf;

samples1 = read_samples_bin('samples/sky_pf_100.bin');
samples2 = read_samples_bin('samples/sky_100.bin');
%samples1 = read_samples('samples/Raw_data_ADC_A_6MHz');
%samples2 = read_samples('samples/Raw_data_ADC_B_1MHz');

N1 = length(samples1);
N2 = length(samples2);
pk=zeros(4,{Nchan});
pk_z5=zeros(4,40);

while Npk<5;
    if (mod(t,5000)==0)
        fprintf ("t = %i\n",t);
    end
    
      sample1 = int16(samples1(mod(t,N1)+1));
      sample2 = int16(samples2(mod(t,N2)+1));
      
    [pks, outbin, ready, pks_z5, outbin_z5, ready_z5] = spectrometer(sample1,sample2);

    if ready
        if (Npk>0)
            pk(:,outbin+1) = pk(:,outbin+1) + pks';
        end
        if outbin==1
            Npk = Npk + 1;
            fprintf ('%i in the bag.\n',Npk);
        end
    end
    if ready_z5
        if (Npk_z5)>0
            pk_z5(:,outbin_z5+1) = pk_z5(:,outbin_z5+1) + pks_z5';
        end
        if outbin_z5==1
            Npk_z5 = Npk_z5 + 1;
            fprintf ('zoom %i in the bag.\n',Npk_z5);
        end
    end
    t = t + dt;
end

% Let's call again with a larger Navg to get demonstrate the range.



disp(t)
freq = (1:{Nchan})*102.4/{Nfft};
freq_z5 = ((1:40)+2)*102.4/{Nfft}/5;


pk1 = pk(1,:);
pk2 = pk(2,:);
pkXR = pk(3,:);
pkXI = pk(4,:);

pk1_z5 = pk_z5(1,:);
pk2_z5 = pk_z5(2,:);
pkXR_z5 = pk_z5(3,:);
pkXI_z5 = pk_z5(4,:);


[fid,msg] = fopen('spectrometer_output.txt','wt');
assert(fid>=3,msg);
for i=1:{Nchan}
    fprintf(fid,'%d %d %d %d %d\n',freq(i), pk1(i),pk2(i),pkXR(i), pkXI(i));
end
fclose(fid);

clf;

semilogy(freq,pk1,'ro-');
semilogy(freq_z5,pk1_z5,'rx--');
hold on
semilogy(freq,pk2,'bo-');
semilogy(freq_z5,pk2_z5,'bx--');


xlim([0 1]);
xlabel('freq [MHz]')
ylabel('power')

