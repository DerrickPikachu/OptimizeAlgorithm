classdef Gene
    
    properties
        position
        fitness
        evaluateFunc
        geneStr
        boundary
        geneLength
        dimension
    end
    
    properties(Constant)
        shift = 10000
    end
    
    methods
        function obj = Gene(x, boundary, evaluateF)
            obj.position = x;
            [~, obj.dimension] = size(x);
            obj.boundary = boundary;
            obj.evaluateFunc = evaluateF;
            obj.fitness = obj.evaluateFunc(obj.position);
            
            % Calculate geneLength
            obj.geneLength = 0;
            for i = 1 : obj.dimension
                range = boundary(i, 2) - boundary(i, 1);
                range = range * obj.shift;
                obj.geneLength = max(obj.geneLength, floor(log2(range)) + 1);
            end
            
            % Encode gene string
            obj.geneStr = obj.encode();
        end
        
        function totalStr = encode(obj)
            totalStr = '';
            for i = 1 : obj.dimension
                value = obj.position(i);
                value = (value - obj.boundary(i, 1)) * obj.shift;
                binValue = dec2bin(value);
                [~, len] = size(binValue);
                
                for j = 1 : obj.geneLength - len
                    binValue = append('0', binValue);
                end
                
                totalStr = append(totalStr, binValue);
            end
        end
        
        function obj = decode(obj, geneString)
            for i = 0 : obj.dimension - 1
                base = obj.geneLength * i + 1;
                gene = geneString(base : base + obj.geneLength - 1);
                obj.position(i + 1) = bin2dec(gene) / obj.shift + obj.boundary(i + 1, 1);
            end
            obj.geneStr = geneString;
            obj.fitness = obj.evaluateFunc(obj.position);
        end
    end
end

