classdef Gene
    %GENE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        value
        binStr
    end
    
    methods
        function obj = Gene(v)
            %GENE Construct an instance of this class
            %   Detailed explanation goes here
            obj.value = v;
            obj.binStr = encode(obj, v);
        end
        
        function str = encode(obj, v)
            tem = int32(v * 1000);
            str = dec2bin(tem);
        end
        
        function v = decode(obj, str)
            tem = bin2dec(str);
            v = tem / 1000;
        end
    end
end

