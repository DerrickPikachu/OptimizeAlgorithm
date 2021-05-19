classdef LionAlgo
    
    properties
        prides
        lowerBound
        upperBound
        % call back function
        fitnessFunc
        meanArray
        bestArray
    end
    
    properties (Constant)
        numOfPride = 10
        maxIter = 150
    end
    
    methods
        function obj = LionAlgo(lowerBound, upperBound, fitness)
            obj.lowerBound = lowerBound;
            obj.upperBound = upperBound;
            obj.fitnessFunc = fitness;
            obj.prides = PrideOfLion.empty(0, obj.numOfPride);
            meanArray = zeros(1, obj.maxIter);
            bestArray = zeros(1, obj.maxIter);
        end
        
        function obj = generatePride(obj)
            for i = 1 : obj.numOfPride
                % Random two position
                range = obj.upperBound - obj.lowerBound;
                bias = range / 2;
                malePos(1) = rand * range - bias;
                malePos(2) = rand * range - bias;
                femalePos(1) = rand * range - bias;
                femalePos(2) = rand * range - bias;
                
                male = Lion(malePos, obj.fitnessFunc);
                female = Lion(femalePos, obj.fitnessFunc);
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
                nomadPos(1) = rand * range - bias;
                nomadPos(2) = rand * range - bias;
                
                % Generate nomad lion and challenge the pride
                nomad = Lion(nomadPos, obj.fitnessFunc);
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
        
        function obj = showCurrent(obj, iter)
            best = obj.prides(1).male.fitness;
            sum = 0;
            for i = 1 : obj.numOfPride
                prideBest = obj.prides(i).getStrongest();
                if best > prideBest
                    best = prideBest;
                end
                sum = sum + obj.prides(i).male.fitness + obj.prides(i).female.fitness;
            end
            
            mean = sum / (2 * obj.numOfPride);
            obj.meanArray(iter) = mean;
            obj.bestArray(iter) = best;
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
                obj = obj.showCurrent(i);
            end
        end
    end
end

