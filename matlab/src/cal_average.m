function [outreal, outimag, powertop, powerbot, drift_FD, drift_SD] = cal_average(real_in, imag_in, calbin, phase_cor, kar, tick, readyout, readycal)
    persistent sum0 sum0alt sum1 sum2 altstore;

    if isempty(sum0)
        sum0 = complex(zeros({Ncal},1), zeros({Ncal},1));
        sum0alt = real(zeros({Ncal},1));
        sum1 = complex(zeros({Ncal},1), zeros({Ncal},1));
        sum2 = complex(zeros({Ncal},1), zeros({Ncal},1));
        altstore = complex(zeros({Ncal},1), zeros({Ncal},1));
    end

    cplx_in = complex(real_in, imag_in);
    outready = false;
    outreal = 0;
    outimag = 0;
    outbin = 0;
    powertop = 0;
    powerbot =0;
    drift_FD = 0;
    drift_SD = 0;

    if readycal
        cplx_in = cplx_in*phase_cor;
        sum0(calbin) = sum0(calbin) + cplx_in;
        if (tick>0)
            altstore (calbin) = cplx_in;
        else
            diff = (cplx_in - altstore(calbin));
            sum0alt(calbin) =  sum0alt(calbin) + real(diff*conj(diff));
        end
        sum1(calbin) = sum1(calbin) + cplx_in*complex(0,kar);
        sum2(calbin) = sum2(calbin) + cplx_in*complex(-kar*kar,0);
        if (readyout)
            csum0 = sum0(calbin);
            sum0(calbin) = complex(0,0);
            csum0alt = sum0alt(calbin);
            sum0alt(calbin) = 0.0;

            csum1 = sum1(calbin);
            sum1(calbin) = complex(0,0);
            csum2 = sum2(calbin);
            sum2(calbin) = complex(0,0);

            outreal = real(csum0);
            outimag = imag(csum0);
            drift_FD = real(csum1*conj(csum0));
            drift_SD = real(csum2*conj(csum0) + csum1*conj(csum1));

            powertop = real(csum0*conj(csum0));
            powerbot = csum0alt;

        end
    end
end

