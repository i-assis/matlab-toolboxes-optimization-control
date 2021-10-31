%% fc_lib_calcnum_Integral_Trapezios_XY_vetor 
%%%%%%%%%%%%% 
% help fc_lib_calcnum_Integral_Trapezios_XY_vetor 
% Belongs to private library 
%%%%%%%%%%%%% 
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC) 
% COPYRIGHT: Free for non evil use. (Não use este código para o mal) 
%%%%%%%%%%%%% 
% fc_lib_calcnum_Integral_Trapezios_XY_vetor(X,f) 
%%%%%%%%%%%%% 
%X : vetor com os pts da abscissas; 
%Y : vetor com os resultados de f(X) ou pts experimentais; 
%%%%%%%%%%%%% 
% version 01: 15.05.2019 -- Creation 
%   Based on: fc_lib_calcnum_Integral_Trapezios_XY 
%%%%%%%%%%%%% Example 
% X = [0 1 2 3 4 5]; 
% Y = [1.0000    0.3679    0.0183    0.0001     0 0 ]; 
% I = fc_lib_calcnum_Integral_Trapezios_XY_vetor(X,Y); 
% fprintf('%g\n',sum(I)); 
% x0 = 0; plot (X,Y,'r', X(2:end),I,'b', X,cumsum([x0;I]),'m'); grid on; 
%%%%%%%%%%%%% 
%% algorithm 
function I = fc_lib_calcnum_Integral_Trapezios_XY_vetor(X,Y) 
n = length(X); I = zeros(n-1,1); 
for i = 2:n 
    I(i-1) = ( (X(i) - X(i-1))/2 ) * ( Y(i) + Y(i-1) ); 
end 
end