%% fc_lib_calcnum_Interpolacao_Lagrange 
%%%%%%%%%%%%% 
% help fc_lib_calcnum_Interpolacao_Lagrange 
% Belongs to private library 
%%%%%%%%%%%%% 
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC) 
% COPYRIGHT: Free for non evil use. (Não use este código para o mal) 
%%%%%%%%%%%%% 
% fc_lib_calcnum_Interpolacao_Lagrange(X,f) 
%%%%%%%%%%%%% 
% version 01: 04.04.2018 
%     Criação 
%%%%%%%%%%%%% Example 
% x = [0 1 2 3 4 5]; 
% y = [1.0000    0.3679    0.0183    0.0001    0.0000    0.0000]; 
% Xint = [0 1 2 3 4 5]; 
% I = fc_lib_calcnum_Interpolacao_Lagrange(x,y,Xint) 
%%%%%%%%%%%%% 
%% algorithm 
function Yint = fc_lib_calcnum_Interpolacao_Lagrange(x,y,Xint) 
% O comprimento do vetor x fornece o número de termos do polinômio 
n = length(x); 
for i = 1:n 
    %Calcula os termos Li do produtório 
    L(i) = 1; 
    for j = 1:n 
        if j ~= i 
            L(i) = L(i)*(Xint-x(j))/(x(i)-x(j)); 
        end 
    end 
end 
%Calcula o valor do polinômio da Eq. (16) 
Yint = y*(L'); 
end