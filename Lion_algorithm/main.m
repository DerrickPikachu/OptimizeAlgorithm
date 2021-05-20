boundary = [-600, 600; -600, 600];

tic
lionAl = LionAlgo(boundary, 2, @evaluateFunc);
lionAl = lionAl.fit();
lionTime = toc;

tic
ga = GA(boundary, 2, @evaluateFunc);
ga = ga.fit();
gaTime = toc;

x = 1 : lionAl.maxIter;
tiledlayout(2, 1)

nexttile
plot(x, lionAl.meanArray, x, ga.meanArray);
title('mean');

nexttile
plot(x, lionAl.bestArray, x, ga.bestArray);
title('best');