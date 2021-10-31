%% fc_lib_calcnum_RaizNLin_RegulaFalsi
%%%%%%%%%%%%%
% help fc_lib_calcnum_RaizNLin_RegulaFalsi
% Belongs to private library
%%%%%%%%%%%%%
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC)
% COPYRIGHT: Free for non evil use. (Não use este código para o mal)
%%%%%%%%%%%%%
% fc_lib_calcnum_RaizNLin_RegulaFalsi(F,a, b, imax, tol)
% Função que calcula a raiz da de F(x) = 0
% F = função
% a = limite inferior do intervalo inicial em que está uma raiz
% b = limite superior do intervalo inicial em que está uma raiz
% imax = número máximo de iterações
% tol = tolerância admitida
%%%%%%%%%%%%%
% version 01: 04.04.2018
%     Criação
%%%%%%%%%%%%% Example
% F = 'x^2 - x'; a = 1; b = 2;
% imax = 50; tol = 10^(-3);
% xchapeu = fc_lib_calcnum_RaizNLin_RegulaFalsi(F,a, b, imax, tol)
%%%%%%%%%%%%%
%% algorithm
function xchapeu = fc_lib_calcnum_RaizNLin_RegulaFalsi(F,a, b, imax, tol)
Fa = feval(F,a); Fb = feval(F,b);
if Fa*Fb > 0
    disp('Erro: a função tem o mesmo sinal nos pontos a e b.');
else
    disp('Iteração a b (xchapeu)Solução f(xchapeu) Tolerância');
end
%Vamos calcular a raiz
for i = 1:imax
    xchapeu = (a*Fb-b*Fa)/(Fb-Fa); %Solução numérica aproximada até aqui
    toli = (b-a)/2; %Tolerância atual
    Fxchapeu = feval(F,xchapeu);
    fprintf('%3i %11.6f%11.6f %11.6f %11.6f %11.6f\n\n', i, a, b, xchapeu, Fxchapeu, toli);
    if Fxchapeu == 0
        fprintf('Uma solução exata x = %11.6f foi obtida\n\n', xchapeu);
        return;
    end
    if toli < tol
        fprintf('Tolerância atingida! resp = %f \n\n', xchapeu);
        return;
    end
    if i == imax
        fprintf('Número máximo de iterações atingido! resp = %f \n\n', xchapeu);
        return;
    end
    if F(a)*Fxchapeu<0
        b = xchapeu;
    else
        a = xchapeu;
    end
end