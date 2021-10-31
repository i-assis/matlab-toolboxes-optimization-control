%% script_espectro_fase_FFT
%%%%%%
% help
%%%%%%
% Autor: M.Eng. Fernando Henrique G. Zucatelli (UFABC)
% Programa para PED - disciplina EM707
% 
% versão 01: 28.09.2017
%     Criação
%       Script para plotar FFT corretamente
%%%%%%
% xc(t) = 2*cos(2*25*pi*t) + (1/2)*cos(2*50*pi*t)
% x(t) contém 25 e 50Hz
% fa = 300; %Hz;
% fa > 2*max{f1,f2} = 2*50 = 100
% fa Satisfaz o teorema da Amostragem
%%%%%%
%% limpeza
clear all; close all; clc;
%% gráficos no tempo
fa = 300; %Hz
Ta = 1/fa; %s
t_c = 0:0.0005:0.2; % incremento de 0.01 para ser o mais próximo do contínuo
t_a = 0:Ta:0.2; % incremento no tempo da amostragem Ta = 1/fa
f1 = 25; f2 = 50; % destacando as frequências a serem amostradas
xc = 2*cos(2*f1*pi*t_c) + (1/2)*cos(2*f2*pi*t_c); %x contínuo
xa = 2*cos(2*f1*pi*t_a) + (1/2)*cos(2*f2*pi*t_a); %x amostrado fa
%% gráficos combinados na mesma figura
figure(1); hold all; grid on;
plot(t_c, xc, '-b'); %conecta pontos
stem(t_a, xa, 'r'); %marca os pontos
xlabel('t [s]'); ylabel('Sinais')
set(gcf,'Units','Normalized','Position',[0.15 0.08 0.75 0.75]); % ampliar a imagem
legend('x_c(t)', 'x_a(t)', 'Location', 'BestOutside');
% saveas(gcf, 'figura_marco_01', 'png');
%% gráfico alternativo ao stem
figure(2); hold all; grid on;
plot(t_c, xc, '-b'); %conecta pontos
plot(t_a, xa, 'ro'); %Apenas as marcas
xlabel('t [s]'); ylabel('Sinais')
set(gcf,'Units','Normalized','Position',[0.15 0.08 0.75 0.75]); % ampliar a imagem
legend('x_c(t)', 'x_a(t)', 'Location', 'BestOutside');
% saveas(gcf, 'figura_marco_02', 'png');
%% FFT - metade do espectro com frequência positiva
xa = ScopeData.signals.values(:,1)
Xa = fft(xa);
N = length(t_a); % total de elementos
Xa_abs = abs(Xa)/N; %norm é uma alternativa a abs
Xa_fas = phase(Xa); %angle é uma alternativa a phase
freq = [0:(N-1)]*(fa/(N-1)); % vetor de frequência
teto_freq = ceil(N/2); % limita a exibição as frequências.
freq = freq(1:teto_freq); % somente parte positiva
Xa_abs = Xa_abs(1:teto_freq);
Xa_fas = Xa_fas(1:teto_freq);
%% gráfico da FFT em duas partes
figure(3);
set(gcf,'Units','Normalized','Position',[0.15 0.08 0.75 0.75]); % ampliar a imagem
subplot(211); % posição superior (1) matriz 2x1
stem(freq, Xa_abs, 'b'); grid on;
title('Espectro | X_a(j2\pif) |');
v = axis; % pegando valor dos eixos
set(gca,'xtick',[0:v(2)/6:v(2)]); % valores dos eixos melhor divididos
xlabel('f [Hz]'); ylabel('Metade da amplitude');
subplot(212); % posição inferior (2) matriz 2x1
stem(freq, Xa_fas, 'b'); grid on;
title('Fase \phi(X_a(j2\pif))');
v = axis; % pegando valor dos eixos
set(gca,'xtick',[0:v(2)/6:v(2)]); % valores dos eixos melhor divididos
xlabel('f [Hz]'); ylabel('Fase [rad]');
% saveas(gcf, 'figura_marco_03', 'png');
%% FFT - Espectro com frequência positiva e amplitude completa
Xa = fft(xa);
N = length(t_a); % total de elementos
Xa_abs = abs(Xa)/N; %norm é uma alternativa a abs
Xa_fas = phase(Xa); %angle é uma alternativa a phase
freq = [0:(N-1)]*(fa/(N-1)); % vetor de frequência
teto_freq = ceil(N/2); % limita a exibição as frequências.
freq = freq(1:teto_freq); % somente parte positiva
freq_T = [-freq(end:-1:2), freq]; % frequências simétricas
Xa_abs = Xa_abs(1:teto_freq); %amplitudes positivas
Xa_abs_T = [Xa_abs(end:-1:2), Xa_abs]; %Gráfico de módulo é par
Xa_fas = Xa_fas(1:teto_freq);
Xa_fas_T = [-Xa_fas(end:-1:2), Xa_fas]; %Gráfico de fase é ímpar
%% gráfico da FFT com frequências negativas
figure(4);
set(gcf,'Units','Normalized','Position',[0.15 0.08 0.75 0.75]); % ampliar a imagem
subplot(211); % posição superior (1) matriz 2x1
stem(freq_T, Xa_abs_T, 'b'); grid on;
title('Espectro | X_a(j2\pif) |');
v = axis; % pegando valor dos eixos
set(gca,'xtick',[-v(2):v(2)/6:v(2)]); % valores dos eixos melhor divididos
xlabel('f [Hz]'); ylabel('Amplitude');
subplot(212); % posição inferior (2) matriz 2x1
stem(freq_T, Xa_fas_T, 'b'); grid on;
title('Fase \phi(X_a(j2\pif))');
v = axis; % pegando valor dos eixos
set(gca,'xtick',[-v(2):v(2)/6:v(2)]); % valores dos eixos melhor divididos
xlabel('f [Hz]'); ylabel('Fase [rad]');
% saveas(gcf, 'figura_marco_04', 'png');
%% Visualização da FFT sem correção
figure(5); grid on;
subplot(211); stem(abs(Xa));
subplot(212); stem(phase(Xa));
% saveas(gcf, 'figura_marco_05_ftt_pura_nao_corrigida', 'png');
%% Visualização da FFT com correção automática
% fftshift - não fica perfeito
y = fft(xa); ly = length(y);
y = abs(fftshift(y))/ly;
f = (-ly/2:ly/2-1)/ly*fa;
figure(6); grid on; hold on;
set(gcf,'Units','Normalized','Position',[0.15 0.08 0.75 0.75]); % ampliar a imagem
stem(f,y);
xlabel('Frequency (Hz)'); ylabel('|y|');
v = axis; % pegando valor dos eixos
set(gca,'xtick',[-v(2):v(2)/6:v(2)]); % valores dos eixos melhor divididos
