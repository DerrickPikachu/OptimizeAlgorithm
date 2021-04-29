classdef PrideOfLion
    %PRIDEOFLION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        male
        female
        cubs
        % call back function
        fitnessFunc
    end
    
    properties (Constant)
        numOfCubs = 4
    end
    
    methods
        function obj = PrideOfLion(male, female, fitness)
            % Init the male and female of prode
            obj.male = male;
            obj.female = female;
            obj.fitnessFunc = fitness;
            obj.cubs = Lion.empty(0, obj.numOfCubs);
        end
        
        function obj = crossover(obj)
            % Let the male and female crossover and bron cubs
            % Before coressover, kill the previous generation first
            
            % Bron new cubs
            for i = 1 : obj.numOfCubs
                crossPercent = rand;
                newValue = obj.male.value * crossPercent + obj.female.value * (1 - crossPercent);
                obj.cubs(i) = Lion(newValue, obj.fitnessFunc);
            end
        end
    end
end

