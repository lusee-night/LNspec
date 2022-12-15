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
            
            P1_ = real(fft_val_b * conj(fft_val_b));
            P2_ = real(fft_val*conj(fft_val));
            cross_ = fft_val_b*fft_val;
            PR_ = real(cross_);
            PI_ = imag (cross_);
            %% Now invert to actual spectra
            P1 = 0.25 * (P1_ + P2_ + 2*PR_);
            P2 = 0.25 * (P1_ + P2_ - 2*PR_);
            PR = PI_/2.0;
            PI = (P1_-P2_)/4.0;
        end

        count = mod(count + 1, 4096);
    end
end

