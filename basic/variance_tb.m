clear;
clear variance_hdl;
N=4100;
samples = randn(N);

for i=1:N
    sample = int16(round((samples(i)*6000)));
    %disp(sample)
    [var,ready] = variance_hdl(sample);
    if (ready)
        disp(var)
    end
end
