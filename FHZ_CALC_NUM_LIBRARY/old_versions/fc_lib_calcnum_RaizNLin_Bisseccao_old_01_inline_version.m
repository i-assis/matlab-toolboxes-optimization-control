%% fc_lib_calcnum_RaizNLin_Bisseccao
%%%%%%%%%%%%%
% help fc_lib_calcnum_RaizNLin_Bisseccao
% Belongs to private library
%%%%%%%%%%%%%
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC)
% COPYRIGHT: Free for non evil use. (Não use este código para o mal)
%%%%%%%%%%%%%
% fc_lib_calcnum_RaizNLin_Bisseccao(F,a, b, imax, tol)
% Função que calcula a raiz da de F(x) = 0
% F = função
% x0 = valor do chute
% imax = número máximo de iterações
% tol = tolerância admitida
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
    fprintf('Erro: a função tem o mesmo sinal nos pontos a e b.\n');
else
    fprintf('Iteração \ta \t\t\t\tb \t\t\t\t(xchapeu) \tSolução f(xchapeu) \tTolerância\n');
end
%Vamos calcular a raiz
for i = 1:imax
    xchapeu = (a+b)/2; %Solução numérica aproximada até aqui
    toli = (b-a)/2; %Tolerância atual
    Fxchapeu = feval(F,xchapeu);
    fprintf('%3i \t%11.6f \t%11.6f \t%11.6f \t%11.6f \t%11.6f\n', i, a, b, xchapeu, Fxchapeu, toli);
    if Fxchapeu == 0
        fprintf('Uma solução exata x = %11.6f foi obtida\n', xchapeu);
        return;
    end
    if toli < tol
        fprintf('Tolerância atingida! resp = %f \n', xchapeu);
        return;
    end
    if i == imax
        fprintf('Número máximo de iterações atingido! resp = %f \n', xchapeu);
        return;
    end
    if F(a)*Fxchapeu < 0
        b = xchapeu;
    else
        a = xchapeu;
    end
end