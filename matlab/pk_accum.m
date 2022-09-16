

function [outpk,ready] = pk_accum(inbuf)
    persistent count buf dfft;
    if isempty(count)
        count = 1;
        buf = zeros(1,coder.const(settings_Nchan));
        outpk = zeros(1,coder.const(settings_Nchan));
        dfft=dsp.FFT;
        %dfft = @fft_placeholder;
    end
    %% debug
    %inbuf'
    %t = dfft(inbuf');
    t = fft_placeholder(inbuf');
    t = t(1:coder.const(settings_Nchan));
    p = real(t.*conj(t))';
    buf = buf + p;
    if (count == coder.const(settings_Navg));
        outpk = buf;
        ready = true;
        count = 1;
        buf = zeros(1,coder.const(settings_Nchan));
    else
        outpk = zeros(1,coder.const(settings_Nchan));
        count = count + 1;
        ready = false;
    end
end

