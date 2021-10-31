%% fc_lib_calcnum_Integral_Simpson_Xf_vetor 
%%%%%%%%%%%%% 
% help fc_lib_calcnum_Integral_Simpson_Xf_vetor 
% Belongs to private library 
%%%%%%%%%%%%% 
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC) 
% COPYRIGHT: Free for non evil use. (Não use este código para o mal) 
%%%%%%%%%%%%% 
% fc_lib_calcnum_Integral_Simpson_Xf_vetor(X,f) 
%%%%%%%%%%%%% 
%X : vetor com os pts da abscissas; 
%f : função f(X) dos resultados ou pts experimentais; 
%%%%%%%%%%%%% 
% version 01: 15.05.2019 -- Creation 
%   Based on: fc_lib_calcnum_Integral_Simpson_Xf_vetor 
%%%%%%%%%%%%% Example 
% X = [0 1 2 3 4 5 6]; 
% f = inline('exp(-x.^2)'); 
% [XI, I] = fc_lib_calcnum_Integral_Simpson_Xf_vetor(X,f); 
% fprintf('%g\n',sum(I)); 
% x0 = 0; plot (X,f(X),'r', XI,I,'b', [X(1), XI],cumsum([x0; I]),'m'); grid on; 
%%%%%%%%%%%%% 
%% algorithm 
function [XI, I] = fc_lib_calcnum_Integral_Simpson_Xf_vetor(X,f) 
Y = f(X); n = length(X)-1; 
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
end 
%% old implementation 
%for i = 1:((n)/2) 
%    I = I + ( ((X(2*i)-X(2*i-1)))/3 * (Y(2*i-1) + 4*Y(2*i) + Y(2*i+1)) ); 
%end