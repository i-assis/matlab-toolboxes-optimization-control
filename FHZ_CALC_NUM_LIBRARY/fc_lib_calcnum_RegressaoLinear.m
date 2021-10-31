%% fc_lib_calcnum_RegressaoLinear 
%%%%%%%%%%%%% 
% help fc_lib_calcnum_RegressaoLinear 
% Belongs to private library 
%%%%%%%%%%%%% 
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC) 
% COPYRIGHT: Free for non evil use. (Não use este código para o mal) 
%%%%%%%%%%%%% 
% [a1, a0] = fc_lib_calcnum_RegressaoLinear(x,y,XI,linearizar) 
% RegressaoLinear calcula os coeficientes a1 e a0 da equação linear 
% y = a1*x+a0 que melhor se ajusta aos n pontos do conjunto de dados. 
% Variáveis de entrada: 
% x - Vetor com as coordenadas x dos pontos 
% y - vetor com as coordenadas y dos pontos 
% Variáveis de saída: 
% a1 - Coeficiente a1. 
% a0 - Coeficiente a0. 
%%%%%%%%%%%%% 
% version 01: 18.07.2018 -- Creation
%%%%%%%%%%%%% Example 
% x = [0 1 2 3 4 5]; 
% y = [0 2.1 3.9 5.8 8.1 9.8]; 
% XI = 2*x; 
% linearizar = 'n'; 
% [a1, a0] = fc_lib_calcnum_RegressaoLinear(x,y,XI,linearizar); 
%%%%%%%%%%%%% 
%% algorithm 
function [a1, a0] = fc_lib_calcnum_RegressaoLinear(x,y,XI,linearizar) 
if linearizar == 's' 
    x = log(x); 
    y = log(y); 
end 
nx = length(x); 
ny = length(y); 
% Verifica se os vetores x e y têm mesmo num. de elementos 
% Se não o Matlab exibe mensagem de erro 
if nx ~= ny 
    disp('ERRO: O número de elementos em x deve ser o mesmo que em y'); 
    a0 = 'Erro'; 
    a1 = 'Erro'; 
    % Calcula os termos com as somas da Eq. (6) 
else 
    Sx = sum(x); 
    Sy = sum(y); 
    Sxy = sum(x.*y); 
    Sxx = sum(x.^2); 
    % Calcula os coeficientes como na Eq. (7) 
    a1 = (nx*Sxy-Sx*Sy)/(nx*Sxx-Sx^2); 
    a0 = (Sxx*Sy - Sxy*Sx) / (nx*Sxx - (Sx)^2); 
    % Função e gráfico 
    YI = a1*XI + a0; 
    plot(XI,YI,'b',x,y,'g*'); 
    grid; 
    xlabel('x'); 
    ylabel('y'); 
    legend('Reta aproximada mín. quad.','Dados usados na interp.'); 
    fprintf ('y = %11.6f x + %11.6f \n', a1, a0); 
    % Conversão se houve linearização 
    if linearizar == 's' 
        fprintf ('Dada a linearização para \nf(x) = c*x^n => ln(f(x)) = ln(c) + n*ln(x) \n'); 
        n = a1; 
        c = a0; 
        fprintf ('ln(f(x)) = ln(%11.6f) + %11.6f ln(x) \n', c ,n); 
        fprintf ('f(x) = %11.6f *x^ %11.6f \n', c ,n); 
    end 
end 
 
end