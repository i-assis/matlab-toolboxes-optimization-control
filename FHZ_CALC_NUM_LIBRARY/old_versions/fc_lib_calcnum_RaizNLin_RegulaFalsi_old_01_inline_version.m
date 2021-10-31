%% fc_lib_calcnum_RaizNLin_RegulaFalsi
%%%%%%%%%%%%%
% help fc_lib_calcnum_RaizNLin_RegulaFalsi
% Belongs to private library
%%%%%%%%%%%%%
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC)
% COPYRIGHT: Free for non evil use. (N�o use este c�digo para o mal)
%%%%%%%%%%%%%
% fc_lib_calcnum_RaizNLin_RegulaFalsi(F,a, b, imax, tol)
% Fun��o que calcula a raiz da de F(x) = 0
% F = fun��o
% a = limite inferior do intervalo inicial em que est� uma raiz
% b = limite superior do intervalo inicial em que est� uma raiz
% imax = n�mero m�ximo de itera��es
% tol = toler�ncia admitida
%%%%%%%%%%%%%
% version 01: 04.04.2018
%     Cria��o
%%%%%%%%%%%%% Example
% F = 'x^2 - x'; a = 1; b = 2;
% imax = 50; tol = 10^(-3);
% xchapeu = fc_lib_calcnum_RaizNLin_RegulaFalsi(F,a, b, imax, tol)
%%%%%%%%%%%%%
%% algorithm
function xchapeu = fc_lib_calcnum_RaizNLin_RegulaFalsi(F,a, b, imax, tol)
Fa = feval(F,a); Fb = feval(F,b);
if Fa*Fb > 0
    disp('Erro: a fun��o tem o mesmo sinal nos pontos a e b.');
else
    disp('Itera��o a b (xchapeu)Solu��o f(xchapeu) Toler�ncia');
end
%Vamos calcular a raiz
for i = 1:imax
    xchapeu = (a*Fb-b*Fa)/(Fb-Fa); %Solu��o num�rica aproximada at� aqui
    toli = (b-a)/2; %Toler�ncia atual
    Fxchapeu = feval(F,xchapeu);
    fprintf('%3i %11.6f%11.6f %11.6f %11.6f %11.6f\n\n', i, a, b, xchapeu, Fxchapeu, toli);
    if Fxchapeu == 0
        fprintf('Uma solu��o exata x = %11.6f foi obtida\n\n', xchapeu);
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
    if F(a)*Fxchapeu<0
        b = xchapeu;
    else
        a = xchapeu;
    end
end