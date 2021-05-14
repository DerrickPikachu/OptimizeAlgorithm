classdef PrideOfLion
    %PRIDEOFLION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        male
        female
        cubs
        lowerBound
        upperBound
        % call back function
        fitnessFunc
    end
    
    properties (Constant)
        crossoverCubs = 4
        mutationCubs = 4
        yearOfMature = 3
        mutationRange = 1
    end
    
    methods
        function obj = PrideOfLion(male, female, lowest, highest, fitness)
            % Init the male and female of prode
            obj.male = male;
            obj.female = female;
            obj.fitnessFunc = fitness;
            obj.lowerBound = lowest;
            obj.upperBound = highest;
            obj.cubs = Lion.empty(0, obj.crossoverCubs + obj.mutationCubs);
        end
        
        function obj = crossover(obj)
            % Let the male and female crossover and bron cubs
            % Before coressover, kill the previous generation first
            
            %mean = (obj.male.value + obj.female.value) / 2;
            %range = mean * 2;
            
            % Bron new cubs
            for i = 1 : obj.crossoverCubs
                %sample = rand * range - mean;
                %newValue = obj.getStrongest() + sample;
                crossPercent = rand;
                newValue = obj.male.value * crossPercent + obj.female.value * (1 - crossPercent);
                obj.cubs(i) = Lion(newValue, obj.fitnessFunc);
            end
        end
        
        function obj = mutation(obj)
            range = ((obj.upperBound - obj.lowerBound) / 2) * obj.mutationRange;
            bias = range / 2;
            
            %fprintf('range: %f', mutationRange);
            %fprintf('bias: %f', bias);
            
            for i = 1 : obj.crossoverCubs
                % Get the mutation rand number
                randNum = rand * range - bias;
                newVal = obj.cubs(i).value + randNum;
                
                %fprintf('orginal: %f\n', obj.cubs(i).value);
                %fprintf('randNum: %f\n', randNum);
                %fprintf('newVal: %f\n', newVal);
                
                % Limit Check
                if newVal > obj.upperBound
                    newVal = obj.upperBound;
                elseif newVal < obj.lowerBound
                    newVal = obj.lowerBound;
                end
                
                % Bron new cubs
                obj.cubs(obj.crossoverCubs + i) = Lion(newVal, @evaluateFunc);
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
            obj = obj.crossover();
            obj = obj.mutation();
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

