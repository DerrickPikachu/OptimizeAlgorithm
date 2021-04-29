classdef LionAlgo
    
    properties
        prides
        lowerBound
        upperBound
        % call back function
        evaluateFunc
    end
    
    properties (Constant)
        numOfPride = 10
    end
    
    methods
        function obj = LionAlgo(lowerBound, upperBound, fitness)
            obj.lowerBound = lowerBound;
            obj.upperBound = upperBound;
            obj.evaluateFunc = fitness;
            obj.prides = PrideOfLion.empty(0, obj.numOfPride);
            obj = obj.generatePride();
        end
        
        function obj = generatePride(obj)
            for i = 1 : obj.numOfPride
                % Rand two number
                range = obj.lowerBound - obj.upperBound;
                bias = range / 2;
                val1 = rand * range - bias;
                val2 = rand * range - bias;
                
                male = Lion(val1, obj.evaluateFunc);
                female = Lion(val2, obj.evaluateFunc);
                obj.prides(i) = PrideOfLion(male, female, obj.lowerBound, obj.upperBound, obj.evaluateFunc);
            end
        end
    end
end
