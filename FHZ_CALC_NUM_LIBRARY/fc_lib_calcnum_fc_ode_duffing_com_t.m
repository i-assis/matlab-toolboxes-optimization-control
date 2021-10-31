%% fc_lib_calcnum_fc_ode_duffing_com_t 
%%%%%%%%%%%%% 
% help fc_lib_calcnum_fc_ode_duffing_com_t 
% Belongs to private library 
%%%%%%%%%%%%% 
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC) 
% COPYRIGHT: Free for non evil use. (Não use este código para o mal) 
%%%%%%%%%%%%% 
% fc_lib_calcnum_fc_ode_duffing_com_t(x, alpha, beta, gamma, omega) 
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
% q0 = [0.5; 0.4]; 
% alpha = 1; beta = 1; gamma = 1; omega = 1; h = 0.1; 
% [~,Y1] = ode45(@(t,q)fc_lib_calcnum_fc_ode_duffing_com_t(q,t, alpha, beta, gamma, omega),tsimu,q0); 
% figure; plot(tsimu,Y1); grid on; 
%%%%%%%%%%%%% 
%% algorithm 
function f = fc_lib_calcnum_fc_ode_duffing_com_t(x,t, alpha, beta, gamma, omega) 
f(1,1) = x(2); 
f(2,1) = gamma*cos(omega * t) - gamma*x(2) - alpha*x(1) - beta*x(1)^3; 
end