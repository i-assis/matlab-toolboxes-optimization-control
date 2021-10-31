%% fc_lib_calcnum_fc_ode_van_der_pool 
%%%%%%%%%%%%% 
% help fc_lib_calcnum_fc_ode_van_der_pool 
% Belongs to private library 
%%%%%%%%%%%%% 
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC) 
% COPYRIGHT: Free for non evil use. (N�o use este c�digo para o mal) 
%%%%%%%%%%%%% 
% fc_lib_calcnum_fc_ode_van_der_pool(x) 
% Fun��o vetorial de exemplo para integrador num�rico 
% x: vetor de estados 
% f: f(x) 
%%%%%%%%%%%%% 
% version 01: 30.10.2018 -- Creation 
%   01.06.2019 -- Notation update 
%%%%%%%%%%%%% Example 
% tsimu = 0:0.1:12; 
% q0 = [0.5; 0.4]; 
% [~,Y1] = ode45(@(t,q)fc_lib_calcnum_fc_ode_van_der_pool(q,t, -0.5),tsimu,q0); 
% figure; plot(tsimu,Y1); grid on; 
% % ==== 
% f = 'fc_lib_calcnum_fc_ode_van_der_pool(x,t, -0.5)'; % mu = -0.5 
% y = fc_lib_calcnum_Integrador_num_Euler(tsimu, q0, f); 
% fc_lib_plot_temporal_plano_de_fase(tsimu,y); 
%%%%%%%%%%%%% 
%% algorithm 
function f = fc_lib_calcnum_fc_ode_van_der_pool(x,t, mu) 
f = [x(2)           ;... 
     mu*x(2)*(1-x(1)^2) - x(1)]; 
end