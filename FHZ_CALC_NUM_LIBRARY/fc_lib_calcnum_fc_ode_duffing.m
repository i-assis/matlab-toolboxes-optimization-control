%% fc_lib_calcnum_fc_ode_duffing 
%%%%%%%%%%%%% 
% help fc_lib_calcnum_fc_ode_duffing 
% Belongs to private library 
%%%%%%%%%%%%% 
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC) 
% COPYRIGHT: Free for non evil use. (Não use este código para o mal) 
%%%%%%%%%%%%% 
% fc_lib_calcnum_fc_ode_duffing(x, alpha, beta, gamma, omega) 
% Função vetorial de exemplo para integrador numérico 
% x: vetor de estados 
% f: f(x) 
% \ddot{z} + \delta \dot{z} + \alpha z + \beta z^3 = \gamma \cos (\omega t) 
% y == [z, \dot{z}]; 
% x == [y1, y2, t]; 
% \dot{x} == [\dot{y}_1, \dot{y}_2, h]; 
%%%%%%%%%%%%% 
% version 01: 30.10.2018 -- Creation 
%   01.06.2019 -- Notation update 
%%%%%%%%%%%%% Example 
% tsimu = 0:0.1:12; 
% q0 = [0.5; 0.4; 0]; 
% alpha = 1; beta = 1; gamma = 1; omega = 1; h = 0.1; 
% [~,Y1] = ode45(@(t,q)fc_lib_calcnum_fc_ode_duffing(q,t, alpha, beta, gamma, omega, h),tsimu,q0); 
% figure; plot(tsimu,Y1); grid on; 
% % ==== 
% f = 'fc_lib_calcnum_fc_ode_duffing(x,t, 1, 1, 1, 1, 0.2020)'; 
% y = fc_lib_calcnum_Integrador_num_Euler(tsimu, q0, f); 
% fc_lib_plot_temporal_plano_de_fase(tsimu,y); 
%%%%%%%%%%%%% 
%% algorithm 
function f = fc_lib_calcnum_fc_ode_duffing(x,t, alpha, beta, gamma, omega, h) 
f(1,1) = x(2); 
f(2,1) = gamma*cos(omega * x(3)) - gamma*x(2) - alpha*x(1) - beta*x(1)^3; 
f(3,1) = h; 
end