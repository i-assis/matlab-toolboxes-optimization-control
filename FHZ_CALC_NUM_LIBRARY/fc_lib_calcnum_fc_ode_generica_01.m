%% fc_lib_calcnum_fc_ode_generica_01 
%%%%%%%%%%%%% 
% help fc_lib_calcnum_fc_ode_generica_01 
% Belongs to private library 
%%%%%%%%%%%%% 
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC) 
% COPYRIGHT: Free for non evil use. (Não use este código para o mal) 
%%%%%%%%%%%%% 
% fc_lib_calcnum_fc_ode_generica_01(x) 
% Função vetorial de exemplo para integrador numérico 
% x: vetor de estados 
% f: f(x) 
%%%%%%%%%%%%% 
% version 01: 30.10.2018 -- Creation 
%   01.06.2019 -- Notation update 
%%%%%%%%%%%%% Example 
% tsimu = 0:0.1:12; 
% q0 = [10; 5; 1]; 
% [~,Y1] = ode45(@(t,q)fc_lib_calcnum_fc_ode_generica_01(q,t),tsimu,q0); 
% figure; plot(tsimu,Y1); grid on; 
% % ==== 
% f = 'fc_lib_calcnum_fc_ode_generica_01(x,t)'; 
% y = fc_lib_calcnum_Integrador_num_Euler(tsimu, q0, f); 
% fc_lib_plot_temporal_plano_de_fase(tsimu,y); 
%%%%%%%%%%%%% 
%% algorithm 
function dx = fc_lib_calcnum_fc_ode_generica_01(x,t) 
dx = [x(2)           ;... 
     -x(2)-x(1)     ;... 
     -x(3)-2*x(1)   ]; 
end