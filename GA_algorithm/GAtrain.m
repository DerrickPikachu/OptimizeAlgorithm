ubx = 4;
lbx = -1.5;
uby = 3;
lby = -3;


myGA = GA(10, @targetFunction, ubx, lbx, uby, lby);
myGA.fit();

