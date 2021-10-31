%% fc_lib_calcnum_ElimGauss 
%%%%%%%%%%%%% 
% help fc_lib_calcnum_ElimGauss 
% Belongs to private library 
%%%%%%%%%%%%% 
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC) 
% COPYRIGHT: Free for non evil use. (Não use este código para o mal) 
%%%%%%%%%%%%% 
% fc_lib_calcnum_ElimGauss(A,b) 
% Funcao para calcular um sistema de equacoes algebricas por meio 
% do metodo de eliminacao de Gauss 
% A: matriz de coeficientes 
% b: vetor de constantes 
% Ax = b 
%%%%%%%%%%%%% 
% version 01: 04.04.2018 - Creation 
%             25.03.2018 - New examples; change of z to x 
%%%%%%%%%%%%% Example 01 
% A = [1 2; 2 -2]; 
% b = [1; 5]; 
% x = fc_lib_calcnum_ElimGauss(A,b) 
%%%%%%%%%%%%% Example 02 
% A = randi(10,3,3); 
% b = randi(10,3,1); 
% x = fc_lib_calcnum_ElimGauss(A,b) 
%%%%%%%%%%%%% 
%% algorithm 
function x = fc_lib_calcnum_ElimGauss(A,b) 
M = [A b]; 
[L, C] = size(M); 
for i = 1:L-1 
    for j = i+1:L 
        m = M(j,i)/M(i,i); 
        M(j,:) = M(j,:) - m*M(i,:); 
        %M(j,j+1:L+1) = M(j,j+1:L+1) - m*M(i,j+1:L+1); 
    end 
end 
x = zeros(L,1); 
x(L) = M(L,C)/M(L,L); 
for j=L-1:-1:1 
    x(j) = (M(j,C) - M(j,j+1:L) * x(j+1:L))/M(j,j); 
end 
end