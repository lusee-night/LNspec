function [pks, ready] = spectrometer (sample1, sample2)
    persistent wf1 weight_fold1 wf2 weight_fold2;

    if isempty (wf1) 
        wf1 = weight_fold; 
        weight_fold1 = @(sample1,w1,w2,w3,w4)wf1.process(sample1,w1,w2,w3,4);
        wf2 = weight_fold;
        weight_fold2 = @(sample2,w1,w2,w3,w4)wf1.process(sample2,w1,w2,w3,4);
    end

    
    [w1,w2,w3,w4] = weight_streamer();
    acc1 = weight_fold1(sample1, w1, w2, w3, w4);
    acc2 = weight_fold2(sample2, w1, w2, w3, w4);
    
    val = complex(acc1,acc2);
    [fft_out, fft_valid] = sfft(val');
    
    [P1,P2,PX,PR, bin, cready] = correlate(fft_out,fft_valid);
    [pks, ready] = average(P1,P2,PX,PR, bin, cready);

end

