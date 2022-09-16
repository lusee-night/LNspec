clear spectrometer;
clear pk_accum;

npk = 0;
t = 0;
dt = 1;
omega = 0.25;
while npk<2;
    sample = int16(1000*sin(omega*t*2*pi));
    [pk, ready] = spectrometer(sample);
    if ready
        npk = npk + 1;
    end
    t = t + dt;
end
freq = 0:double(settings_Nfft)/2-1;
freq = freq/double(settings_Nfft);
%semilogy(freq,pk,'bo-')
