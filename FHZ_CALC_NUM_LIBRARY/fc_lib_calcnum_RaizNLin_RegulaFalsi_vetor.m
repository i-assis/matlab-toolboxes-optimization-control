%% fc_lib_calcnum_RaizNLin_RegulaFalsi_vetor_vetor 
%%%%%%%%%%%%% 
% help fc_lib_calcnum_RaizNLin_RegulaFalsi_vetor 
% Belongs to private library 
%%%%%%%%%%%%% 
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC) 
% COPYRIGHT: Free for non evil use. (Não use este código para o mal) 
%%%%%%%%%%%%% 
% Function to find the root of F(x) = 0 through RegulaFalsi method 
% vector memory form 
% F = function handle 
% a,b = initial guess 
% imax = maximum number of iteration 
% tol = desired tolerance 
%%%%%%%%%%%%% 
% version 01: 01.06.2019 -- Creation 
%   Adapted from: fc_lib_calcnum_RaizNLin_RegulaFalsi 
%%%%%%%%%%%%% Example 01 
% F = @(x) x^2 - x; 
% a = 0.5; b = 2; imax = 50; tol = 10^(-5); 
% X = fc_lib_calcnum_RaizNLin_RegulaFalsi_vetor(F, a, b, imax, tol); 
% fc_lib_calcnum_RaizNLin_escrita_passagens(X,F,'%10.6f'); 
%%%%%%%%%%%%% Example 02 
% F = @(x) x - cos(x); 
% a = -1; b = 1; imax = 50; tol = 10^(-6); 
% X = fc_lib_calcnum_RaizNLin_RegulaFalsi_vetor(F, a, b, imax, tol); 
% fc_lib_calcnum_RaizNLin_escrita_passagens(X,F,'%10.6f'); 
%%%%%%%%%%%%% Example 03 
% F = @(x) x - cos(x); 
% a = -0.5; b = 1; imax = 5; tol = 10^(-3); 
% X = fc_lib_calcnum_RaizNLin_RegulaFalsi_vetor(F, a, b, imax, tol); 
% fc_lib_calcnum_RaizNLin_escrita_passagens(X,F,'%10.6f'); 
%%%%%%%%%%%%% 
%% algorithm 
function X = fc_lib_calcnum_RaizNLin_RegulaFalsi_vetor(F, a, b, imax, tol) 
Fa = F(a); Fb = F(b); 
if Fa*Fb > 0 
    disp('Erro: a função tem o mesmo sinal nos pontos a e b.'); 
    X = 0; return; 
end 
X = zeros(imax,1); 
i = 1; X(i) = (a*Fb-b*Fa)/(Fb-Fa); 
while i <= imax && F(X(i)) ~= 0 && (b-a)/2 > tol 
    X(i) = (a*Fb-b*Fa)/(Fb-Fa); 
    if F(a)*F(X(i)) < 0 
        b = X(i); 
    else 
        a = X(i); 
    end 
    i = i + 1; 
end 
if i < imax 
    if i == 1;  i = 2; end 
    X = X(1:i-1); 
    if F(X(end)) == 0 
        fprintf('Uma solução exata foi obtida! Resp = %11.6f\n', X(end)); 
    elseif (b-a)/2 < tol 
        fprintf('Tolerância atingida! Resp = %f\n', X(end)); 
    end 
else 
    fprintf('Número máximo de iterações atingido! Resp = %f\n', X(end)); 
end 
end