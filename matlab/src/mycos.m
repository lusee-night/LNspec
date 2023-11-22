function v = mycos(x)
    x = x + pi/2;
    if x > pi
        x = x - 2*pi;
    end
    v = mysin(x);
end