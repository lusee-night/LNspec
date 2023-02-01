function data = read_samples_bin(fname)
    fid = fopen(fname);
    data = fread(fid,'int16');
    fclose(fid);
end