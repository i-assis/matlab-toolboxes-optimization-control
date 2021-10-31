%% fc_lib_calcnum_RaizNLin_NewtonRaphson
%%%%%%%%%%%%%
% help fc_lib_calcnum_RaizNLin_NewtonRaphson
% Belongs to private library
%%%%%%%%%%%%%
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC)
% COPYRIGHT: Free for non evil use. (N�o use este c�digo para o mal)
%%%%%%%%%%%%%
% fc_lib_calcnum_RaizNLin_NewtonRaphson(F, dF, x0, imax, tol)
% Function to find a root of F(x) = 0
% F = function
% dF = derivative of the function
% x0 = initial point
% imax = maximun number of iterations
%%%%%%%%%%%%%
% version 01: 04.04.2018
%     Creation - Adapted from the original code as student
%   31.05.2019 -- New example added
%%%%%%%%%%%%% Example 01
% syms x;
% F = exp(-x) - x;
% dF = jacobian(F,x);
% % F = 'exp(-x) - x'; dF = '-exp(-x) - 1';
% x0 = 0; imax = 50; tol = 10^(-6);
% x1 = fc_lib_calcnum_RaizNLin_NewtonRaphson(F, dF, x0, imax, tol);
% % x1 = 0.567143;
%%%%%%%%%%%%% Example 01
% syms x;
% F = x - cos(x);
% dF = jacobian(F,x);
% % F = 'x - cos(x)'; dF = 'sin(x) + 1';
% x0 = -1; imax = 50; tol = 10^(-6);
% x1 = fc_lib_calcnum_RaizNLin_NewtonRaphson(F, dF, x0, imax, tol);
% % x1 = 0.7391;
%%%%%%%%%%%%%
%% algorithm
function x1 = fc_lib_calcnum_RaizNLin_NewtonRaphson(F, dF, x0, imax, tol)
F = inline(F); %o usu�rio digita apenas 'f(x)'
dF = inline(dF); %o usu�rio digita apenas 'df(x)'
%Vamos calcular a raiz
for i = 1:imax
    if feval(dF,x0) == 0%verifico se n�o � ponto cr�tico
        if feval(F,x0) == 0%verifico se � pt. critico e raiz
            fprintf('Uma solu��o exata x = %11.6f foi obtida num ponto cr�tico\n\n', x1);
            break;
        else
            fprintf('Erro:  %11.6f � ponto cr�tico e n�o � raiz da fun��o.',x0);
            break;
        end
    end
    x1 = x0 - (feval(F,x0)/feval(dF,x0)); %Solu��o num�rica aproximada at� aqui m�todo de Newton-Raphson
    Fx1 = feval(F,x1);%valor da itera��o x(n+1)
    %Toler�ncia atual, abs � o m�dulo
    toli = abs(x1-x0); %tolerancia em x'
    fprintf('%3i x(n-1) = %11.6f raiz = %11.6f F(raiz) = %11.6f tolerancia = %11.6f\n',i,x0,x1,Fx1,toli);
    if Fx1 == 0 %an�lise
        if imag(x1) == 0
            fprintf('Uma solu��o exata x = %f foi obtida\n', x1);
        else
            fprintf('Uma solu��o exata x = %f %+fj foi obtida\n', real(x1), imag(x1));
        end
        return;
    end
    if toli < tol
        if imag(x1) == 0
            fprintf('Toler�ncia atingida! resp = %f \n', x1);
        else
            fprintf('Toler�ncia atingida! resp = %f %+fj \n', real(x1), imag(x1));
        end
        return;
    end
    if i == imax
        if imag(x1) == 0
            fprintf('N�mero m�ximo de itera��es atingido! resp = %f \n', x1);
        else
            fprintf('N�mero m�ximo de itera��es atingido! resp = %f %+fj \n', real(x1), imag(x1));
        end
        return;
    end
    x0 = x1; %preparando pr�ximo condi��o do pr�ximo ciclo
end