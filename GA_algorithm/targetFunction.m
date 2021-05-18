function value = targetFunction(x, y)
    %value = sin(x + y)  + (x - y).^2 - (1.5 * x) + (2.5 * y) + 1;
    value = (x^2 + y^2)/4000 - cos(x) * cos(y / sqrt(2)) + 1;
    %value = 20 + x^2 + y^2 - 10 * (cos(2 * pi * x) + cos(2 * pi * y));
end

