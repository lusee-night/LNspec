function [A1,A2,A3,A4,X12R,X12I,X13R,X13I,X14R,X14I,X23R,X23I,X24R,X24I,X34R, X34I] = correlate (ch1_val, ch2_val, ch3_val, ch4_val)

    A1 = real (ch1_val*conj(ch1_val));
    A2 = real (ch2_val*conj(ch2_val));
    A3 = real (ch3_val*conj(ch4_val));
    A4 = real (ch4_val*conj(ch4_val));

    X12 = ch1_val*conj(ch2_val);
    X12R = real(X12);
    X12I = imag(X12);

    X13 = ch1_val*conj(ch3_val);
    X13R = real(X12);
    X13I = imag(X12);

    X14 = ch1_val*conj(ch4_val);
    X14R = real(X12);
    X14I = imag(X12);

    X23 = ch2_val*conj(ch3_val);
    X23R = real(X12);
    X23I = imag(X12);

    X24 = ch2_val*conj(ch4_val);
    X24R = real(X12);
    X24I = imag(X12);

    X34 = ch3_val*conj(ch4_val);
    X34R = real(X12);
    X34I = imag(X12);
end