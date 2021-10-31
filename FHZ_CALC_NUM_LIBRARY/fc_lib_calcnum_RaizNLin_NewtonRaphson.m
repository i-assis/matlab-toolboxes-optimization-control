%% fc_lib_calcnum_RaizNLin_NewtonRaphson 
%%%%%%%%%%%%% 
% help fc_lib_calcnum_RaizNLin_NewtonRaphson 
% Belongs to private library 
%%%%%%%%%%%%% 
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC) 
% COPYRIGHT: Free for non evil use. (Não use este código para o mal) 
%%%%%%%%%%%%% 
% Function to find the root of F(x) = 0 through Newton-Raphson method 
% scalar no memory form 
% F = function handle 
% dF = derivative of F 
% x0 = initial guess 
% imax = maximum number of iteration 
% tol = desired tolerance 
%%%%%%%%%%%%% 
% version 01: 04.04.2018 -- Creation - Adapted from the original code as student 
%   31.05.2019 -- New example added 
% version 02: 01.06.2019 -- Update from inline to function handle 
%   New standard for fc_lib_calcnum_RaizNLin functions 
%%%%%%%%%%%%% Example 01 
% syms x; F = exp(-x) - x; dF = jacobian(F,x); 
% % F = @(x) exp(-x) - x; dF = @(x)-exp(-x) - 1; 
% F = matlabFunction(F); dF = matlabFunction(dF); 
% x0 = 0; imax = 50; tol = 10^(-6); 
% x1 = fc_lib_calcnum_RaizNLin_NewtonRaphson(F, dF, x0, imax, tol); 
% % x1 = 0.567143; 
%%%%%%%%%%%%% Example 02 
% syms x; F = x - cos(x); dF = jacobian(F,x); 
% % F = @(x)x - cos(x); dF = @(x)sin(x) + 1; 
% F = matlabFunction(F); dF = matlabFunction(dF); 
% x0 = -1; imax = 50; tol = 10^(-6); 
% x1 = fc_lib_calcnum_RaizNLin_NewtonRaphson(F, dF, x0, imax, tol); 
% % x1 = 0.7391; 
%%%%%%%%%%%%% Example 03 
% syms x; F = x - cos(x); dF = jacobian(F,x); 
% % F = @(x)x - cos(x); dF = @(x)sin(x) + 1; 
% F = matlabFunction(F); dF = matlabFunction(dF); 
% x0 = -1; imax = 5; tol = 10^(-6); 
% x1 = fc_lib_calcnum_RaizNLin_NewtonRaphson(F, dF, x0, imax, tol); 
% % x1 = 0.7391; 
%%%%%%%%%%%%% Example 04 
% F = @(x)x^5 - 1; dF = @(x)5*x^4; 
% x0 = 0.8; imax = 5; tol = 10^(-6); 
% x1 = fc_lib_calcnum_RaizNLin_NewtonRaphson(F, dF, x0, imax, tol); 
% y0 = 1i; 
% y1 = fc_lib_calcnum_RaizNLin_NewtonRaphson(F, dF, y0, imax, tol); 
% z0 = -1i; 
% z1 = fc_lib_calcnum_RaizNLin_NewtonRaphson(F, dF, z0, imax, tol); 
% w0 = -1 + 1i; 
% w1 = fc_lib_calcnum_RaizNLin_NewtonRaphson(F, dF, w0, imax, tol); 
% t0 = -1 - 1i; 
% t1 = fc_lib_calcnum_RaizNLin_NewtonRaphson(F, dF, t0, imax, tol); 
% r = [x1,y1,w1,t1,z1,x1]; plot(real(r),imag(r),'ob--'); hold on; 
% th = 0:0.01:2*pi; plot(cos(th), sin(th), 'r'); 
%%%%%%%%%%%%% 
%% algorithm 
function x1 = fc_lib_calcnum_RaizNLin_NewtonRaphson(F, dF, x0, imax, tol) 
for i = 1:imax 
    if dF(x0) == 0 % Verifica se não é ponto crítico 
        if F(x0) == 0 % Verifica se é pt. critico e raiz 
            fprintf('Uma solução exata foi obtida num ponto crítico. Resp = %11.6f \n\n', x1); 
            return; 
        else 
            fprintf('Erro: %11.6f é ponto crítico e não é raiz da função.',x0); 
            return; 
        end 
    end 
    x1 = x0 - (F(x0)/dF(x0)); 
    Fx1 = F(x1); 
    toli = abs(x1-x0); 
    if Fx1 == 0 
        if imag(x1) == 0 
            fprintf('Uma solução exata foi obtida. Resp = %f \n', x1); 
        else 
            fprintf('Uma solução exata foi obtida. Resp = %f %+fj \n', real(x1), imag(x1)); 
        end 
        return; 
    end 
    if toli < tol 
        if imag(x1) == 0 
            fprintf('Tolerância atingida! Resp = %f\n', x1); 
        else 
            fprintf('Tolerância atingida! Resp = %f %+fj\n', real(x1), imag(x1)); 
        end 
        return; 
    end 
    x0 = x1; % próximo ciclo 
end 
if imag(x1) == 0 
    fprintf('Número máximo de iterações atingido! Resp = %f\n', x1); 
else 
    fprintf('Número máximo de iterações atingido! Resp = %f %+fj\n', real(x1), imag(x1)); 
end 
end