%% fc_lib_calcnum_RaizNLin_NewtonRaphson_vetor 
%%%%%%%%%%%%% 
% help fc_lib_calcnum_RaizNLin_NewtonRaphson_vetor 
% Belongs to private library 
%%%%%%%%%%%%% 
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC) 
% COPYRIGHT: Free for non evil use. (Não use este código para o mal) 
%%%%%%%%%%%%% 
% Function to find the root of F(x) = 0 through Newton-Raphson method 
% vetor memory form 
% F = function handle 
% dF = derivative of F 
% x0 = initial guess 
% imax = maximum number of iteration 
% tol = desired tolerance 
%%%%%%%%%%%%% 
% version 01: 01.06.2019 -- Creation 
%   Adapted from: fc_lib_calcnum_RaizNLin_NewtonRaphson 
%%%%%%%%%%%%% Example 01 
% syms x; F = exp(-x) - x; dF = jacobian(F,x); 
% % F = 'exp(-x) - x'; dF = '-exp(-x) - 1'; 
% F = matlabFunction(F); dF = matlabFunction(dF); 
% x0 = 0; imax = 50; tol = 10^(-6); 
% X = fc_lib_calcnum_RaizNLin_NewtonRaphson_vetor(F, dF, x0, imax, tol); 
% fc_lib_calcnum_RaizNLin_escrita_passagens([x0; X],F,'%5.6f'); 
%%%%%%%%%%%%% Example 02 
% syms x; F = x - cos(x); dF = jacobian(F,x); 
% % F = 'x - cos(x)'; dF = 'sin(x) + 1'; 
% F = matlabFunction(F); dF = matlabFunction(dF); 
% x0 = -1; imax = 50; tol = 10^(-6); 
% X = fc_lib_calcnum_RaizNLin_NewtonRaphson_vetor(F, dF, x0, imax, tol); 
% fc_lib_calcnum_RaizNLin_escrita_passagens([x0; X],F,'%10.6f'); 
%%%%%%%%%%%%% Example 03 
% syms x; F = x - cos(x); dF = jacobian(F,x); 
% % F = 'x - cos(x)'; dF = 'sin(x) + 1'; 
% F = matlabFunction(F); dF = matlabFunction(dF); 
% x0 = -1; imax = 5; tol = 10^(-6); 
% X = fc_lib_calcnum_RaizNLin_NewtonRaphson_vetor(F, dF, x0, imax, tol); 
% fc_lib_calcnum_RaizNLin_escrita_passagens([x0; X],F,'%+5.6f'); 
%%%%%%%%%%%%% Example 04 
% F = @(x)x^5 - 1; dF = @(x)5*x^4; 
% x0 = 0.8; imax = 10; tol = 10^(-6); 
% X = fc_lib_calcnum_RaizNLin_NewtonRaphson_vetor(F, dF, x0, imax, tol); 
% y0 = 1i; 
% Y = fc_lib_calcnum_RaizNLin_NewtonRaphson_vetor(F, dF, y0, imax, tol); 
% z0 = -1i; 
% Z = fc_lib_calcnum_RaizNLin_NewtonRaphson_vetor(F, dF, z0, imax, tol); 
% w0 = -1 + 1i; 
% W = fc_lib_calcnum_RaizNLin_NewtonRaphson_vetor(F, dF, w0, imax, tol); 
% t0 = -1 - 1i; 
% T = fc_lib_calcnum_RaizNLin_NewtonRaphson_vetor(F, dF, t0, imax, tol); 
% figure; plot(real(X),imag(X),'o:'); grid on; hold all; 
% plot(Y,'o:'); plot(Z,'o:');  plot(W,'o:'); plot(T,'o:'); 
% r = [X(end),Y(end),W(end),T(end),Z(end),X(end)]; plot(real(r),imag(r),'s--'); 
% th = 0:0.01:2*pi; plot(cos(th), sin(th), 'r'); 
%%%%%%%%%%%%% 
%% algorithm 
function X = fc_lib_calcnum_RaizNLin_NewtonRaphson_vetor(F, dF, x0, imax, tol) 
X = zeros(imax,1); X(1) = x0; 
for i = 2:imax 
    if dF(X(i-1)) == 0 % Verifica se não é ponto crítico 
        if F(X(i-1)) == 0 % Verifica se é pt. critico e raiz 
            fprintf('Uma solução exata foi obtida num ponto crítico. Resp = %11.6f \n\n', X(i-1)); 
        else 
            fprintf('Erro: %11.6f é ponto crítico e não é raiz da função.',X(i-1)); 
        end 
        X = X(1:i); return; 
    end 
    X(i) = X(i-1) - (F(X(i-1))/dF(X(i-1))); 
    toli = abs(X(i)-X(i-1)); 
    if F(X(i)) == 0 
        if imag(X(i)) == 0 
            fprintf('Uma solução exata foi obtida. Resp = %f \n', X(i)); 
        else 
            fprintf('Uma solução exata foi obtida. Resp = %f %+fj \n', real(X(i)), imag(X(i))); 
        end 
        X = X(1:i); return; 
    end 
    if toli < tol 
        if imag(X(i)) == 0 
            fprintf('Tolerância atingida! Resp = %f\n', X(i)); 
        else 
            fprintf('Tolerância atingida! Resp = %f %+fj\n', real(X(i)), imag(X(i))); 
        end 
        X = X(1:i); return; 
    end 
end 
if imag(X(i)) == 0 
    fprintf('Número máximo de iterações atingido! Resp = %f\n', X(i)); 
else 
    fprintf('Número máximo de iterações atingido! Resp = %f %+fj\n', real(X(i)), imag(X(i))); 
end 
end