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
        function obj = Lion(value, evaluateFunc)
            obj.age = 0;
            obj.fitnessFunction = evaluateFunc;
            obj.gender = 1;
            obj.dimension = length(value);
%             obj.boundary = boundary;
            obj.position = zeros(1, obj.dimension);
            
            for i = 1 : obj.dimension
                obj.position(i) = roundValue(value(i), obj.shift);
            end
            
            obj.fitness = obj.fitnessFunction(obj.position);
        end
        
        function obj = growUp(obj)
            obj.age = obj.age + 1;
        end
    end
end

