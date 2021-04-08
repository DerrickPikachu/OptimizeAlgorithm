classdef Gene
    % When using Gene, be careful to check the valid state.
    
    properties
        valueX
        valueY
        geneStr
        isValid
        upperBoundX
        lowerBoundX
        upperBoundY
        lowerBoundY
        offsetX
        offsetY
    end
    properties (Constant)
        geneLen = 13;
        shift = 1000;
    end
    
    methods
        %  The constructor
        function obj = Gene(x, y, ubx, lbx, uby, lby)
            % Object value init
            obj.valueX = x;
            obj.valueY = y;
            obj.upperBoundX = ubx;
            obj.lowerBoundX = lbx;
            obj.upperBoundY = uby;
            obj.lowerBoundY = lby;
            obj.offsetX = -lbx;
            obj.offsetY = -lby;
            
            % Setup corresponding gene sequence
            obj.geneStr = encode(obj);
            
            % Set the valid flag
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

