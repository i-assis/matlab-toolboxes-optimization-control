%% fc_lib_calcnum_Integrador_num_Euler_pts 
%%%%%%%%%%%%% 
% help fc_lib_calcnum_Integrador_num_Euler_pts 
% Belongs to private library 
%%%%%%%%%%%%% 
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC) 
% COPYRIGHT: Free for non evil use. (Não use este código para o mal) 
%%%%%%%%%%%%% 
% fc_lib_calcnum_Integrador_num_Euler_pts(t,x0,f) 
% Funcao para integrador numérico por Euler 
% t: vetor de tempo 
% x0: vetor de condições iniciais 
% f: pontos da função a ser integrada 
%%%%%%%%%%%%% 
% version 01: 14.05.2019 -- Creation 
%   Variation of the function: 
%       fc_lib_calcnum_Integrador_num_Euler_pts 
%   Função de integração numérica por Euler utilizando os pontos de f 
%       em vez da função escrito 
% 
% Variáveis de entrada: 
% t   : tempo da integração, variável independente 
% f   : x_dot(t) = f( x(t) ) pontos da função do sistema dinâmico 
% x   : vetor com as coordenadas x dos pontos 
% x0  : pt inicial 
% h   : passo de integração 
% 
% notação x_i = x(t_i) ; f_i(x_i) = f( x(t_i) ) 
% x_dot_i = f( x(t_i) ) 
% x_{i+1} = x_i + h * f_i 
%%%%%%%%%%%%% Example 01 
% tsimu = [0,1,2]; 
% x0 = [10; 5; 1]; 
% f = [ [1;1;1],[2;4;6],[3;6;10]]; 
% x = fc_lib_calcnum_Integrador_num_Euler_pts(tsimu, x0, f); 
% fc_lib_plot_temporal_plano_de_fase(tsimu,x'); 
%%%%%%%%%%%%% Example 02 
% tsimu = linspace(0,20,100); 
% x0 = [0.5; 0.4]; 
% f = [exp(-tsimu); exp(-2*tsimu)]; 
% x = fc_lib_calcnum_Integrador_num_Euler_pts(tsimu, x0, f); 
% fc_lib_plot_temporal_plano_de_fase(tsimu,x); 
%%%%%%%%%%%%% Example 03 
% tsimu = linspace(0,1,21); 
% x0 = 1; 
% f = 2*ones(size(tsimu)); 
% x = fc_lib_calcnum_Integrador_num_Euler_pts(tsimu, x0, f); 
% fc_lib_plot_temporal_plano_de_fase(tsimu,x); 
% y = fc_lib_calcnum_Integrador_num_Euler_pts(tsimu, x0, x); 
% fc_lib_plot_temporal_plano_de_fase(tsimu,y); 
%%%%%%%%%%%%% 
%% algorithm 
function x = fc_lib_calcnum_Integrador_num_Euler_pts(t, x0, f) 
Nx = max(size(x0)); 
nt = size(t); 
% Garantir as dimensões 
if nt(1) < nt(2) 
    t = t'; 
end 
% criar vetor x de tamanho igual a t 
x = zeros(Nx,max(nt)); 
x(:,1) = x0; 
% criar vetor do passo h 
h = zeros(nt); 
for i = 2:max(nt) 
    h(i-1) = t(i) - t(i-1); 
end 
%% Passo de integração de Euler 
for i = 1:(max(nt)-1) 
    x(:,i+1) = x(:,i) + h(i)*f(:,i); %F(x(:,i)); 
end 
end