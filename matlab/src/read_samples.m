function data = read_samples(fname)
    data = str2num(fileread(fname));
    for i=1:length(data)
        if data(i)>8192;
            data(i) = data(i) - 16384;
        end
    end
    data = int16(data);
end