function [outpk, outbin, ready_out] = average(ch1_val, ch2_val, count, ready_in)
    persistent  Nac P1A stream streaming overN;

    if isempty(Nac)
        Nac = 0;
        P1A = zeros(1,{Nchan}+1);
        stream = 1;
        streaming = false;
        overN = {overNavg};
    end

    
    ready_out = false;
    P1 = {part}(ch1_val*conj(ch2_val)); % part will be replaced by preprocessor
    zero_acc = (Nac==0); % on the first go, we don't add.
    count = count*int16(ready_in);
    P1A (count+1) = P1A(count+1)*zero_acc + P1*{overNavg}*(ready_in);
    outpk = P1A(stream+1);
    outbin = stream;

    %Nac = Nac+(ready_in)*(count==1);
    %streaming = (Nac == {Navg})*(count==1);
    %Nac = Nac * ((Nac== {Navg}) & streaming);
    
    Nac = Nac + ((ready_in) & (count == 1));
    if (Nac == {Navg});
        streaming=true;
        Nac = 0;
    end
    
    ready_out = streaming;
    stream = stream + 1*streaming;
    if stream>{Nchan}
        stream  = 1;
        streaming = false;
    end
end

