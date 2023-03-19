function [A1,A2,A3,A4,X12R,X12I,X13R,X13I,X14R,X14I,X23R,X23I,X24R,X24I,X34R, X34I] = correlate_alt (ch1_val, ch2_val, ch3_val, ch4_val)

    c1r = real(ch1_val);
    c1i = imag(ch1_val);
    c2r = real(ch2_val);
    c2i = imag(ch2_val);
    c3r = real(ch3_val);
    c3i = imag(ch3_val);
    c4r = real(ch4_val);
    c4i = imag(ch4_val);

    A1 = c1r*c1r+c1i*c1i;
    A2 = c2r*c2r+c2i*c2i;
    A3 = c3r*c3r+c3i*c3i;
    A4 = c4r*c4r+c4i*c4i;
    
    X12R = c1r*c2r+c1i*c2i;
    X12I = -c1r*c2i+c1i*c2r;

    X13R = c1r*c3r+c1i*c3i;
    X13I = -c1r*c3i+c1i*c3r;

    X14R = c1r*c4r+c1i*c4i;
    X14I = -c1r*c4i+c1i*c4r;

    X23R = c2r*c3r+c2i*c3i;
    X23I = -c2r*c3i+c2i*c3r;
    
    X24R = c2r*c4r+c2i*c4i;
    X24I = -c2r*c4i+c2i*c4r;

    X34R = c3r*c4r+c3i*c4i;
    X34I = -c3r*c4i+c3i*c4r;

end