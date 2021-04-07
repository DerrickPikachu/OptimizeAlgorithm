classdef GA
    
    properties
        genes
        evaluateFunction
    end
    properties(Constant)
        distribution = 70; % persentage
        survived = 0.80; % probability
        crossOverRate = 0.70; % probability
        mutationRate = 0.30; % probability
        terminateLimit = 3;
        numGeneLimit = 10000;
        generationLimit = 20;
    end
    
    methods
        % Constructor
        function obj = GA(amount, callBack)
            % Set up the target function
            obj.evaluateFunction = callBack;
            
            % amount must be even number
            if (mod(amount, 2) ~= 0)
                amount = amount - 1;
            end
            
            % Init the genes
            for i = 1 : amount
                x = obj.getRand(Gene.lowerBoundX, Gene.upperBoundX);
                y = obj.getRand(Gene.lowerBoundY, Gene.upperBoundY);
                gene = Gene(x, y);
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
        
        function grade = evaluate(obj)
            [~, n] = size(obj.genes);
            grade = zeros(1, n);
            for i = 1 : n
                x = obj.genes(i).valueX;
                y = obj.genes(i).valueY;
                grade(i) = obj.evaluateFunction(x, y);
            end
        end
        
        % Public methods
        function gene = fit(obj)
            previousScore = 0;
            score = 0;
            terminalCounter = 0;
            generation = 0;
            graphX = zeros(1, obj.generationLimit + 1);
            graphY = zeros(1, obj.generationLimit + 1);
            
            for i = 1 : obj.generationLimit + 1
                graphX(i) = i;
            end
            
            % Evaluate all genes first
            grade = obj.evaluate();
            score = min(grade);
            graphY(generation + 1) = score;
            
            while (generation < obj.generationLimit)
                previousScore = score;
                [~, n] = size(obj.genes);
                
                % Sort the value by grade
                [~, I] = sort(grade, 'descend');
                obj.genes = obj.genes(I);

                % Select the survived gene
                amount = floor(obj.survived * n);
                if (amount > obj.numGeneLimit)
                    amount = obj.numGeneLimit;
                end
                selected = obj.select(n, amount);
                [~, geneSize] = size(selected);
                original = obj.genes;
                obj.genes = [];
                for i = 1 : geneSize
                    obj.genes = [obj.genes, original(selected(i))];
                end

                % Cross over
                [~, n] = size(obj.genes);
                if (mod(n, 2) ~= 0)
                    n = n - 1;
                end
                child = [];
                for i = 1 : 2 : n
                    if (rand < obj.crossOverRate)
                        [c1, c2] = crossOver(obj.genes(i), obj.genes(i + 1));
                        if (c1.isValid)
                            child = [child, c1];
                        end
                        if (c2.isValid)
                            child = [child, c2];
                        end
                    end
                end
                obj.genes = [obj.genes, child];

                % Mutation
                [~, n] = size(obj.genes);
                for i = 1 : n
                    if (rand < obj.mutationRate)
                        newGene = mutation(obj.genes(i));
                        if (newGene.isValid)
                            obj.genes(i) = newGene;
                        end
                    end
                end
                
                % Evaluate all The genes, and check the terminal
                grade = obj.evaluate();
                generation = generation + 1;
                [score, i] = min(grade);
                graphY(generation + 1) = score;
                if (score == previousScore)
                    terminalCounter = terminalCounter + 1;
                else
                    terminalCounter = 0;
                end
                
                % Ouput the generation
                fprintf('-----------------------------------\n');
                fprintf('generation: %d\n', generation);
                fprintf('Best Scord: %f\n', score);
                fprintf('Terminal difference: %f\n', score - previousScore);
                % fprintf('Terminal Count: %f\n', terminalCounter);
                fprintf('Best Gene: x = %f, y = %f, valid = %d\n', obj.genes(i).valueX, obj.genes(i).valueY, obj.genes(i).isValid);
                fprintf('-----------------------------------\n\n');
            end
            
            plot(graphX, graphY);
        end
    end
end