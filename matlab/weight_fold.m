classdef weight_fold < handle

    properties (Access = public)
            buf1 = zeros(4, 4096);
            c = uint16(1); % we use 0-ordered for c
            tout = uint8(4);
    end

    methods
        
        function val = process (self,sample, w1,w2,w3,w4 )
            self.buf1(1,self.c) = self.buf1(1,self.c) + sample * w1;
            self.buf1(2,self.c) = self.buf1(2,self.c) + sample * w2;
            self.buf1(3,self.c) = self.buf1(3,self.c) + sample * w3;
            self.buf1(4,self.c) = self.buf1(4,self.c) + sample * w4;
            
            val = self.buf1(self.tout,self.c);
            self.buf1 (self.tout,self.c) = 0.0;
            
            self.c = self.c+1;
            if self.c==4097
                self.c = uint16(1);
                self.tout = self.tout - 1;
                if self.tout == 0
                    self.tout = uint8(4);
                end
            end
        end
    end
end


