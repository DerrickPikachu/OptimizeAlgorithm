classdef GA
    
    properties
        genes
        evaluateFunction
    end
    properties(Constant)
        upperBoundX = 4;
        lowerBoundX = -1.5;
        upperBoundY = 3;
        lowerBoundY = -3;
        distribution = 70;
    end
    
    methods
        function obj = GA(amount, callBack)
            % Set up the target function
            obj.evaluateFunction = callBack;
            
            % amount must be even number
            if (mod(amount, 2) ~= 0)
                amount = amount - 1;
            end
            
            % Init the genes
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
        
        function choosed = getRandomGene(~, sequence, amount)
            map = containers.Map('KeyType', 'int32', 'ValueType', 'int32');
            [~, range] = size(sequence);
            choosed = [];
            
            for i = 1 : amount
                choose = 0;
                while (choose == 0 || map.isKey(choose))
                    choose = ceil(rand * range);
                end
                map(choose) = 1;
                choosed = [choosed, choose];
            end
        end
        
        function selected = select(obj, n, amount)
            goods = 0;
            bads = 0;
            sequence = zeros(1, n);
            
            % Init sequence
            for i = 1 : n
                sequence(i) = i;
            end
            
            % Count the good survived gene and bad survive gene
            for i = 1 : amount
                randNum = ceil(rand * 100);
                if (randNum <= obj.distribution)
                    goods = goods + 1;
                else
                    bads = bads + 1;
                end
            end
            
            fprintf('goods: %d\n', goods);
            fprintf('bads: %d\n', bads);
            
            % Choose the gene we need
            half = floor(n / 2);
            if (goods >= half)
                selectedGoods = sequence(n - goods + 1 : n);
                selectedBads = obj.getRandomGene(sequence(1 : n - goods), bads);
            elseif (bads >= half)
                selectedGoods = obj.getRandomGene(sequence(bads + 1 : n), goods);
                selectedBads = sequence(1, bads);
            else
                selectedGoods = obj.getRandomGene(sequence(half + 1 : n), goods);
                selectedBads = obj.getRandomGene(sequence(1: half), bads);
            end
            
            selected = [selectedGoods, selectedBads];
        end
        
        % Public methods
        function gene = fit(obj)
            [a, n] = size(obj.genes);
            grade = zeros(1, n);
            
            % Evaluate all the genes
            for i = 1 : n
                x = obj.genes(i).valueX;
                y = obj.genes(i).valueY;
                grade(i) = obj.evaluateFunction(x, y);
            end
            
            % Sort the value by grade
            [grade, I] = sort(grade);
            obj.genes = Y(I);
            
            
        end
    end
end