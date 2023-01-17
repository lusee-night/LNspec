function [ch1_val, ch2_val, bin, ready] = deinterlace(fft_val, fft_valid)
    persistent count buf;

    if isempty(count)
        count = int16(0);
        buf = complex(zeros(1,{Nchan}+1));
    end

    ready = fft_valid & (count>{Nchan});
    bin = int16({Nfft}-count);
    if (count>{Nchan})
        fft_val_b = buf(bin+1);
    else
        fft_val_b = complex(0,0);
        buf(count+1) = fft_val;
    end

    ch1_val = 0.5*(fft_val_b+conj(fft_val));
    ch2_val = complex(0,-0.5)*(fft_val_b-conj(fft_val));

    if fft_valid
        count = count_up__instance:{parent}:over={Nfft}__(count);
    end
end

