function value = targetFunction(x, y)
    value = sin(x + y)  + (x - y).^2 - 1.5 * x + 2.5 * y + 1;
end

