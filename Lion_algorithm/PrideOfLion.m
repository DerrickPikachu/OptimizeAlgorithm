classdef PrideOfLion
    %PRIDEOFLION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        male
        female
        cubs
        %lowerBound
        %upperBound
        boundary
        dimension
        % call back function
        fitnessFunc
    end
    
    properties (Constant)
        crossoverCubs = 4
        mutationCubs = 4
        yearOfMature = 7
        mutationRange = 1
    end
    
    methods
        function obj = PrideOfLion(male, female, boundary, dimension, fitness)
            % Init the male and female of prode
            obj.male = male;
            obj.female = female;
            obj.fitnessFunc = fitness;
            obj.boundary = boundary;
            obj.dimension = dimension;
            obj.cubs = Lion.empty(0, obj.crossoverCubs + obj.mutationCubs);
        end
        
        function obj = crossover(obj)
            % Let the male and female crossover and bron cubs
            % Before coressover, kill the previous generation first
            
            % Bron new cubs
            for i = 1 : obj.crossoverCubs
                newPos = [0, 0];
                for j = 1 : obj.dimension
                    % mean = (obj.male.position(j) + obj.female.position(j)) / 2;
                    range = abs(obj.male.position(j) - obj.female.position(j)) * 3;
                    sample = rand* range - range / 2;
                    newPos(j) = obj.getStrongest() + sample;
                end
                obj.cubs(i) = Lion(newPos, obj.boundary, obj.fitnessFunc);
            end
        end
        
        function obj = crossoverBin(obj)
            for i = 1 : obj.crossoverCubs / 2
                geneLen = obj.male.geneLength;
                newStr1 = '';
                newStr2 = '';
                maleStr = obj.male.geneStr;
                femaleStr = obj.female.geneStr;
                
                for j = 1 : obj.dimension
                    base = (j - 1) * geneLen;
                    switchLen = ceil(rand * floor(geneLen * 3 / 4));
                    %fprintf('choosed bit: %d\n', switchLen);
                    
                    maleSection = maleStr(base + 1 : base + geneLen);
                    femaleSection = femaleStr(base + 1 : base + geneLen);
                    
                    newSection1 = append(maleSection(1 : switchLen), femaleSection(switchLen + 1 : geneLen));
                    newSection2 = append(femaleSection(1 : switchLen), maleSection(switchLen + 1 : geneLen));
                    
                    newStr1 = append(newStr1, newSection1);
                    newStr2 = append(newStr2, newSection2);
                end
                
                newLion1 = Lion([0, 0], obj.boundary, @evaluateFunc);
                newLion2 = newLion1.decode(newStr2);
                newLion1 = newLion1.decode(newStr1);
                
                obj.cubs = [obj.cubs, newLion1, newLion2];
            end
        end
        
        function obj = mutation(obj)
            for i = 1 : obj.crossoverCubs
                % Get the mutation rand number
                newPos = zeros(1, obj.dimension);
                for j = 1 : obj.dimension
                    range = ((obj.boundary(j, 2) - obj.boundary(j, 1)) / 2) * obj.mutationRange;
                    bias = range / 2;
                    randNum = rand * range - bias;
                    newPos(j) = obj.cubs(i).position(j) + randNum;

                    % Limit Check
                    if newPos(j) > obj.boundary(j, 2)
                        newPos(j) = obj.boundary(j, 2);
                    elseif newPos(j) < obj.boundary(j, 1)
                        newPos(j) = obj.boundary(j, 1);
                    end
                end
                
                % Bron new cubs
                obj.cubs(obj.crossoverCubs + i) = Lion(newPos, obj.boundary, @evaluateFunc);
            end
        end
        
        function obj = mutationBin(obj)
            for i = 1 : obj.crossoverCubs
                gene = obj.cubs(i).geneStr;
                choosedBit = ceil(rand * obj.male.geneLength * obj.dimension);
                %fprintf('choosed: %d\n', choosedBit);
                %fprintf('%s\n', gene);
                
                if gene(choosedBit) == '1'
                    gene(choosedBit) = '0';
                else
                    gene(choosedBit) = '1';
                end
                %fprintf('%s\n', gene);
                
                cub = Lion([0, 0], obj.boundary, @evaluateFunc);
                cub = cub.decode(gene);
                
                obj.cubs(obj.crossoverCubs + i) = cub;
            end
        end
        
        function obj = nextTimeStep(obj)
            [~, n] = size(obj.cubs);
            if ~isempty(obj.cubs)
                for i = 1 : n
                    obj.cubs(i) = obj.cubs(i).growUp();
                end
            end
        end
        
        function obj = classify(obj)
            [~, numOfCubs] = size(obj.cubs);
            
            % Linear probing
            for i = 1 : numOfCubs / 2
                choosen = int32(ceil(rand * numOfCubs));
                while obj.cubs(choosen).gender == 0
                    choosen = mod(choosen + 1, numOfCubs) + 1;
                end
                obj.cubs(choosen).gender = 0;
            end
        end
        
        function obj = reproduce(obj)
%             obj = obj.crossover();
%             obj = obj.mutation();
            obj = obj.crossoverBin();
            obj = obj.mutationBin();
            obj = obj.classify();
        end
        
        function prideFitness = prideHealthy(obj)
            % Calculate the healthy of the pride
            % Use the formula provided by the paper
            [~, n] = size(obj.cubs);
            maleCubs = n / 2;
            cubsValueSum = 0;
            currentAge = obj.cubs(1).age;
            
            for i = 1 : n
                cubsValueSum = cubsValueSum + obj.cubs(i).fitness;
            end
            fitnessOfCubs = (obj.yearOfMature / (currentAge + 1)) * (cubsValueSum / maleCubs);
            
            totalFitness = obj.male.fitness + obj.female.fitness + fitnessOfCubs;
            prideFitness = totalFitness / (2 * (1 + maleCubs));
        end
        
        function isWin = fightNomad(obj, nomad)
            % Fight with the nomad, and identify who is the winner
            %fprintf('male: %f\n', obj.male.fitness);
            %fprintf('pride healthy: %f\n', obj.prideHealthy());
            %fprintf('nomad: %f\n', nomad.fitness);
            isWin = ~(obj.male.fitness > nomad.fitness && obj.prideHealthy() > nomad.fitness); 
        end
        
        function obj = occupied(obj, nomad)
            % After calling fightNomad function and confirm the pride is
            % lose, then use this function to occupied the pride
            obj.male = nomad;
            obj.cubs = Lion.empty(0, 2 * obj.crossoverCubs);
        end
        
        function obj = takeOver(obj)
            % When the cubs grow up, They will try to take over the pride
            if ~isempty(obj.cubs)
                if obj.cubs(1).age >= obj.yearOfMature
                    [~, n] = size(obj.cubs);
                    for i = 1 : n
                        if obj.cubs(i).gender == 1 && obj.cubs(i).fitness < obj.male.fitness
                            obj.male = obj.cubs(i);
                        elseif obj.cubs(i).gender == 0 && obj.cubs(i).fitness < obj.female.fitness
                            obj.female = obj.cubs(i);
                        end
                    end
                    obj.cubs = Lion.empty(0, 2 * obj.crossoverCubs);
                end
            end
        end
        
        function bestValue = getStrongest(obj)
            if obj.male.fitness < obj.female.fitness
                bestValue = obj.male.fitness;
            else
                bestValue = obj.female.fitness;
            end
        end
    end
end

