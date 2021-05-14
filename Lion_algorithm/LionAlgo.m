classdef LionAlgo
    
    properties
        prides
        lowerBound
        upperBound
        % call back function
        fitnessFunc
    end
    
    properties (Constant)
        numOfPride = 1
        maxIter = 100
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
                range = obj.upperBound - obj.lowerBound;
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
                if isempty(obj.prides(i).cubs)
                    obj.prides(i) = obj.prides(i).reproduce();
                end
            end
        end
        
        function obj = defence(obj)
            for i = 1 : obj.numOfPride
                %fprintf('pride: %d\n', i);
                
                % Get rand new value
                range = obj.upperBound - obj.lowerBound;
                bias = range / 2;
                val = rand * range - bias;
                
                % Generate nomad lion and challenge the pride
                nomad = Lion(val, obj.fitnessFunc);
                if ~obj.prides(i).fightNomad(nomad)
                    %fprintf('lose\n');
                    obj.prides(i) = obj.prides(i).occupied(nomad);
                else
                    %fprintf('win\n');
                end
                %fprintf('-------------------------\n');
            end
        end
        
        function obj = takeOver(obj)
            for i = 1 : obj.numOfPride
                obj.prides(i) = obj.prides(i).takeOver();
            end
        end
        
        function obj = nextIter(obj)
            for i = 1 : obj.numOfPride
                obj.prides(i) = obj.prides(i).nextTimeStep();
            end
        end
        
        function showCurrent(obj)
            best = 0;
            sum = 0;
            for i = 1 : obj.numOfPride
                prideBest = obj.prides(i).getStrongest();
                if best > prideBest
                    best = prideBest;
                end
                sum = obj.prides(i).male.fitness + obj.prides(i).female.fitness;
            end
            
            mean = sum / (2 * obj.numOfPride);
            fprintf('current mean: %f\n', mean);
            fprintf('current best: %f\n', best);
            fprintf('---------------------------------\n');
        end
        
        function obj = fit(obj)
            obj = obj.generatePride();
            for i = 1 : obj.maxIter
                obj = obj.reproduce();
                obj = obj.defence();
                obj = obj.takeOver();
                obj = obj.nextIter();
                obj.showCurrent();
            end
        end
    end
end

