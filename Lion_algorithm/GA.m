classdef GA
    
    properties
        boundary
        genes
        dimension
        evaluateFunc
    end
    
    properties(Constant)
        initGenes = 10
        maxGene = 100
        maxIter = 500
        crossoverRate = 0.90
        mutationRate = 0.15
        surviveRate = 0.80
    end
    
    methods
        function obj = GA(boundary, dimension, evaluateFunc)
            % Init data
            obj.boundary = boundary;
            obj.dimension = dimension;
            obj.evaluateFunc = evaluateFunc;
            
            % Randomly generate genes
            obj.genes = Gene.empty(0, obj.initGenes);
            for i = 1 : obj.initGenes
                valueSet = zeros(1, obj.dimension);
                for j = 1 : obj.dimension
                    range = boundary(j, 2) - boundary(j, 1);
                    valueSet(j) = rand * range + boundary(j, 1);
                end
                obj.genes(i) = Gene(valueSet, obj.boundary, evaluateFunc);
            end
        end
        
        function index = shoot(obj, prefixSum)
            left = 1;
            [~, right] = size(prefixSum);
            hit = rand * prefixSum(right);
            
            % Binary Search
            while (left <= right)
                mid = floor((left + right) / 2);
                if (prefixSum(mid) > hit)
                    right = mid - 1;
                elseif (prefixSum(mid) < hit)
                    left = mid + 1;
                else
                    left = mid;
                    break;
                end
            end
            
            index = left;
        end
        
        function obj = sortGene(obj)
            [~, len] = size(obj.genes);
            fitnessArr = zeros(1, len);
            
            % Save the temporary fitness array
            for i = 1 : len
                fitnessArr(i) = obj.genes(i).fitness;
            end
            
            % Sort temporary fitness array first, then use this order for
            % the genes array
            [~, I] = sort(fitnessArr, 'descend');
            obj.genes = obj.genes(I);
        end
        
        function obj = survive(obj)
            sum = 0;
            [~, len] = size(obj.genes);
            prefixSum = zeros(1, len);
            fitnessArr = zeros(1, len);
            
            for i = 1 : len
                fitnessArr(i) = obj.genes(len - i + 1).fitness;
            end
            
            % Calculate the prefix sum array (by fitness)
            for i = 1 : len
                sum = sum + fitnessArr(i);
                prefixSum(i) = sum;
            end
            
            
            % Calculate the survived genes, and init the survived gene
            % array
            % survived = floor(len * obj.surviveRate);
            survived = obj.maxGene;
            survivedGene = Gene.empty(0, survived);
            
            % Shoot and decide the survived gene
            for i = 1 : survived
                index = obj.shoot(prefixSum);
                survivedGene(i) = obj.genes(index);
                prefixSum(index) = [];
                obj.genes(index) = [];
            end
            
            obj.genes = survivedGene;
        end
        
        function obj = crossover(obj)
            [~, len] = size(obj.genes);
            obj.genes = obj.genes(randperm(len));
            
            % Crossover each two gene
            for i = 1 : floor(len / 2)
                cur = 2 * (i - 1) + 1;
                
                % When the probability hit, do crossover
                if (rand <= obj.crossoverRate)
                    switchLen = floor(obj.genes(cur).geneLength / 2);
                    gene1 = obj.genes(cur).geneStr;
                    gene2 = obj.genes(cur + 1).geneStr;
                    newStr1 = '';
                    newStr2 = '';
                    
                    % For each coordinate value, do gene switch
                    for j = 1 : obj.dimension
                        geneLen = obj.genes(cur).geneLength;
                        front = (j - 1) * geneLen + 1;
                        back = j * geneLen;
                        temStr1 = gene1(front : back);
                        temStr2 = gene2(front : back);
                        
                        childStr1 = append(temStr1(1 : geneLen - switchLen), temStr2(geneLen - switchLen + 1 : geneLen));
                        childStr2 = append(temStr2(1 : geneLen - switchLen), temStr1(geneLen - switchLen + 1 : geneLen));
                        % childStr1 = append(temStr1(1 : geneLen - switchLen), temStr2(1 : geneLen - switchLen));
                        % childStr2 = append(temStr1(geneLen - switchLen + 1 : geneLen), temStr2(geneLen - switchLen + 1 : geneLen));
                        
                        newStr1 = append(newStr1, childStr1);
                        newStr2 = append(newStr2, childStr2);
                    end
                    
                    % Generate new child gene
                    newGene1 = Gene(zeros(1, obj.dimension), obj.boundary, obj.evaluateFunc);
                    newGene2 = Gene(zeros(1, obj.dimension), obj.boundary, obj.evaluateFunc);
                    newGene1 = newGene1.decode(newStr1);
                    newGene2 = newGene2.decode(newStr2);
                    
                    % Add this two gene into the gene sequence
                    obj.genes = [obj.genes, newGene1, newGene2];
                end
            end
        end
        
        function obj = mutation(obj)
            [~, len] = size(obj.genes);
            
            for i = 1 : len
                if rand <= obj.mutationRate
                    geneLen = obj.genes(i).geneLength * obj.dimension;
                    choosed = ceil(rand * geneLen);
                    gene = obj.genes(i).geneStr;
                    if gene(choosed) == '1'
                        gene(choosed) = '0';
                    else
                        gene(choosed) = '1';
                    end
                    obj.genes(i) = obj.genes(i).decode(gene);
                end
            end
        end
        
        function obj = showCurrent(obj)
            [~, len] = size(obj.genes);
            sum = 0;
            best = obj.genes(1).fitness;
            
            for i = 1 : len
                sum = sum + obj.genes(i).fitness;
                if best > obj.genes(i).fitness
                    best = obj.genes(i).fitness;
                end
            end
            
            mean = sum / len;
            fprintf('mean: %f\n', mean);
            fprintf('best: %f\n', best);
            fprintf('------------------------------\n');
        end
        
        function show(obj)
            [~, len] = size(obj.genes);
            for i = 1 : len
                fprintf('%f %f\n', obj.genes(i).position(1), obj.genes(i).position(2));
            end
        end
        
        function obj = fit(obj)
            for gen = 1 : obj.maxIter
                obj = obj.crossover();
                obj = obj.mutation();
                [~, len] = size(obj.genes);
                if len > obj.maxGene
                    obj = obj.sortGene();
                    obj = obj.survive();
                end
                fprintf('generation: %d\n', gen);
                obj = obj.showCurrent();
            end
        end
    end
end

