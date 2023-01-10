function val = ramwrap (ndx, write_val, write)
    persistent buf;
    if isempty(buf)
        buf = zeros (1,{Nfft});
    end
    if (write)
        buf(ndx+1) = write_val;
        val = write_val;
    else
        val = buf(ndx+1);
    end
end

        

        