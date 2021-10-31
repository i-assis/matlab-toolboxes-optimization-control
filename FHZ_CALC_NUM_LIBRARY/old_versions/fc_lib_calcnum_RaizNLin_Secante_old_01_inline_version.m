%% fc_lib_calcnum_RaizNLin_Secante
%%%%%%%%%%%%%
% help fc_lib_calcnum_RaizNLin_Secante
% Belongs to private library
%%%%%%%%%%%%%
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC)
% COPYRIGHT: Free for non evil use. (N�o use este c�digo para o mal)
%%%%%%%%%%%%%
% x2 = fc_lib_calcnum_RaizNLin_Secante(F, x0, x1, imax, tipo_tol, tol)
% Fun��o que calcula a raiz da de F(x) = 0
% F = fun��o
% dF = derivada da fun��o em rela��o a uma vari�vel.
% x0 = valor do chute
% imax = n�mero m�ximo de itera��es
%%%%%%%%%%%%%
% version 01: 04.04.2018
%     Cria��o
%%%%%%%%%%%%% Example
% F = 'x^2 - x'; x0 = 1; x1 = 2;
% imax = 50; tipo_tol = 2; tol = 10^(-3);
% x2 = fc_lib_calcnum_RaizNLin_Secante(F, x0, x1, imax, tipo_tol, tol)
%%%%%%%%%%%%%
%% algorithm
function x2 = fc_lib_calcnum_RaizNLin_Secante(F, x0, x1, imax, tipo_tol, tol)
F = inline(F); %o usu�rio digita apenas 'f(x)'
%Vamos calcular a raiz
for i = 1:imax
    if feval(F,x1) - feval (F,x0) == 0 %verifico se n�o � divis�o por zero/pt. cr�tico aprox.
        if ( feval(F,x1) - feval(F,x0) ) / (x1 - x0) == 0 %verifico se � pt. critico e raiz
            fprintf('Uma solu��o exata x = %11.6f foi obtida num ponto cr�tico\n\n', x1);
            break;
       else
            fprintf('Erro:  %11.6f � ponto cr�tico e n�o � raiz da fun��o.',x0);
            break;
        end
    end
    x2 = x1 - ( feval(F,x1)/( (feval(F,x1) - feval(F,x0))/(x1 - x0)) ); %Solu��o num�rica aproximada at� aqui m�todo da Secante
    Fx2 = feval(F,x2);%valor da itera��o x(n+1)
    %Toler�ncia atual, abs � o m�dulo
    if tipo_tol == 1 %tipo de tolerancia escolhida pelo usu�rio
        toli = abs((Fx2-feval(F,x1))/2); %tolerancia a ser usada em 'x^3+3*x^2-1'
    else
        toli = abs(x2-x1)/2; %tolerancia a ser usada em 'x-cos(x)'
    end
    fprintf('%3i x(n-1) = %11.6f raiz = %11.6f F(raiz) = %11.6f tolerancia = %11.6f\n\n',i,x1,x2,Fx2,toli);
    if Fx2 == 0 %an�lise
        fprintf('Uma solu��o exata x = %11.6f foi obtida\n\n', x1);
        return;
    end
    if toli < tol
        fprintf('Toler�ncia atingida! resp = %f \n\n', xchapeu);
        return;
    end
    if i == imax
        fprintf('N�mero m�ximo de itera��es atingido! resp = %f \n\n', xchapeu);
        return;
    end
    x0 = x1; %preparando pr�ximo condi��o do pr�ximo ciclo.
    x1 = x2;
end