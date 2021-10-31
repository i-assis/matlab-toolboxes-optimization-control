%% fc_lib_calcnum_RaizNLin_Secante
%%%%%%%%%%%%%
% help fc_lib_calcnum_RaizNLin_Secante
% Belongs to private library
%%%%%%%%%%%%%
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC)
% COPYRIGHT: Free for non evil use. (Não use este código para o mal)
%%%%%%%%%%%%%
% x2 = fc_lib_calcnum_RaizNLin_Secante(F, x0, x1, imax, tipo_tol, tol)
% Função que calcula a raiz da de F(x) = 0
% F = função
% dF = derivada da função em relação a uma variável.
% x0 = valor do chute
% imax = número máximo de iterações
%%%%%%%%%%%%%
% version 01: 04.04.2018
%     Criação
%%%%%%%%%%%%% Example
% F = 'x^2 - x'; x0 = 1; x1 = 2;
% imax = 50; tipo_tol = 2; tol = 10^(-3);
% x2 = fc_lib_calcnum_RaizNLin_Secante(F, x0, x1, imax, tipo_tol, tol)
%%%%%%%%%%%%%
%% algorithm
function x2 = fc_lib_calcnum_RaizNLin_Secante(F, x0, x1, imax, tipo_tol, tol)
F = inline(F); %o usuário digita apenas 'f(x)'
%Vamos calcular a raiz
for i = 1:imax
    if feval(F,x1) - feval (F,x0) == 0 %verifico se não é divisão por zero/pt. crítico aprox.
        if ( feval(F,x1) - feval(F,x0) ) / (x1 - x0) == 0 %verifico se é pt. critico e raiz
            fprintf('Uma solução exata x = %11.6f foi obtida num ponto crítico\n\n', x1);
            break;
       else
            fprintf('Erro:  %11.6f é ponto crítico e não é raiz da função.',x0);
            break;
        end
    end
    x2 = x1 - ( feval(F,x1)/( (feval(F,x1) - feval(F,x0))/(x1 - x0)) ); %Solução numérica aproximada até aqui método da Secante
    Fx2 = feval(F,x2);%valor da iteração x(n+1)
    %Tolerância atual, abs é o módulo
    if tipo_tol == 1 %tipo de tolerancia escolhida pelo usuário
        toli = abs((Fx2-feval(F,x1))/2); %tolerancia a ser usada em 'x^3+3*x^2-1'
    else
        toli = abs(x2-x1)/2; %tolerancia a ser usada em 'x-cos(x)'
    end
    fprintf('%3i x(n-1) = %11.6f raiz = %11.6f F(raiz) = %11.6f tolerancia = %11.6f\n\n',i,x1,x2,Fx2,toli);
    if Fx2 == 0 %análise
        fprintf('Uma solução exata x = %11.6f foi obtida\n\n', x1);
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
    x0 = x1; %preparando próximo condição do próximo ciclo.
    x1 = x2;
end