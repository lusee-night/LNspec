function [outpk,ready] = pk_accum(fft_val, fft_valid)
    persistent buf count  Nac fwd accum outbuf stream;
    if isempty(count)
        count = 0;
        Nac = 0;
        stream = 0;
        fwd = true;
        buf = complex(zeros(1,coder.const(settings_Nchan)));
        accum = zeros(4,coder.const(settings_Nchan));
        outbuf = zeros(4,coder.const(settings_Nchan));
    end
    if fft_valid
        if count>0
            auto = real(fft_val*conj(fft_val));
            if fwd
                accum(1,count) = accum(1,count)+auto;
                buf(count) = fft_val;
                cross = complex(0,0);

            else
                accum(2,count) = accum(2,count)+auto;
                cross = buf(count)*fft_val;
                accum(3,count) = accum(3,count)+real(cross);
                accum(4,count) = accum(4,count)+imag(cross);
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
    
        if (Nac == coder.const(settings_Navg));
            outbuf = accum/coder.const(settings_Navg);
            stream = 1;
            Nac = 0;
            accum = zeros(4,coder.const(settings_Nchan));
        end

        if stream
            ready = true;
            outpk = outbuf(:,stream);
            stream = stream + 1;
            if stream>coder.const(settings_Nchan)
                stream  = 0;
            end
        else
            ready = false;
            outpk = zeros(4,1);
        end
    else
        ready = false;
        outpk = zeros(4,1);
    end
end
