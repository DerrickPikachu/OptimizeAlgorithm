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
        
        function obj = encircleUpdate(obj, bestWhale, a)
           for i = 1 : obj.dimension
               best = bestWhale.position(i);
               A = 2 * a * rand - a;
               fprintf("%f\n", A);
               C = 2 * rand;
               fprintf("%f\n", C);
               obj.position(i) = best - A * abs(C * best - obj.position(i));
           end
           
           obj.fitness = obj.fitnessFunction(obj.position);
        end
        
        function obj = spiralUpdate(obj, bestWhale, b)
            for i = 1 : obj.dimension
                best = bestWhale.position(i);
                D = abs(best - obj.position(i));
                l = rand;
                obj.position(i) = D * exp(b * l) * cos(2 * pi * l) + best;
            end
            
            obj.fitness = obj.fitnessFunction(obj.position);
        end
    end
end

