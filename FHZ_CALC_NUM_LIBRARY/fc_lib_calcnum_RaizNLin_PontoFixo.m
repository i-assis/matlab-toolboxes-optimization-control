%% fc_lib_calcnum_RaizNLin_PontoFixo 
%%%%%%%%%%%%% 
% help fc_lib_calcnum_RaizNLin_PontoFixo 
% Belongs to private library 
%%%%%%%%%%%%% 
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC) 
% COPYRIGHT: Free for non evil use. (Não use este código para o mal) 
%%%%%%%%%%%%% 
% Function to find the root of F(x) = 0 through Fixed-Point method 
% scalar no memory form 
% F = function handle 
% x0 = initial guess 
% imax = maximum number of iteration 
% tol = desired tolerance 
%%%%%%%%%%%%% 
% version 01: 04.04.2018 -- Creation 
%   31.05.2019 -- New example added 
% version 02: 01.06.2019 -- Update from inline to function handle 
%   New standard for fc_lib_calcnum_RaizNLin functions 
%   This method does not work very well. 
%       Therefore, it will not have a vector version 
%%%%%%%%%%%%% Example 01 
% F = @(x) x^2 - x; 
% x0 = 1; imax = 50; tol = 10^(-3); 
% x1 = fc_lib_calcnum_RaizNLin_PontoFixo(F, x0, imax, tol) 
%%%%%%%%%%%%% Example 02 
% F = @(x) x - cos(x); 
% x0 = 0.5; imax = 50; tol = 10^(-3); 
% x1 = fc_lib_calcnum_RaizNLin_PontoFixo(F, x0, imax, tol); 
%%%%%%%%%%%%% 
%% algorithm 
function x1 = fc_lib_calcnum_RaizNLin_PontoFixo(F, x0, imax, tol) 
for i = 1:imax 
    x1 = F(x0); 
    toli = abs(F(x0)-x0); 
    if x1 == x0 
        fprintf('Uma solução exata foi obtida! Resp = %11.6f\n\n', x1); 
        return; 
    end 
    if toli < tol 
        fprintf('Tolerância atingida! Resp = %f\n\n', x1); 
        return; 
    end 
    if i == imax 
        fprintf('Número máximo de iterações atingido! Resp = %f\n\n', x1); 
        return; 
    end 
    x0 = x1; % próximo ciclo. 
end