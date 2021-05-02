classdef LionAlgo
    
    properties
        prides
        lowerBound
        upperBound
        % call back function
        fitnessFunc
    end
    
    properties (Constant)
        numOfPride = 10
    end
    
    methods
        function obj = LionAlgo(lowerBound, upperBound, fitness)
            obj.lowerBound = lowerBound;
            obj.upperBound = upperBound;
            obj.fitnessFunc = fitness;
            obj.prides = PrideOfLion.empty(0, obj.numOfPride);
        end
        
        function obj = generatePride(obj)
            for i = 1 : obj.numOfPride
                % Rand two number
                range = obj.lowerBound - obj.upperBound;
                bias = range / 2;
                val1 = rand * range - bias;
                val2 = rand * range - bias;
                
                male = Lion(val1, obj.fitnessFunc);
                female = Lion(val2, obj.fitnessFunc);
                obj.prides(i) = PrideOfLion(male, female, obj.lowerBound, obj.upperBound, obj.fitnessFunc);
            end
        end
        
        function obj = reproduce(obj)
            for i = 1 : obj.numOfPride
                obj.prides(i) = obj.prides(i).crossover();
                obj.prides(i) = obj.prides(i).mutation();
            end
        end
        
        function obj = defence(obj)
            for i = 1 : obj.numOfPride
                fprintf('pride: %d\n', i);
                
                % Get rand new value
                range = obj.lowerBound - obj.upperBound;
                bias = range / 2;
                val = rand * range - bias;
                
                % Generate nomad lion and challenge the pride
                nomad = Lion(val, obj.fitnessFunc);
                if ~obj.prides(i).fightNomad(nomad)
                    fprintf('lose\n');
                    obj.prides(i) = obj.prides(i).occupied(nomad);
                else
                    fprintf('win\n');
                end
                fprintf('-------------------------\n');
            end
        end
        
        function obj = fit(obj)
            obj = obj.generatePride();
            obj = obj.reproduce();
            obj = obj.defence();
        end
    end
end

