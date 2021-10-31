%% fc_lib_calcnum_Integrador_num_Euler 
%%%%%%%%%%%%% 
% help fc_lib_calcnum_Integrador_num_Euler 
% Belongs to private library 
%%%%%%%%%%%%% 
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC) 
% COPYRIGHT: Free for non evil use. (N�o use este c�digo para o mal) 
%%%%%%%%%%%%% 
% fc_lib_calcnum_Integrador_num_Euler(t,x0,f) 
% Funcao para integrador num�rico por Euler 
% t: vetor de tempo 
% x0: vetor de condi��es iniciais 
% f: nome da fun��o a ser integrada 
%%%%%%%%%%%%% 
% version 01: 29.10.2018 
%     Cria��o 
% Fun��o de integra��o num�rica por Euler 
% 
% Vari�veis de entrada: 
% t   : tempo da integra��o, vari�vel independente 
% f   : x_dot(t) = f( x(t) ) fun��o do sistema din�mico 
% x   : vetor com as coordenadas x dos pontos 
% x0  : pt inicial 
% h   : passo de integra��o 
% 
% nota��o x_i = x(t_i) ; f_i(x_i) = f( x(t_i) ) 
% x_dot_i = f( x(t_i) ) 
% x_{i+1} = x_i + h * f_i 
%%%%%%%%%%%%% Example 01 
% tsimu = linspace(0,20,100); 
% x0 = [10; 5; 1]; 
% f = 'fc_lib_calcnum_fc_ode_generica_01(x,t)'; 
% x = fc_lib_calcnum_Integrador_num_Euler(tsimu, x0, f); 
% fc_lib_plot_temporal_plano_de_fase(tsimu,x); 
% % === compara��o com ode 
% [~,y] = ode45(@(t,q)fc_lib_calcnum_fc_ode_generica_01(q,t),tsimu,x0); 
% fc_lib_plot_temporal_plano_de_fase(tsimu,y'); 
%%%%%%%%%%%%% Example 02 
% tsimu = linspace(0,20,100); 
% x0 = [0.5; 0.4]; 
% % fc_lib_calcnum_fc_ode_van_der_pool(x,t, mu) 
% f = 'fc_lib_calcnum_fc_ode_van_der_pool(x,t, -0.5)'; % mu = -0.5 
% x = fc_lib_calcnum_Integrador_num_Euler(tsimu, x0, f); 
% fc_lib_plot_temporal_plano_de_fase(tsimu,x); 
% % === compara��o com ode 
% [~,y] = ode45(@(t,q)fc_lib_calcnum_fc_ode_van_der_pool(q,t, -0.5),tsimu,x0); 
% fc_lib_plot_temporal_plano_de_fase(tsimu,y'); 
%%%%%%%%%%%%% Example 03 
% t = linspace(0,20,100); 
% x0 = [0.5; 0.4; 0]; % == [x1, x2, t]; 
% % h = t(2) - t(1); 
% % fc_lib_calcnum_fc_ode_duffing(x,t, alpha, beta, gamma, omega, h) 
% f = 'fc_lib_calcnum_fc_ode_duffing(x,t, 1, 1, 1, 1, 0.2020)'; 
% x = fc_lib_calcnum_Integrador_num_Euler(tsimu, x0, f); 
% fc_lib_plot_temporal_plano_de_fase(tsimu,x); 
% % === compara��o com ode 
% [~,y] = ode45(@(t,q)fc_lib_calcnum_fc_ode_duffing(q,t, 1, 1, 1, 1, 0.2020),tsimu,x0); 
% fc_lib_plot_temporal_plano_de_fase(tsimu,y'); 
%%%%%%%%%%%%% 
%% algorithm 
function x = fc_lib_calcnum_Integrador_num_Euler(t, x0, f) 
Nx = max(size(x0)); 
nt = size(t); 
% Garantir as dimens�es 
if nt(1) < nt(2) 
    t = t'; 
end 
% criar vetor x igual a t 
x = zeros(Nx,max(nt)); 
x(:,1) = x0; 
% criar vetor do passo h 
h = zeros(nt); 
for i = 2:max(nt) 
    h(i-1) = t(i) - t(i-1); 
end 
%% Definir function handle conforme nome informado 
F = eval(sprintf('@%s%s','(x)',f)); 
%% Passo de integra��o de Euler 
for i = 1:(max(nt)-1) 
    x(:,i+1) = x(:,i) + h(i)*F(x(:,i)); 
end 
end 
%% 
%%%%%%%%%%%%% 
% x(:,i+1) = x(:,i) + h(i) * fc_lib_calcnum_fc_ode_generica_01(x(:,i)); 
% x(:,i+1) = x(:,i) + h(i) * fc_lib_calcnum_fc_ode_van_der_pool(x(:,i),-0.5); 
% x(:,i+1) = x(:,i) + h(i) * fc_lib_calcnum_exemp_num_fc_duffing([x(:,i); t(i)], 1,1,1,1); 
%%%%%%%%%%%%%