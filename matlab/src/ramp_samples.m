function data = ramp_samples(Nmax, repeats)
    data = zeros(1,Nmax*repeats);
    for i=0:repeats-1
        data(i*Nmax+1:(i+1)*Nmax) = 0:Nmax-1;
    end
    data = int16(data);
end