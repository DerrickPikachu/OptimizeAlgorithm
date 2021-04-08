classdef GA
    
    properties
        genes
        evaluateFunction
        upperBoundX
        lowerBoundX
        upperBoundY
        lowerBoundY
        crossoverRate
        mutationRate
        survived
    end
    properties(Constant)
        distribution = 70; % persentage
        % survived = 0.80; % probability
        % crossOverRate = 0.80; % probability
        % mutationRate = 0.15; % probability
        terminateLimit = 5;
        numGeneLimit = 200;
        generationLimit = 500;
    end
    
    methods
        % Constructor
        function obj = GA(amount, callBack, ubx, lbx, uby, lby)
            % Init data
            obj.upperBoundX = ubx;
            obj.lowerBoundX = lbx;
            obj.upperBoundY = uby;
            obj.lowerBoundY = lby;
            
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
                gene = Gene(x, y, obj.upperBoundX, obj.lowerBoundX, obj.upperBoundY, obj.lowerBoundY);
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
        
        function index = shooting(~, scoresPrefixSum)
            [~, right] = size(scoresPrefixSum);
            left = 1;
            sum = scoresPrefixSum(right);
            hit = rand * sum;
            
            % Binary search
            while (left <= right)
                mid = floor((left + right) / 2);
                % fprintf('left: %d, right: %d, mid: %d\n', left, right, mid);
                % fprintf('mid value: %f\n', scoresPrefixSum(mid));
                if (scoresPrefixSum(mid) < hit)
                    left = mid + 1;
                elseif (scoresPrefixSum(mid) > hit)
                    right = mid - 1;
                else
                    left = mid;
                    break;
                end
            end
            index = left;
            % fprintf('hit: %f sum: %f\n', hit, sum);
        end
        
        % Select the gene to survived
        function selected = select(obj, originalGenes, sortedScores, amount)
            % map = containers.Map('KeyType', 'int32', 'ValueType', 'int32');
            [~, n] = size(sortedScores);
            selected = Gene.empty(n, 0);
            scorePrefixSum = zeros(1, n);
            sum = 0;
            
            % Build the prefix sum
            for i = 1 : n
                sum = sum + sortedScores(i);
                scorePrefixSum(i) = sum;
            end
            
            for i = 1 : amount
                % Shoot to find a gene, and delete the found gene from the
                % original Gene array
                index = obj.shooting(scorePrefixSum);
                selected(i) = originalGenes(index);
                scorePrefixSum(index) = [];
                originalGenes(index) = [];
            end
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
        
        function grade = normalization(~, sortedScore)
            [~, n] = size(sortedScore);
            bias = sortedScore(1) + 1;
            grade = zeros(1, n);
            for i = 1 : n
                grade(i) = bias - sortedScore(i);
            end
        end
        
        % Public methods
        % Always call this function to setup your parameter before fitting
        % the objective function
        function obj = setParameters(obj, survived, crossover, mutation)
            obj.survived = survived;
            obj.crossoverRate = crossover;
            obj.mutationRate = mutation;
        end
        
        % Call this function to start fitting
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
                [grade, I] = sort(grade, 'descend');
                obj.genes = obj.genes(I);

                % Select the survived gene
                if (n > obj.numGeneLimit)
                    normalized = obj.normalization(grade);
                    obj.genes = obj.select(obj.genes, normalized, obj.numGeneLimit);
                end

                % Cross over
                [~, n] = size(obj.genes);
                if (mod(n, 2) ~= 0)
                    n = n - 1;
                end
                child = [];
                for i = 1 : 2 : n
                    if (rand < obj.crossoverRate)
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
                meanValue = mean(grade);
                graphY(generation + 1) = meanValue;
                if (score == previousScore)
                    terminalCounter = terminalCounter + 1;
                else
                    terminalCounter = 0;
                end
                
                % Ouput the generation
                fprintf('-----------------------------------\n');
                fprintf('generation: %d\n', generation);
                fprintf('Best Scord: %f\n', score);
                fprintf('Mean: %f\n', meanValue);
                fprintf('Terminal difference: %f\n', score - previousScore);
                fprintf('Terminal Count: %f\n', terminalCounter);
                fprintf('Best Gene: x = %f, y = %f, valid = %d\n', obj.genes(i).valueX, obj.genes(i).valueY, obj.genes(i).isValid);
                fprintf('-----------------------------------\n\n');
            end
            
            plot(graphX, graphY);
        end
    end
end