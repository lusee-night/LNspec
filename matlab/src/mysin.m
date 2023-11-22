function v = mysin(x)
    if x < 0
        x = -x;
        sign = -1;
    else
        sign = 1;
    end

    if x > pi/2
        x = pi - x;
    end

    %assert(x >= 0 && x <= pi/2);
    if x > 3*pi/8
        d = pi/2 - x;
        d2 = d*d;
        d4= d2*d2;
        d6 = d4*d2;
        d8 = d4*d4;
        v = 1 - 0.5*d2 + 1/24*d4 - 1/720*d6 + 1/40320*d8;
    elseif x > pi/8
        d = x - pi/4;
        d2 = d*d;
        d3 = d2*d;
        d4 = d2*d2;
        d5 = d4*d;
        d6 = d4*d2;
        d7 = d6*d;
        d8 = d4*d4;

        v = 1 + d - 0.5*d2 - 1/6*d3 + 1/24*d4 + 1/120*d5 - 1/720*d6 - 1/5040*d7 + 1/40320*d8;
        v = v * 0.7071067810;
    else
        d = x;
        d2 = d*d;
        d3 = d*d*d;
        d5 = d3*d2;
        d7 = d5*d2;
        v = x - 1/6*d3 + 1/120*d5 - 1/5040*d7;
    end
    v = sign * v;
end
