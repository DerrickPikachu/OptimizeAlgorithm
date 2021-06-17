classdef WhaleOptimize
    
    properties
        Property1
    end
    
    properties(Constant)
        numOfWhale = 10
        maxIter = 100
        
    end
    
    methods
        function obj = WhaleOptimize(inputArg1,inputArg2)
            %WHALEOPTIMIZE Construct an instance of this class
            %   Detailed explanation goes here
            obj.Property1 = inputArg1 + inputArg2;
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

