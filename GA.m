classdef GA
    
    properties
        genes
    end
    properties(Constant)
        upperBoundX = 4;
        lowerBoundX = -1.5;
        upperBoundY = 3;
        lowerBoundY = -3;
    end
    
    methods
        
        function obj = GA(amount)
            for i = 1 : amount
                x = obj.getRand(obj.lowerBoundX, obj.upperBoundX);
                y = obj.getRand(obj.lowerBoundY, obj.upperBoundY);
                gene = Gene(x, y, obj.lowerBoundX, obj.upperBoundX, obj.lowerBoundY, obj.upperBoundY);
                obj.genes = [obj.genes, gene];
            end
        end
        
        % The helper function
        function randNum = getRand(~, lowerBound, upperBound)
            range = upperBound - lowerBound;
            randNum = floor(rand * range * 1000) / 1000;
            randNum = randNum + lowerBound;
        end
        
        function gene = fit(obj)
        end
    end
end