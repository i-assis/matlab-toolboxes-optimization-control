%% fc_lib_calcnum_Integral_Trapezios_Xf 
%%%%%%%%%%%%% 
% help fc_lib_calcnum_Integral_Trapezios_Xf 
% Belongs to private library 
%%%%%%%%%%%%% 
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC) 
% COPYRIGHT: Free for non evil use. (Não use este código para o mal) 
%%%%%%%%%%%%% 
% fc_lib_calcnum_Integral_Trapezios_Xf(X,f) 
%%%%%%%%%%%%% 
% version 01: 04.04.2018 -- Creation 
%%%%%%%%%%%%% Example 
% X = [0 1 2 3 4 5]; 
% f = inline('exp(-x.^2)'); 
% I = fc_lib_calcnum_Integral_Trapezios_Xf(X,f) 
% plot (X,Y,'r'); grid; 
%%%%%%%%%%%%% 
%% algorithm 
function I = fc_lib_calcnum_Integral_Trapezios_Xf(X,f) 
Y = f(X); n = length(X); I = 0; 
for i = 2:n 
    I = I + ( (X(i) - X(i-1))/2 ) * ( Y(i) + Y(i-1) ); 
end 
end