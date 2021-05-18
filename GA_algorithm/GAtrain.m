% Boundary of x and y
ubx = 600;
lbx = -600;
uby = 600;
lby = -600;
%ubx = 4;
%lbx = -1.5;
%uby = 3;
%lby = -3;

% Setup some parameters of GA
survived = 0.80;
crossover = 0.90;
mutation = 0.02;

myGA = GA(10, @targetFunction, ubx, lbx, uby, lby);
myGA = myGA.setParameters(survived, crossover, mutation);
myGA.fit();

