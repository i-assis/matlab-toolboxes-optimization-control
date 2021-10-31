%% fc_lib_calcnum_fc_ode_Lorentz 
%%%%%%%%%%%%% 
% help fc_lib_calcnum_fc_ode_Lorentz 
% Belongs to private library 
%%%%%%%%%%%%% 
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC) 
% COPYRIGHT: Free for non evil use. (Não use este código para o mal) 
%%%%%%%%%%%%% 
% fc_lib_calcnum_fc_ode_Lorentz(x, t, p) 
% Função vetorial de exemplo para integrador numérico 
% x: vetor de estados 
% f: f(x) 
%%%%%%%%%%%%% 
% version 01: 30.10.2018 -- Creation 
%   01.06.2019 -- Notation update 
%%%%%%%%%%%%% Example 
% tsimu = 0:0.001:50; 
% q0 = [-5; -5; 20]; 
% s = 10; r = 20; b = 8/3; 
% [~,Y] = ode45(@(t,q)fc_lib_calcnum_fc_ode_Lorentz(t, q, s, r, b),tsimu,q0); 
% fc_lib_plot_temporal_plano_de_fase(tsimu,Y'); 
% % ==== 
% f = 'fc_lib_calcnum_fc_ode_Lorentz(t, x, 10, 20, 8/3)'; 
% y = fc_lib_calcnum_Integrador_num_RungeKutta_4(tsimu, q0, f); 
% fc_lib_plot_temporal_plano_de_fase(tsimu,y); 
%%%%%%%%%%%%% 
%% algorithm 
function f = fc_lib_calcnum_fc_ode_Lorentz(t, q, s, r, b) 
% q = [x, y, z]; 
f = [s*(q(2) - q(1)); 
    -q(1)*q(3) + r*q(1) - q(2); 
    q(1)*q(2) - b*q(3)]; 
end