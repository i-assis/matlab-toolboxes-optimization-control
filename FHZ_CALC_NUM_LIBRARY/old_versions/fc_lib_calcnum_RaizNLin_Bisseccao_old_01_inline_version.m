%% fc_lib_calcnum_RaizNLin_Bisseccao
%%%%%%%%%%%%%
% help fc_lib_calcnum_RaizNLin_Bisseccao
% Belongs to private library
%%%%%%%%%%%%%
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC)
% COPYRIGHT: Free for non evil use. (N�o use este c�digo para o mal)
%%%%%%%%%%%%%
% fc_lib_calcnum_RaizNLin_Bisseccao(F,a, b, imax, tol)
% Fun��o que calcula a raiz da de F(x) = 0
% F = fun��o
% x0 = valor do chute
% imax = n�mero m�ximo de itera��es
% tol = toler�ncia admitida
%%%%%%%%%%%%%
% version 01: 04.04.2018 -- Creation
%   31.05.2019 -- Added fprintf function to better table
%%%%%%%%%%%%% Example 01
% F = 'x^2 - x'; a = 1; b = 2;
% imax = 50; tol = 10^(-3);
% xchapeu = fc_lib_calcnum_RaizNLin_Bisseccao(F, a, b, imax, tol)
%%%%%%%%%%%%% Example 02
% F = 'x - cos(x)'; a = -1; b = 1;
% imax = 50; tol = 10^(-3);
% xchapeu = fc_lib_calcnum_RaizNLin_Bisseccao(F, a, b, imax, tol)
%%%%%%%%%%%%%%% algorithm
function xchapeu = fc_lib_calcnum_RaizNLin_Bisseccao(F, a, b, imax, tol)
F = inline(F);
Fa = feval(F,a); Fb = feval(F,b);
if Fa*Fb > 0
    fprintf('Erro: a fun��o tem o mesmo sinal nos pontos a e b.\n');
else
    fprintf('Itera��o \ta \t\t\t\tb \t\t\t\t(xchapeu) \tSolu��o f(xchapeu) \tToler�ncia\n');
end
%Vamos calcular a raiz
for i = 1:imax
    xchapeu = (a+b)/2; %Solu��o num�rica aproximada at� aqui
    toli = (b-a)/2; %Toler�ncia atual
    Fxchapeu = feval(F,xchapeu);
    fprintf('%3i \t%11.6f \t%11.6f \t%11.6f \t%11.6f \t%11.6f\n', i, a, b, xchapeu, Fxchapeu, toli);
    if Fxchapeu == 0
        fprintf('Uma solu��o exata x = %11.6f foi obtida\n', xchapeu);
        return;
    end
    if toli < tol
        fprintf('Toler�ncia atingida! resp = %f \n', xchapeu);
        return;
    end
    if i == imax
        fprintf('N�mero m�ximo de itera��es atingido! resp = %f \n', xchapeu);
        return;
    end
    if F(a)*Fxchapeu < 0
        b = xchapeu;
    else
        a = xchapeu;
    end
end