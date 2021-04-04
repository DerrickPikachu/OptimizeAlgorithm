classdef Gene
    %GENE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        valueX
        valueY
        geneStr
        isValid
    end
    properties (Constant)
        geneLen = 13;
        shift = 1000;
        offsetX = 1.5;
        offsetY = 3;
        upperBoundX = 4;
        lowerBoundX = -1.5;
        upperBoundY = 3;
        lowerBoundY = -3;
    end
    
    methods
        %  The constructor
        function obj = Gene(x, y)
            %GENE Construct an instance of this class
            %   Detailed explanation goes here
            obj.valueX = x;
            obj.valueY = y;
            obj.geneStr = encode(obj);
            obj.isValid = obj.setValid();
        end
        
        function obj = setGene(obj, sequence)
            obj.geneStr = sequence;
            [obj.valueX, obj.valueY] = obj.decode();
            obj.isValid = obj.setValid();
        end
        
        % The helper function
        function str = toGene(obj, value, offset)
            tem = value + offset;
            tem = int32(tem * obj.shift);
            str = dec2bin(tem);
            % Resize to 13 bits
            zeros = obj.geneLen - strlength(str);
            zeroAppend = '';
            for i = 1 : zeros
                zeroAppend = append(zeroAppend, '0');
            end
            % Append zero to str
            str = append(zeroAppend, str);
        end
        
        function v = toValue(obj, gene, offset)
            tem = bin2dec(gene);
            v = (tem / obj.shift) - offset;
        end
        
        function valid = setValid(obj)
            % Boundary Check
            valid = (obj.valueX >= obj.lowerBoundX && obj.valueX <= obj.upperBoundX && obj.valueY >= obj.lowerBoundY && obj.valueY <= obj.upperBoundY);
        end
        
        % Public methods
        function str = encode(obj)
            % Encode hole gene sequence
            geneX = obj.toGene(obj.valueX, obj.offsetX);
            geneY = obj.toGene(obj.valueY, obj.offsetY);
            str = append(geneX, geneY);
        end
        
        function [x, y] = decode(obj)
            % Decode hole gene sequence
            geneX = obj.geneStr(1: obj.geneLen);
            geneY = obj.geneStr(obj.geneLen + 1: obj.geneLen * 2);
            x = obj.toValue(geneX, obj.offsetX);
            y = obj.toValue(geneY, obj.offsetY);
        end
    end
end

