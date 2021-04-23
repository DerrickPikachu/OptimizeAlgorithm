classdef PrideOfLion
    %PRIDEOFLION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        male
        female
        cubs
    end
    
    methods
        function obj = PrideOfLion(male, female)
            % Init the male and female of prode
            obj.male = male;
            obj.female = female;
        end
        
        function obj = crossover(obj)
            % Let the male and female crossover and bron cubs
            % Before coressover, kill the previous generation first
            obj.cubs = [];
            
            % Bron new cubs
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

