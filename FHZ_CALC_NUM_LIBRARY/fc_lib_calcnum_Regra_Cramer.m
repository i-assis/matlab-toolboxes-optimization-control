%% fc_lib_calcnum_Regra_Cramer 
%%%%%%%%%%%%% 
% help fc_lib_calcnum_Regra_Cramer 
% Belongs to private library 
%%%%%%%%%%%%% 
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC) 
% COPYRIGHT: Free for non evil use. (Não use este código para o mal) 
%%%%%%%%%%%%% 
% fc_lib_calcnum_Regra_Cramer(A,b) 
% Function to solve linear system with Cramer rule 
% Funcao para calcular um sistema de equacoes algebricas por meio 
% da Regra de Cramer 
% A: matriz de coeficientes 
% b: vetor de constantes 
%%%%%%%%%%%%% 
% version 01: 04.04.2018 
%     Criação 
%%%%%%%%%%%%% Example 
% A = randi(10,3,3) 
% b = randi(10,3,1) 
% x = fc_lib_calcnum_Regra_Cramer(A,b) 
%%%%%%%%%%%%% 
%% algorithm 
function x = fc_lib_calcnum_Regra_Cramer(A,b) 
na = size(A,1); 
nb = size(b,1); 
x = zeros(nb,1); 
if na ~= nb %conferindo se A e b tem o mesmo nº de linhas 
    fprintf('Erro: nº de linhas de A diferente de b'); 
    return; 
end 
Da = det(A); 
A1 = [b A(:,2:(nb))]; 
x(1,1) = det(A1)/Da; 
% Como não posso escrever a uma variação de posição igual a 0 
% me vi obrigado a calcular o x(1,1) e o x(n,1) separadamente do for para os 
% elementos entre 1 e n. 
% Alternativa: Recursão 
if nb >2 
    for k = 2:(nb-1) 
        Ak = [A(:,1:k-1) b A(:,k+1:nb)]; 
        Dk = det (Ak); 
        x(k,1) = Dk / Da; 
    end 
end 
An = [A(:,1:(nb-1)) b]; 
x(nb,1)= det (An) / Da; 
end