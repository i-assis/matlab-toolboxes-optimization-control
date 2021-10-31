%% fc_lib_calcnum_RaizNLin_PontoFixo
%%%%%%%%%%%%%
% help fc_lib_calcnum_RaizNLin_PontoFixo
% Belongs to private library
%%%%%%%%%%%%%
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC)
% COPYRIGHT: Free for non evil use. (N�o use este c�digo para o mal)
%%%%%%%%%%%%%
% fc_lib_calcnum_RaizNLin_PontoFixo(F, x0, imax, tol)
% Fun��o que calcula a raiz da de F(x) = 0
% F = fun��o
% x0 = limite inferior do intervalo inicial em que est� uma raiz
% b = limite superior do intervalo inicial em que est� uma raiz
% imax = n�mero m�ximo de itera��es
% tol = toler�ncia admitida
%%%%%%%%%%%%%
% version 01: 04.04.2018
%     Cria��o
%%%%%%%%%%%%% Example
% F = 'x^2 - x'; x0 = 1;
% imax = 50; tol = 10^(-3);
% raiz = fc_lib_calcnum_RaizNLin_PontoFixo(F, x0, imax, tol)
%%%%%%%%%%%%%
%% algorithm
function raiz = fc_lib_calcnum_RaizNLin_PontoFixo(F, x0, imax, tol)
%Fun��o que calcula a raiz da de F(x) = x
%F = fun��o
%x0 = valor do chute
%imax = n�mero m�ximo de itera��es
%tol = tolerancia
F = inline(F); %o usu�rio digita apenas 'f(x)'
%Vamos calcular a raiz
for i = 1:imax
    x1 = feval(F,x0); %Solu��o num�rica aproximada at� aqui m�todo de ponto-fixo
    %Toler�ncia atual, abs � o m�dulo
    toli = abs(feval(F,x0)-x0);
    fprintf('%3i x(n-1) = %11.6f raiz = %11.6f F(raiz) = %11.6f tolerancia = %11.6f\n\n',i,x0,x1, feval(F,x1),toli);
    if x1 == x0 %an�lise
        fprintf('Uma solu��o exata x = %11.6f foi obtida\n\n', x1);
        return;
    end
    if toli < tol
        fprintf('Toler�ncia atingida! resp = %f \n\n', x1);
        return;
    end
    if i == imax
        fprintf('N�mero m�ximo de itera��es atingido! resp = %f \n\n', x1);
        return;
    end
    x0 = x1; %preparando pr�ximo condi��o do pr�ximo ciclo.
end