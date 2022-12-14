function val = weight_fold_func2 (sample, w1,w2,w3,w4 )
    persistent buf1 c tout
    if isempty(buf1)
            buf1 = zeros(4, 4096);
            c = uint16(1); % we use 0-ordered for c
            tout = uint8(4);
    end

    buf1(1,c) = buf1(1,c) + sample * w1;
    buf1(2,c) = buf1(2,c) + sample * w2;
    buf1(3,c) = buf1(3,c) + sample * w3;
    buf1(4,c) = buf1(4,c) + sample * w4;
            
    val = buf1(tout,c);
    buf1 (tout,c) = 0.0;
            
    % if (mod(c,4096)==401)
    %     disp([sample,val,tout])
    %     disp([w1,w2,w3,w4])
    % end


    c = c+1;
    if c==4097
        c = uint16(1);
        tout = tout - 1;
        if tout == 0
            tout = uint8(4);
        end
    end
end


