classdef WhaleOptimize
    
    properties
        fitnessFunction
        boundary
        bestWhale
        whales
        dimension
    end
    
    properties(Constant)
        numOfWhale = 10
        maxIter = 100
        a = 2
    end
    
    methods
        function obj = WhaleOptimize(boundary, func)
            % Parameter init
            obj.boundary = boundary;
            obj.fitnessFunction = func;
            obj.dimension = length(boundary);
            obj.whales = Whale.empty(0, obj.numOfWhale);
            
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
    end
end
