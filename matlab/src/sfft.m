function [fft_out,fft_valid] = sfft(c)
    persistent dfft
    if isempty(dfft)
        dfft=dsphdl.FFT('FFTLength',{Nfft},'BitReversedOutput',false);
    end

    [fft_out, fft_valid] = dfft(c, true);
end