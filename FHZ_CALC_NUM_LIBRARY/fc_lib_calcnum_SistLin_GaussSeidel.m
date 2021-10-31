%% fc_lib_calcnum_SistLin_GaussSeidel 
%%%%%%%%%%%%% 
% help fc_lib_calcnum_SistLin_GaussSeidel 
% Belongs to private library 
%%%%%%%%%%%%% 
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC) 
% COPYRIGHT: Free for non evil use. (Não use este código para o mal) 
%%%%%%%%%%%%% 
% fc_lib_calcnum_SistLin_GaussSeidel(A,B,i_max) 
% Funcao para a solucao de um sistema de equacoes algebricas 
% por meio do metodo de Gauss Seidel 
% A: matriz de coeficientes 
% b: vetor de constantes 
% i_max: máximo de iterações 
%%%%%%%%%%%%% 
% version 01: 18.07.2018 -- Creation
%%%%%%%%%%%%% Example 
% A = randi(10,3,3); 
% B = randi(10,3,1); % B = randi(10,3,3); 
% imax = 10; 
% x = fc_lib_calcnum_SistLin_GaussSeidel(A,B,i_max) 
%%%%%%%%%%%%% 
%% algorithm 
function x = fc_lib_calcnum_SistLin_GaussSeidel(A,B,i_max) 
[L, C] = size(A); 
x0 = zeros(L,1); 
x = zeros(L,1); 
M = A - diag(diag(A)); 
d = (diag(A)).^(-1); 
for i = 1:i_max 
    for j = 1:C 
        x(j) = d(j)*(B(j) - M(j,:)*x0); 
        x0(j) = x(j); 
    end 
    x0 = x; 
end 
end