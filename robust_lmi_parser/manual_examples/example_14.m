clear;

A1 = [1 0; 2 -1];
A2 = [-3 4; 2 3];
A3 = [0 1; -2 4];

A{1} = {[2 0],A1};
A{2} = {[1 1],A2};
A{3} = {[0 2],A3};
poly = rolmipvar(A,'A',2,2);

var = evalpar(poly,{[0.3 0.7]})
