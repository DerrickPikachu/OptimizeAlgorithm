classdef Whale
    
    properties
        position
        boundary
        fitness
        dimension
        
        % Fitness function is used to evaluate the fitness value
        fitnessFunction
    end
    
    methods
        function obj = Whale(pos, boundary, func)
            obj.position = pos;
            obj.boundary = boundary;
            obj.fitnessFunction = func;
            obj.dimension = length(pos);
            
            % Limit every dimension value be in the boundary
            obj = obj.boundaryFit();
            obj.fitness = obj.fitnessFunction(obj.position);
        end
        
        function obj = boundaryFit(obj)
            % Check every diemnstion fit it's boundary
            for i = 1 : obj.dimension
                % Boundary first element is the lower bound, second element
                % is the upper bound
                if obj.position(i) < obj.boundary(i, 1)
                    obj.position(i) = obj.boundary(i, 1);
                elseif obj.position(i) > obj.boundary(i, 2)
                    obj.position(i) = obj.boundary(i, 2);
                end
            end
        end
    end
end
