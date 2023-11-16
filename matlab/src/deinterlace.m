function [ch1_val, ch2_val, bin, ready] = deinterlace(fft_val, fft_valid)
    persistent count buf;

    if isempty(count)
        count = int16(0);
        buf = complex(zeros(1,{Nchan}));
    end

    ready = fft_valid & (count>{Nchan});
    bin = int16({Nfft}-1-count);
    fft_val_b = complex(0,0);
    if (count>{Nchan})
        fft_val_b = buf(bin+1+1);
    elseif (count<{Nchan})    
        buf(count+1) = fft_val;
    end

    ch1_val = 0.5*(fft_val_b+conj(fft_val));
    ch2_val = complex(0,+0.5)*(fft_val_b-conj(fft_val));

    if fft_valid
        count = count_up_instance:{parent}:over={Nfft}_(count);
    end
end

