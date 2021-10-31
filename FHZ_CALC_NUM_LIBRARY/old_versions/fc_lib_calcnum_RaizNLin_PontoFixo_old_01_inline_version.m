%% fc_lib_calcnum_RaizNLin_PontoFixo
%%%%%%%%%%%%%
% help fc_lib_calcnum_RaizNLin_PontoFixo
% Belongs to private library
%%%%%%%%%%%%%
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC)
% COPYRIGHT: Free for non evil use. (Não use este código para o mal)
%%%%%%%%%%%%%
% fc_lib_calcnum_RaizNLin_PontoFixo(F, x0, imax, tol)
% Função que calcula a raiz da de F(x) = 0
% F = função
% x0 = limite inferior do intervalo inicial em que está uma raiz
% b = limite superior do intervalo inicial em que está uma raiz
% imax = número máximo de iterações
% tol = tolerância admitida
%%%%%%%%%%%%%
% version 01: 04.04.2018
%     Criação
%%%%%%%%%%%%% Example
% F = 'x^2 - x'; x0 = 1;
% imax = 50; tol = 10^(-3);
% raiz = fc_lib_calcnum_RaizNLin_PontoFixo(F, x0, imax, tol)
%%%%%%%%%%%%%
%% algorithm
function raiz = fc_lib_calcnum_RaizNLin_PontoFixo(F, x0, imax, tol)
%Função que calcula a raiz da de F(x) = x
%F = função
%x0 = valor do chute
%imax = número máximo de iterações
%tol = tolerancia
F = inline(F); %o usuário digita apenas 'f(x)'
%Vamos calcular a raiz
for i = 1:imax
    x1 = feval(F,x0); %Solução numérica aproximada até aqui método de ponto-fixo
    %Tolerância atual, abs é o módulo
    toli = abs(feval(F,x0)-x0);
    fprintf('%3i x(n-1) = %11.6f raiz = %11.6f F(raiz) = %11.6f tolerancia = %11.6f\n\n',i,x0,x1, feval(F,x1),toli);
    if x1 == x0 %análise
        fprintf('Uma solução exata x = %11.6f foi obtida\n\n', x1);
        return;
    end
    if toli < tol
        fprintf('Tolerância atingida! resp = %f \n\n', x1);
        return;
    end
    if i == imax
        fprintf('Número máximo de iterações atingido! resp = %f \n\n', x1);
        return;
    end
    x0 = x1; %preparando próximo condição do próximo ciclo.
end