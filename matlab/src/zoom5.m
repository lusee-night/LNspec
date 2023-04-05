function [ch_val_zoom, out_bin, out_ready] = zoom5 (ch_val,bin,ready)
persistent fft_weight count work outbuf out_count;

if isempty(fft_weight)
    %(((0.2, 0.0 ),(-0.1618033988749895, -0.11755705045849463 ),(0.06180339887498949, 0.1902113032590307 ),(0.06180339887498949, -0.1902113032590307 ),(-0.1618033988749895, 0.11755705045849463 )),
    %((0.2, 0.0 ),(0.06180339887498949, -0.1902113032590307 ),(-0.1618033988749895, -0.11755705045849463 ),(-0.1618033988749895, 0.11755705045849463 ),(0.06180339887498949, 0.1902113032590307 )),
    %((0.2, 0.0 ),(0.2, 0.0 ),(0.2, 0.0 ),(0.2, 0.0 ),(0.2, 0.0 )),
    %((0.2, 0.0 ),(0.06180339887498949, 0.1902113032590307 ),(-0.1618033988749895, 0.11755705045849463 ),(-0.1618033988749895, -0.11755705045849463 ),(0.06180339887498949, -0.1902113032590307 )),
    %((0.2, 0.0 ),(-0.1618033988749895, 0.11755705045849463 ),(0.06180339887498949, -0.1902113032590307 ),(0.06180339887498949, 0.1902113032590307 ),(-0.1618033988749895, -0.11755705045849463 )));
    fft_weight_real = [ 0.2 -0.1618033988749895 0.06180339887498949 0.06180339887498949 -0.1618033988749895; ...
                        0.2 0.06180339887498949 -0.1618033988749895 -0.1618033988749895 0.06180339887498949; ...
                        0.2 0.2 0.2 0.2 0.2; ...
                        0.2 0.06180339887498949 -0.1618033988749895 -0.1618033988749895 0.06180339887498949; ...
                        0.2 -0.1618033988749895 0.06180339887498949 0.06180339887498949 -0.1618033988749895];
    fft_weight_imag = [ 0.0 -0.11755705045849463 0.1902113032590307 -0.1902113032590307 0.11755705045849463; ...
                        0.0 -0.1902113032590307 -0.11755705045849463 0.11755705045849463 0.1902113032590307; ...
                        0.0 0.0 0.0 0.0 0.0; ...
                        0.0 0.1902113032590307 0.11755705045849463  -0.11755705045849463 -0.1902113032590307; ...
                        0.0 0.11755705045849463 -0.1902113032590307 0.1902113032590307 -0.11755705045849463];
    fft_weight = 5*complex(fft_weight_real, fft_weight_imag);
    count = 1;
    work = complex(zeros(1,8*5),zeros(1,8*5));
    outbuf = complex(zeros(1,8*5),zeros(1,8*5));
    out_count = 0;
end

out_ready = 0;
ch_val_zoom = complex(0,0);
out_bin = out_count-1;
if (out_count>0)
    out_ready = 1;
    ch_val_zoom = outbuf(out_count);
    out_count = out_count - 1;
end 

%% here we only do the first 8 points
if (bin<8) & ready
    for i=1:5
        ndx =(bin)*5+i;
        work(ndx) = work(ndx) + fft_weight(i,count)*ch_val;
    end 
    
    if bin==1
        count = count + 1;
        if count==6
            outbuf = work;
            out_count = 8*5;
            work = complex(zeros(1,8*5),zeros(1,8*5));
            count=1;
        end
    end
end
    
end 
