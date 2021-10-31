%% fc_lib_calcnum_RaizNLin_Secante 
%%%%%%%%%%%%% 
% help fc_lib_calcnum_RaizNLin_Secante 
% Belongs to private library 
%%%%%%%%%%%%% 
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC) 
% COPYRIGHT: Free for non evil use. (Não use este código para o mal) 
%%%%%%%%%%%%% 
% Function to find the root of F(x) = 0 through secant method 
% vectorial memory form 
% F = function handle 
% x0, x1 = initial guesses 
% imax = maximum number of iteration 
% tol = desired tolerance 
% tipo_tol = type of tolerance 
%%%%%%%%%%%%% 
% version 01: 01.06.2019 -- Creation 
%   Adapted from: fc_lib_calcnum_RaizNLin_Secante 
%%%%%%%%%%%%% Example 01 
% F = @(x) x^2 - x; 
% x0 = 1; x1 = 2; imax = 50; tipo_tol = 2; tol = 10^(-5); 
% X = fc_lib_calcnum_RaizNLin_Secante_vetor(F,x0,x1,imax,tipo_tol,tol); 
% fc_lib_calcnum_RaizNLin_escrita_passagens([x0; x1; X],F,'%5.6f'); 
%%%%%%%%%%%%% Example 02 
% F = @(x) x - cos(x); 
% x0 = 1; x1 = 2; imax = 50; tipo_tol = 2; tol = 10^(-3); 
% X = fc_lib_calcnum_RaizNLin_Secante_vetor(F,x0,x1,imax,tipo_tol,tol); 
% fc_lib_calcnum_RaizNLin_escrita_passagens([x0; x1; X],F,'%5.6f'); 
%%%%%%%%%%%%% Example 03 
% F = @(x) x - cos(x); 
% x0 = -2; x1 = 2; imax = 10; tipo_tol = 2; tol = 10^(-3); 
% X = fc_lib_calcnum_RaizNLin_Secante_vetor(F,x0,x1,imax,tipo_tol,tol); 
% fc_lib_calcnum_RaizNLin_escrita_passagens([x0; x1; X],F,'%5.6f'); 
%%%%%%%%%%%%% 
%% algorithm 
function X = fc_lib_calcnum_RaizNLin_Secante_vetor(F, x0, x1, imax, tipo_tol, tol) 
X = zeros(imax,1); X(1) = x0; X(2) = x1; 
i = 3; toli = abs(X(2) - X(1))/2; Fx2 = F(X(1)); 
while i < imax + 2 && tol < toli && F(x1) - F(x0) ~= 0 && Fx2 ~= 0 
    X(i) = X(i-1) - ( F(X(i-1))/( (F(X(i-1)) - F(X(i-2)))/(X(i-1) - X(i-2))) ); 
    Fx2 = (X(i)); 
    if tipo_tol == 1 
        toli = abs((Fx2-F(X(i-1)))/2); 
    else 
        toli = abs(X(i)-X(i-1))/2; 
    end 
    i = i + 1; 
end 
%% análises 
if i < imax 
    X = X(1:i-1); 
    if toli < tol 
        fprintf('Tolerância atingida! Resp = %f\n', X(end)); 
    elseif Fx2 == 0 
        fprintf('Uma solução exata foi obtida! Resp = %11.6f\n', F(X(i-1))); 
    elseif F(x1) - F(x0) == 0 
        fprintf('Uma solução exata foi obtida num ponto crítico. Resp = %11.6f \n', X(end-1)); 
    else 
        fprintf('Erro: %11.6f é ponto crítico e não é raiz da função.',X(end-2)); 
    end 
else 
    fprintf('Número máximo de iterações atingido! Resp = %f\n', X(end)); 
end 
end