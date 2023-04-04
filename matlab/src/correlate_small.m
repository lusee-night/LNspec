function [A1,A2,X12R,X12I] = correlate_small (ch1_val, ch2_val)

    A1 = real (ch1_val*conj(ch1_val));
    A2 = real (ch2_val*conj(ch2_val));

    X12 = ch1_val*conj(ch2_val);
    X12R = real(X12);
    X12I = imag(X12);
end