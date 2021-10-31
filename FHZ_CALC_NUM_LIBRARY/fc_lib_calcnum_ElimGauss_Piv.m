%% fc_lib_calcnum_ElimGauss_Piv 
%%%%%%%%%%%%% 
% help fc_lib_calcnum_ElimGauss_Piv 
% Belongs to private library 
%%%%%%%%%%%%% 
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC) 
% COPYRIGHT: Free for non evil use. (Não use este código para o mal) 
%%%%%%%%%%%%% 
% fc_lib_calcnum_ElimGauss_Piv(A,b) 
% Funcao para calcular um sistema de equacoes algebricas por meio 
% do metodo de eliminacao de Gauss com pivotamento 
% A: matriz de coeficientes 
% b: vetor de constantes 
%%%%%%%%%%%%% 
% version 01: 04.04.2018 
%     Criação 
%%%%%%%%%%%%% Example 
% A = randi(10,3,3) 
% b = randi(10,3,1) 
% x = fc_lib_calcnum_ElimGauss_Piv(A,b) 
%%%%%%%%%%%%% 
%% algorithm 
function x = fc_lib_calcnum_ElimGauss_Piv(A,b) 
M = [A b]; 
[L, C] = size(M); 
for i = 1:L-1 
    [el_max, pos_max] = max(abs(A(i,:))); 
    if (abs(el_max)~= 0) 
        M_temp = M(i,:); 
        M(i,:) = M(pos_max,:); 
        M(pos_max,:) = M_temp; 
    else 
        fprintf('Matriz é singular\n'); 
        return; 
    end 
end 
%aqui fica "igual" ao ElimGauss 
for i = 1:L-1 
    for j = i+1:L 
        m = M(j,i)/M(i,i); 
        M(j,:) = M(j,:) - m*M(i,:); 
    end 
end 
x = zeros(L,1); 
x(L) = M(L,C)/M(L,L); 
for j = L-1:-1:1 
    x(j) = (M(j,C) - M(j,j+1:L) * x(j+1:L))/M(j,j); 
end