lionAl = LionAlgo(-600, 600, @evaluateFunc);
lionAl = lionAl.fit();

boundary = [-600, 600; -600, 600];
ga = GA(boundary, 2, @evaluateFunc);
ga = ga.fit();

x = 1 : lionAl.maxIter;
tiledlayout(2, 1)

nexttile
plot(x, lionAl.meanArray, x, ga.meanArray);
title('mean');

nexttile
plot(x, lionAl.bestArray, x, ga.bestArray);
title('best');