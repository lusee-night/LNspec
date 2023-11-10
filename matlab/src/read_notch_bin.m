function data = read_samples_bin(fname, lines)
    fid = fopen(fname);
    if lines > 0
        %size = {Nfft}*2*lines
        %fprintf("Reading %d elements\n", size)
        data = transpose(fread(fid,[(2*{Nchan}) (lines) ],'float32'));

    else
        data = transpose(fread(fid, 'float32'));
        data = transpose(reshape(data, (2*{Nchan}), []));
    end
    
    data = data * 1e7; 
    fclose(fid);
end