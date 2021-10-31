%% fc_lib_calcnum_SerieFourier_FenomGibbs_LacoPlot 
%%%%%%%%%%%%% 
% help fc_lib_calcnum_SerieFourier_FenomGibbs_LacoPlot 
% Belongs to private library 
%%%%%%%%%%%%% 
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC) 
% COPYRIGHT: Free for non evil use. (Não use este código para o mal) 
%%%%%%%%%%%%% 
% fc_lib_calcnum_SerieFourier_FenomGibbs_LacoPlot(F, S, m, a0, x, flag_plot) 
% Funcao para chamar cálculo numérico da aproximação S da série de Fourier 
% trigonométrica de uma função e gerar os gráficos 
% F: F = F(x), função original para comparação 
% S: S = S(n,x) os coef. do somatório da série de Fourier trigonométrica 
% a0: Parâmetro que não depende do somatório 
% m: vetor com os limites superiores da série 
% X: Vetor das abscissa 
% flag_plot: flag para exibir os gráficos 
% Y: saída com resultados da série para cada m(i) 
%%%%%%%%%%%%% 
% version 01: 03.11.2018 
%     Criação 
%%%%%%%%%%%%% Example 
% F = @(x)(pi*x); 
% a0 = 0 
% % an = @(n)(0*n); 
% an = 0 
% bn = @(n)(4/n^2*sin(n*pi/2) - 2*pi/n*cos(n*pi/2)); 
% % L = 2*pi; c = pi/L 
% c = 2; 
% %S = @(n,x)(an(n)*cos(n*x/c) + bn(n)*sin(n*x/c)); % Forma geral 
% S = @(n,x)(bn(n)*sin(n*x/c)); 
% x0 = -pi; h = 0.05; xf = pi; 
% x = [x0:h:xf]; 
% m = [1, 5, 10, 25, 50, 100, 200, 400, 800]; % m = [100]; 
% flag_plot = 1; 
% Y = fc_lib_calcnum_SerieFourier_FenomGibbs_LacoPlot(F, S, a0, m, x, flag_plot); 
%%%%%%%%%%%%% 
%% algorithm 
function Y = fc_lib_calcnum_SerieFourier_FenomGibbs_LacoPlot(F, S, a0, m, x, flag_plot) 
M = length(m); 
Y = zeros(length(x),M); 
for i = 1:M 
    y = fc_lib_calcnum_SerieFourier_FenomGibbs_nucleo(S, a0, m(i), x); 
    Y(:,i) = y; 
end 
%% figuras 
if flag_plot == 1 
    legendtext = 'F'; 
    figure; grid on; hold all; 
    plot(x,F(x),'k--','LineWidth',1.5); 
    for i = 1:M 
        plot(x,Y(:,i)); 
        legendtext = char(legendtext, sprintf('f_{%d}',m(i)) ); 
    end 
    xlabel('x'); ylabel('y = f_n(x)'); 
    titulo = sprintf('f(x) = %s',F(sym('x'))); 
    titulo = strrep(titulo,'*','\cdot'); 
    title(sprintf('Fenômeno de Gibbs da Série de Fourier: %s', titulo)); 
    legend(legendtext, 'Location','BestOutside'); 
    set(gcf,'Units','Normalized','Position',[0.0490, 0.1549, 0.7116, 0.7305]); 
end 
end