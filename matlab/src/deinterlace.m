function [ch1_val, ch2_val, bin, ready] = deinterlace(fft_val, fft_valid)
    persistent buf count  Nac fwd accum outbuf stream;
    if isempty(count)
        count = int16(0);
        Nac = 0;
        stream = 0;
        fwd = true;
        buf = complex(zeros(1,{Nchan}));
    end

    ready = false;
    bin = int16(0);
    ch1_val = complex(0,0);
    ch2_val = complex(0,0);
    
    if fft_valid
        if (count>0) & (count<={Nchan}) 
        buf(count) = fft_val;
        end
        if (count>{Nchan}) 
            ready = true;
            bin = int16(int16({Nfft})-count);
            fft_val_b = buf(bin);
            ch1_val = 0.5*(fft_val_b+conj(fft_val));
            ch2_val = complex(0,-0.5)*(fft_val_b-conj(fft_val));
        end
        count = mod(count + 1, {Nfft});
    end
end

