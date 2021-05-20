classdef Lion
    %LION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        age
        gender
        position
        fitness
        % call back function
        fitnessFunction
        geneStr
        geneLength
        dimension
        boundary
    end
    
    properties (Constant)
        shift = 10000
    end
    
    methods
        function obj = Lion(value, boundary, evaluateFunc)
            obj.age = 0;
            obj.fitnessFunction = evaluateFunc;
            obj.gender = 1;
            obj.dimension = length(value);
            obj.boundary = boundary;
            obj.position = zeros(1, obj.dimension);
            
            % Setup the initial position
            for i = 1 : obj.dimension
                obj.position(i) = roundValue(value(i), obj.shift);
            end
            obj.fitness = obj.fitnessFunction(obj.position);
            
            % Calculate geneLength
            obj.geneLength = 0;
            for i = 1 : obj.dimension
                range = boundary(i, 2) - boundary(i, 1);
                range = range * obj.shift;
                obj.geneLength = max(obj.geneLength, floor(log2(range)) + 1);
            end
            
            % Setup gene string
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
            obj = obj.boundaryFit();
            obj.geneStr = obj.encode();
            obj.fitness = obj.fitnessFunction(obj.position);
        end
        
        function obj = boundaryFit(obj)
            for i = 1 : obj.dimension
                if obj.position(i) < obj.boundary(i, 1)
                    obj.position(i) = obj.boundary(i, 1);
                elseif obj.position(i) > obj.boundary(i, 2)
                    obj.position(i) = obj.boundary(i, 2);
                end
            end
        end
        
        function obj = growUp(obj)
            obj.age = obj.age + 1;
        end
    end
end

