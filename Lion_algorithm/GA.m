classdef GA
    
    properties
        boundary
        genes
        dimension
    end
    
    properties(Constant)
        initGenes = 10
        maxGene = 200;
        maxIter = 500
        crossoverRate = 0.90;
        mutationRate = 0.10;
        surviveRate = 0.80;
    end
    
    methods
        function obj = GA(boundary, dimension, evaluateFunc)
            % Init data
            obj.boundary = boundary;
            obj.dimension = dimension;
            
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
        
        function obj = survive(obj)
            sum = 0;
            [~, len] = size(obj.genes);
            prefixSum = zeros(1, len);
            
            % Calculate the prefix sum array (by fitness)
            for i = 1 : len
                sum = sum + obj.genes(i).fitness;
                prefixSum(i) = sum;
            end
            
            % Calculate the survived genes, and init the survived gene
            % array
            survived = floor(len * obj.surviveRate);
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
            
        end
        
        function obj = fit(obj)
            for gen = 1 : obj.maxIter
                obj = obj.crossover();
            end
        end
    end
end

