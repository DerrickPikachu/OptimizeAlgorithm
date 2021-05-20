function val = evaluateFunc(position)
    x = position(1);
    y = position(2);
    %val = (x^2 + y^2)/4000 - cos(x) * cos(y / sqrt(2)) + 1;
    val = 20 + x^2 + y^2 - 10 * (cos(2 * pi * x) + cos(2 * pi * y));
end

