function [P1, P2, PR, PI, bin, ready] = correlate(fft_val, fft_valid)
    persistent buf count  Nac fwd accum outbuf stream;
    if isempty(count)
        count = int16(0);
        Nac = 0;
        stream = 0;
        fwd = true;
        buf = complex(zeros(1,2048));
    end

    ready = false;
    bin = int16(0);
     P1 = 0;
     P2 = 0;
     PR = 0;
     PI = 0;

    if fft_valid
        if (count>0) & (count<=2048) 
        buf(count) = fft_val;
        end
        if (count>2048) 
            ready = true;
            bin = int16(int16(4096)-count);
            fft_val_b = buf(bin);
            
            P1 = real(fft_val_b * conj(fft_val_b));
            P2 = real(fft_val*conj(fft_val));
            cross = fft_val_b*fft_val;
            PR = real(cross);
            PI = imag (cross);
        end

        count = mod(count + 1, 4096);
    end
end

