classdef LionAlgo
    
    properties
        prides
        boundary
        dimension
        % call back function
        fitnessFunc
        meanArray
        bestArray
    end
    
    properties (Constant)
        numOfPride = 15
        maxIter = 300
    end
    
    methods
        function obj = LionAlgo(boundary, dimension, fitness)
            obj.boundary = boundary;
            obj.dimension = dimension;
            obj.fitnessFunc = fitness;
            obj.prides = PrideOfLion.empty(0, obj.numOfPride);
            obj.meanArray = zeros(1, obj.maxIter);
            obj.bestArray = zeros(1, obj.maxIter);
        end
        
        function obj = generatePride(obj)
            for i = 1 : obj.numOfPride
                malePos = zeros(1, obj.dimension);
                femalePos = zeros(1, obj.dimension);
                
                % Random two position
                for d = 1 : obj.dimension
                    range = obj.boundary(d, 2) - obj.boundary(d, 1);
                    bias = range / 2;
                    malePos(d) = rand * range - bias;
                    femalePos(d) = rand * range - bias;
                end
                
                male = Lion(malePos, obj.boundary, obj.fitnessFunc);
                female = Lion(femalePos, obj.boundary, obj.fitnessFunc);
                obj.prides(i) = PrideOfLion(male, female, obj.boundary, obj.dimension, obj.fitnessFunc);
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
                nomadPos = zeros(1, obj.dimension);
                
                % Get rand new value
                for d = 1 : obj.dimension
                    range = obj.boundary(d, 2) - obj.boundary(d, 1);
                    bias = range / 2;
                    nomadPos(d) = rand * range - bias;
                end
                
                % Generate nomad lion and challenge the pride
                nomad = Lion(nomadPos, obj.boundary, obj.fitnessFunc);
                if ~obj.prides(i).fightNomad(nomad)
                    obj.prides(i) = obj.prides(i).occupied(nomad);
                end
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

