clear;
clear pfb_engine;
clear pk_accum;
t = 0;
dt = 1;
omega1 = 20;
omega2 = 40;
omegax = 50;
count = 1;
Npk = 0;
pk=zeros(4,settings_Nchan);
%pfb_weights = get_pfb_weights(settings_Nfft, settings_Ntaps);

clf;

while Npk<2;
    sample1 = int16(28000*sin(omega1*t/settings_Nfft*2*pi)+2000*sin(omegax*t/settings_Nfft*2*pi));
    sample2 = int16(28000*sin(omega2*t/settings_Nfft*2*pi)+2000*cos(omegax*t/settings_Nfft*2*pi));
    [out_re, out_im, ready_pfb] = pfb_engine(sample1,sample2);
    fft_out = complex(out_re, out_im);
    [pks,ready] =  pk_accum(fft_out, ready_pfb);

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
    %if (t<256)
    %    plot(t,sample1,'ro');
    %    plot(t,sample2,'bo');
    %end
end

%freq = 0:double(settings_Nfft)/2-1;
%freq = freq/double(settings_Nfft);
freq = 1:settings_Nchan;
pk1 = (pk(1,:) + pk(2,:) + 2 * pk(3,:))/4.0
pk2 = (pk(1,:) + pk(2,:) - 2 * pk(3,:))/4.0
pkXR = pk(4,:)/2;
pkXI = (pk(1,:)-pk(2,:))/4.0
clf;

plot(freq,pk1,'bo-');
hold on
plot(freq,pk2,'ro-');
%semilogy(freq,pk2,'ro-');

