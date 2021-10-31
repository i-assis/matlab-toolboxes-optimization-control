%% fc_lib_calcnum_RaizNLin_Bisseccao 
%%%%%%%%%%%%% 
% help fc_lib_calcnum_RaizNLin_Bisseccao 
% Belongs to private library 
%%%%%%%%%%%%% 
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC) 
% COPYRIGHT: Free for non evil use. (Não use este código para o mal) 
%%%%%%%%%%%%% 
% Function to find the root of F(x) = 0 through Bissection method 
% scalar no memory form 
% F = function handle 
% a,b = initial guess 
% imax = maximum number of iteration 
% tol = desired tolerance 
%%%%%%%%%%%%% 
% version 01: 04.04.2018 -- Creation 
%   31.05.2019 -- Added fprintf function to better table 
% version 02: 01.06.2019 -- Update from inline to function handle 
%   New standard for fc_lib_calcnum_RaizNLin functions 
%%%%%%%%%%%%% Example 01 
% F = @(x) x^2 - x; 
% a = -1; b = 1; imax = 50; tol = 10^(-3); 
% xchapeu = fc_lib_calcnum_RaizNLin_Bisseccao(F, a, b, imax, tol); 
%%%%%%%%%%%%% Example 02 
% F = @(x) x - cos(x); 
% a = -1; b = 1; imax = 50; tol = 10^(-3); 
% xchapeu = fc_lib_calcnum_RaizNLin_Bisseccao(F, a, b, imax, tol); 
%%%%%%%%%%%%% Example 03 
% F = @(x) x - cos(x); 
% a = -1; b = 1; imax = 5; tol = 10^(-3); 
% xchapeu = fc_lib_calcnum_RaizNLin_Bisseccao(F, a, b, imax, tol); 
% % fprintf('%3i \t%11.6f \t%11.6f \t%11.6f \t%11.6f \t%11.6f\n', i, a, b, xchapeu, F(xchapeu), toli); 
%%%%%%%%%%%%%%% algorithm 
function xchapeu = fc_lib_calcnum_RaizNLin_Bisseccao(F, a, b, imax, tol) 
Fa = F(a); Fb = F(b); 
if Fa*Fb > 0 
    fprintf('Erro: a função tem o mesmo sinal nos pontos a e b.\n'); 
    xchapeu = 0; return; 
end 
i = 1; xchapeu = (a+b)/2; 
while i <= imax && F(xchapeu) ~= 0 && (b-a)/2 > tol 
    xchapeu = (a+b)/2; 
    if F(a)*F(xchapeu) < 0 
        b = xchapeu; 
    else 
        a = xchapeu; 
    end 
    i = i + 1; 
end 
if i < imax 
    if F(xchapeu) == 0 
        fprintf('Uma solução exata foi obtida! Resp = %11.6f\n', xchapeu); 
    elseif (b-a)/2 < tol 
        fprintf('Tolerância atingida! Resp = %f\n', xchapeu); 
    end 
else 
    fprintf('Número máximo de iterações atingido! Resp = %f\n', xchapeu); 
end 
end