%% avulso_espectro_fase_FFT
% %%%%%%%%%%%%%%%%%%%%
% Help
% %%%%%%%%%%%%%%%%%%%%
% Author: Fernando Henrique G. Zucatelli (UFABC - Brazil)
% COPYRIGHT: Free for non evil use. (Não use este código para o mal)
% %%%%%%%%%%%%%%%%%%%%
% 
% Code to plot Fourier Spectrum of a signal f and its phase diagram
% Options: 
%   Fs_1 = 1:
%       Give Fs or Ts = 1 / Fs, creates t_vetor and calculate N samples
%   Fs_1 = 0:
%       Give N samples, creates t_vetor and calculate Fs sample rate/frequency
%
% %%%%%%%%%%%%%%%%%%%% Fast Fourier Transform Matlab
% Source: https://www.mathworks.com/help/matlab/ref/fft.html
% %%%%%%%%%%%%%%%%%%%%
% ----- End Help

%% cleaning
clear; close all; clc;

% ----- função estudada
% --- Maiquer
%{
g1 = inline('10*cos(t/2)');
g2 = inline('5*cos(t/4)');
f = inline('10*cos(t/2) + 5*cos(t/4)'); % uma das formas de se escrever funções
% f deve ter raias nas frequências aproximadas de:
% w_1 = 1/2, w_2 = 1/4;
% freq_1 = w_1 / (2pi) \approx 0,08
% freq_2 = w_2 / (2pi) \approx 0,04
% amp_1 = 10/2 = 5; amp_2 = 5/2 = 2,5 % Escrever como exponencial complexa
% ------
w1 = 1/2, w2 = 1/4; T1 = 4pi, T2 = 8pi
p,q inteiro
T = p*T1 = q*T2 => p = 2, q = 1
T = 8pi
w_0 = 1/4, fs = 1 / (8pi)
%}

% --- Arlete
%{
% g1 = inline('1');
% g2 = inline('3*sin(4*pi*t)');
% f = inline('1 + 3*sin(4*pi*t)');
%}

% ----- exemplo simples de ver se resultado está coerente
%%{
% g1 = inline('1*cos(1*2*pi*t)'); % uma raia em f = 1
% g2 = inline('1*cos(2*2*pi*t)'); % uma raia em f = 2
% f = inline('1*cos(2*2*pi*t) + 1*cos(4*2*pi*t)'); % uma raia em f = 2 e outra f = 4
f = inline('2*cos(2*25*pi*t) + (1/2)*cos(2*50*pi*t)');
% ----- a f a seguir não ficará correta para Fs_1 = 0, porque 512 amostras não
% respeita o Teorema da Amostragem devido à frequência de 300 Hz.
% Para correta amostragem a Fs > 2*300 = 600 Hz.
% Necessita de N = 2^15 para as frequências aparecem corretamente
% f = inline('sin(20*2*pi*t) + 2*sin(50*2*pi*t) + 20*sin(200*2*pi*t) + 40*sin(300*2*pi*t)');
%}
% --- opção de seleção
Fs_1 = 1;
t_final = 0.2;
% ---
if Fs_1 == 1
    % ---- Dado Fs
    % Fs = 1000; % frequencia de amostragem, Teo da amostragem de Shannon-Nyquist, et. al.
    % Fs = 10;
    % Fs = 300;
    Fs = 1500;
    %Ts = 0.25; %Fs = 4
    %Fs = 1/Ts;
    t_vetor = 0:1/Fs:t_final;
    N = length(t_vetor);
else
    % ---- Dado N
    N = 512; % N = 2^15;
    t_vetor = linspace(0,t_final, N); % 1/Fs garante a amostragem correta
    Fs = N / t_final;
end
k = 0:(N-1);
T = (N-1)/Fs; % O período considera o total de dados e o tempo de amostragem
freq = k/T; % vetor para eixo abscissas na frequência
% --- limite de exibição das frequências no gráfico do espectro
teto_freq = ceil(N/2); % limita a exibição as frequências.
% teto_freq = N;
% teto_freq = 10; % número de pontos sobre o eixo, não são os valores

% -- funções de t
f_vetor = f(t_vetor);
% g1_vetor = g1(t_vetor);
% g2_vetor = g2(t_vetor);

% -- trafo de fourier
F_trafo = fft(f_vetor)/N;
% F_trafo = fftn(f_vetor)/N; %normalizada
abs_F_trafo = abs(F_trafo); fas_F_trafo = angle(F_trafo);
abs_F_trafo = abs_F_trafo(1:teto_freq); fas_F_trafo = fas_F_trafo(1:teto_freq);
freq = freq(1:teto_freq);

% ======== figuras
% figure;
% plot(t_vetor, g1_vetor, 'r--', t_vetor, g2_vetor, 'b--', t_vetor, f_vetor, 'k');
% grid on; legend('g_1(t)', 'g_2(t)', 'f(t)', 'Location', 'Best');
% title('Sinal f(t) = g_1(t) + g_2(t) domínio do tempo');
% xlabel('Tempo (s)'); % ylabel('Amplitude');

figure;
plot(t_vetor, f_vetor, 'k'); grid on;
title('Sinal f(t) domínio do tempo');
xlabel('Tempo (s)'); ylabel('Amplitude');

figure;
% stem(t_vetor, f_vetor, 'k');
plot(t_vetor, f_vetor, 'ko');
grid on;
title('Sinal f(t) domínio do tempo amostrado');
xlabel('Tempo (s)'); ylabel('Amplitude');

% --- figuras espectro
figure;
subplot(211);
% plot(abs_F_trafo);
stem(freq, abs_F_trafo, 'k'); % melhor para ver as raias em cada frequência
grid on;
title('Espectro de frequências | F(j2\pif) |');
xlabel('Frequências (Hz)'); ylabel('Amplitude');
%figure
subplot(212);
% plot(fas_F_trafo);
stem(freq, fas_F_trafo, 'k');
grid on;
title('Fase de frequências \phi(j2\pif)');
xlabel('Frequências (Hz)'); ylabel('Fase (rad/s)')


%% Fim