%% fc_lib_calcnum_SistLin_Jacobi 
%%%%%%%%%%%%% 
% help fc_lib_calcnum_SistLin_Jacobi 
% Belongs to private library 
%%%%%%%%%%%%% 
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC) 
% COPYRIGHT: Free for non evil use. (Não use este código para o mal) 
%%%%%%%%%%%%% 
% fc_lib_calcnum_SistLin_Jacobi(A,B,i_max) 
% Funcao para a solucao de um sistema de equacoes algebricas 
% por meio do metodo de Jacobi 
% A: matriz de coeficientes 
% b: vetor de constantes 
% i_max: máximo de iterações 
%%%%%%%%%%%%% 
% version 01: 18.07.2018 -- Creation
%%%%%%%%%%%%% Example 
% A = [1 3; 4 6]; 
% B = [0; 1]; 
% imax = 10; 
% x = fc_lib_calcnum_SistLin_Jacobi(A,B,i_max) 
%%%%%%%%%%%%% 
%% algorithm 
function x = fc_lib_calcnum_SistLin_Jacobi(A,B,i_max) 
L= size(A,1); % [L, ~] = size(A); % less eficency 
x0 = zeros(L,1); 
M = A - diag(diag(A)); 
d = (diag(A)).^(-1); 
for i =1:i_max 
    x = (B - M*x0).*d; 
    x0 = x; 
end 
end