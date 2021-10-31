%% fc_lib_calcnum_Integral_Simpson_XY_vetor 
%%%%%%%%%%%%% 
% help fc_lib_calcnum_Integral_Simpson_XY_vetor 
% Belongs to private library 
%%%%%%%%%%%%% 
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC) 
% COPYRIGHT: Free for non evil use. (Não use este código para o mal) 
%%%%%%%%%%%%% 
% fc_lib_calcnum_Integral_Simpson_XY_vetor(X,Y) 
%%%%%%%%%%%%% 
%X : vetor com os pts da abscissas; 
%Y : vetor com os resultados de f(X) ou pts experimentais; 
%%%%%%%%%%%%% 
% version 01: 15.05.2019 -- Creation 
%   Based on: fc_lib_calcnum_Integral_Simpson_XY 
%%%%%%%%%%%%% Example 
% X = [0 1 2 3 4 5 6]; 
% Y = [1.0000    0.3679    0.0183    0.0001    0 0 0]; 
% [XI, I] = fc_lib_calcnum_Integral_Simpson_XY_vetor(X,Y); 
% fprintf('%g\n',sum(I)); plot (X,Y,'r', XI,I,'b', XI,cumsum(I),'m'); grid on; 
%%%%%%%%%%%%% 
%% algorithm 
function [XI, I] = fc_lib_calcnum_Integral_Simpson_XY_vetor(X,Y) 
n = length(X)-1; m = length(Y); 
if (n+1) == m 
    if mod(n,2) == 0 
        I = zeros(n/2,1); 
        for i = 2:2:n 
            I(i/2) = ( ((X(i)-X(i-1)))/3 * (Y(i-1) + 4*Y(i) + Y(i+1)) ); 
        end 
        XI = X(2:2:n); 
    else 
        XI = 0; I = 0; 
        fprintf('# pts do intervalo deve ser ímpar'); 
    end 
else 
    XI = 0; I = 0; 
    fprintf('Vetores com tamanhos diferentes'); 
end 
end 
%% old implementation 
%for i = 1:((n)/2) 
%    I = I + ( ((X(2*i)-X(2*i-1)))/3 * (Y(2*i-1) + 4*Y(2*i) + Y(2*i+1)) ); 
%end