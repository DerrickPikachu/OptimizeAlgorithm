classdef Lion
    %LION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        age
        gender
        value
        fitness
        % call back function
        fitnessFunction
    end
    
    properties (Constant)
        shift = 10000
    end
    
    methods
        function obj = Lion(value, evaluateFunc)
            obj.age = 0;
            obj.value = roundValue(value, obj.shift);
            obj.fitnessFunction = evaluateFunc;
            obj.fitness = obj.fitnessFunction(obj.value);
            obj.gender = 1;
        end
        
        function obj = growUp(obj)
            obj.age = obj.age + 1;
        end
    end
end

