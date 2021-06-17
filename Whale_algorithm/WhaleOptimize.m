classdef WhaleOptimize
    
    properties
        fitnessFunction
        boundary
        bestWhale
        whales
        dimension
        stepSize
        meanArray
        bestArray
    end
    
    properties(Constant)
        numOfWhale = 10
        maxIter = 200
        a = 2
        spiralConstant = 0.5
    end
    
    methods
        function obj = WhaleOptimize(boundary, func)
            % Parameter init
            obj.boundary = boundary;
            obj.fitnessFunction = func;
            obj.dimension = length(boundary);
            obj.whales = Whale.empty(0, obj.numOfWhale);
            obj.stepSize = obj.a / obj.maxIter;
            obj.meanArray = zeros(1, obj.maxIter);
            obj.bestArray = zeros(1, obj.maxIter);
            
            % Whale init
            obj = obj.whaleInit();
            
            % Find best one
            obj.bestWhale = obj.findBest();
        end
        
        function obj = whaleInit(obj)
            for i = 1 : obj.numOfWhale
                randomPos = zeros(1, obj.dimension);
                
                % Rand a position within the boundary
                for j = 1 : obj.dimension
                    range = obj.boundary(j, 2) - obj.boundary(j, 1);
                    pos = rand * range + obj.boundary(j, 1);
                    randomPos(j) = pos;
                end
                
                obj.whales(i) = Whale(randomPos, obj.boundary, obj.fitnessFunction);
            end
        end
        
        function bestWhale = findBest(obj)
            bestFitness = obj.whales(1).fitness;
            bestFitIndex = 1;
            
            for i = 1 : obj.numOfWhale
                if bestFitness > obj.whales(i).fitness
                    bestFitness = obj.whales(i).fitness;
                    bestFitIndex = i;
                end
            end
            
            bestWhale = obj.whales(bestFitIndex);
        end
        
        function mean = getMean(obj)
            mean = 0;
            
            for i = 1 : obj.numOfWhale
                mean = mean + obj.whales(i).fitness;
            end
            
            mean = mean / obj.numOfWhale;
        end
        
        function obj = update(obj, iteration)
            for i = 1 : obj.numOfWhale
                cura = obj.a - obj.stepSize * iteration;
                A = 2 * cura * rand - cura;
                
                if abs(A) < 1
                    p = rand;
                    if p < 0.5
                        C = 2 * rand;
                        obj.whales(i) = obj.whales(i).encircleUpdate(obj.bestWhale, A, C);
                    elseif p >= 0.5
                        obj.whales(i) = obj.whales(i).spiralUpdate(obj.bestWhale, obj.spiralConstant);
                    end
                elseif abs(A) >= 1
                    target = ceil(rand * 10);
                    C = 2 * rand;
                    obj.whales(i) = obj.whales(i).encircleUpdate(obj.whales(target), A, C);
                end
            end
        end
        
        function obj = fit(obj)
            for i = 1 : obj.maxIter
                obj = obj.update(i);
                obj.bestWhale = obj.findBest();
                obj.meanArray(i) = obj.getMean();
                
                fprintf('iteration: %d\n', i);
                fprintf('mean: %f\n', obj.meanArray(i));
                fprintf('best whale: %f\n', obj.bestWhale.fitness);
                fprintf('position: %f, %f\n', obj.bestWhale.position(1), obj.bestWhale.position(2));
                fprintf('----------------------------\n');
            end
        end
    end
end

