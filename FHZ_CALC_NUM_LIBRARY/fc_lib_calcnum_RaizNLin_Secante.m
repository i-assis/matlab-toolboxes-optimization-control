%% fc_lib_calcnum_RaizNLin_Secante 
%%%%%%%%%%%%% 
% help fc_lib_calcnum_RaizNLin_Secante 
% Belongs to private library 
%%%%%%%%%%%%% 
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC) 
% COPYRIGHT: Free for non evil use. (N�o use este c�digo para o mal) 
%%%%%%%%%%%%% 
% Function to find the root of F(x) = 0 through secant method 
% scalar no memory form 
% F = function handle 
% x0, x1 = initial guesses 
% imax = maximum number of iteration 
% tol = desired tolerance 
% tipo_tol = type of tolerance 
%%%%%%%%%%%%% 
% version 01: 04.04.2018 -- Creation - Adapted from the original code as student 
%   31.05.2019 -- New example added 
% version 02: 01.06.2019 -- Update from inline to function handle 
%   New standard for fc_lib_calcnum_RaizNLin functions 
%%%%%%%%%%%%% Example 01 
% F = @(x) x^2 - x; 
% x0 = 1; x1 = 2;imax = 50; tipo_tol = 2; tol = 10^(-3); 
% x2 = fc_lib_calcnum_RaizNLin_Secante(F, x0, x1, imax, tipo_tol, tol) 
%%%%%%%%%%%%% Example 02 
% F = @(x) x - cos(x); 
% x0 = 1; x1 = 2; imax = 50; tipo_tol = 2; tol = 10^(-3); 
% x2 = fc_lib_calcnum_RaizNLin_Secante(F, x0, x1, imax, tipo_tol, tol) 
%%%%%%%%%%%%% Example 03 
% F = @(x) x - cos(x); 
% x0 = -2; x1 = 2; imax = 2; tipo_tol = 2; tol = 10^(-3); 
% x2 = fc_lib_calcnum_RaizNLin_Secante(F, x0, x1, imax, tipo_tol, tol) 
%%%%%%%%%%%%% 
%% algorithm 
function x2 = fc_lib_calcnum_RaizNLin_Secante(F, x0, x1, imax, tipo_tol, tol) 
i = 1; toli = abs(x1-x0)/2; Fx2 = F(x1); 
while i < imax && tol < toli && F(x1) - F(x0) ~= 0 && Fx2 ~= 0 
    x2 = x1 - ( F(x1)/( (F(x1) - F(x0))/(x1 - x0)) ); %Solu��o num�rica aproximada at� aqui m�todo da Secante 
    Fx2 = F(x2); 
    if tipo_tol == 1 
        toli = abs((Fx2-F(x1))/2); 
    else 
        toli = abs(x2-x1)/2; 
    end 
    x0 = x1; % preparando pr�ximo ciclo. 
    x1 = x2; 
    i = i + 1; 
end 
%% an�lises 
if i < imax 
    if toli < tol 
        fprintf('Toler�ncia atingida! Resp = %f\n', x2); 
    elseif Fx2 == 0 
        fprintf('Uma solu��o exata foi obtida! Resp = %11.6f\n', x2); 
    elseif F(x1) - F(x0) == 0 
        fprintf('Uma solu��o exata foi obtida num ponto cr�tico. Resp = %11.6f \n', x1); 
    else 
        fprintf('Erro: %11.6f � ponto cr�tico e n�o � raiz da fun��o.',x0); 
    end 
else 
    fprintf('N�mero m�ximo de itera��es atingido! Resp = %f\n', x2); 
end 
end