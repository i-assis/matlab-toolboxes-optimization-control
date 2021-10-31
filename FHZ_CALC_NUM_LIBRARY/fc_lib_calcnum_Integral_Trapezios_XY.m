%% fc_lib_calcnum_Integral_Trapezios_XY 
%%%%%%%%%%%%% 
% help fc_lib_calcnum_Integral_Trapezios_XY 
% Belongs to private library 
%%%%%%%%%%%%% 
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC) 
% COPYRIGHT: Free for non evil use. (Não use este código para o mal) 
%%%%%%%%%%%%% 
% fc_lib_calcnum_Integral_Trapezios_XY(X,f) 
%%%%%%%%%%%%% 
%X : vetor com os pts da abscissas; 
%Y : vetor com os resultados de f(X) ou pts experimentais; 
%%%%%%%%%%%%% 
% version 01: 15.05.2019 -- Creation 
%   Based on: fc_lib_calcnum_Integral_Trapezios_Xf 
%%%%%%%%%%%%% Example 
% X = [0 1 2 3 4 5]; 
% Y = [1.0000    0.3679    0.0183    0.0001     0 0 ]; 
% I = fc_lib_calcnum_Integral_Trapezios_XY(X,Y) 
% plot (X,Y,'r'); grid; 
%%%%%%%%%%%%% 
%% algorithm 
function I = fc_lib_calcnum_Integral_Trapezios_XY(X,Y) 
n = length(X); I = 0; 
for i = 2:n 
    I = I + ( (X(i) - X(i-1))/2 ) * ( Y(i) + Y(i-1) ); 
end 
end