function [P1,P2,PR,PI, bin] = correlate(fft_val, fft_valid)
    persistent buf count  Nac fwd accum outbuf stream;
    if isempty(count)
        count = 0;
        Nac = 0;
        stream = 0;
        fwd = true;
        buf = complex(zeros(1,coder.const(settings_Nchan)));
    end

    bin = -1;
    P1 = 0;
    P2 = 0;
    PR = 0;
    PI = 0;

    if fft_valid
        % we skip first bin as it k=0 value
        if count>0
            if fwd
                buf(count) = fft_val;
            else
                ready = true;
                fft_val_b = buf(count);
                bin = count;
                P1 = real(fft_val_b * conj(fft_val_b));
                P2 = real(fft_val*conj(fft_val));
                cross = fft_val_b*fft_val;
                PR = real(cross);
                PI = imag (cross);
            end
            if count==coder.const(settings_Nchan)
                fwd = false;
            end
        end
        if fwd
            count = count + 1;
        else
            count = count - 1;
            if count == 0
                fwd = true;
                Nac = Nac + 1;
                %disp(Nac);
            end
        end
    end
    
end

