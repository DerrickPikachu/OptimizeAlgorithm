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
            
            % Bron new cubs
            for i = 1 : obj.crossoverCubs
                crossPercent = rand;
                newValue = obj.male.value * crossPercent + obj.female.value * (1 - crossPercent);
                obj.cubs(i) = Lion(newValue, obj.fitnessFunc);
            end
        end
        
        function obj = mutation(obj)
            mutationRange = (obj.upperBound - obj.lowerBound) / 2;
            bias = mutationRange / 2;
            
            %fprintf('range: %f', mutationRange);
            %fprintf('bias: %f', bias);
            
            for i = 1 : obj.crossoverCubs
                % Get the mutation rand number
                randNum = rand * mutationRange - bias;
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
        
        function obj = classify(obj)
            [~, numOfCubs] = size(obj.cubs);
            
            % Linear probing
            for i = 1 : numOfCubs / 2
                choosen = int32(ceil(rand * numOfCubs));
                while obj.cubs(choosen).gender == 0
                    choosen = mod(choosen + 1, numOfCubs);
                end
                obj.cubs(choosen).gender = 0;
            end
        end
    end
end

