%% fc_lib_calcnum_Interpolacao_Plot_Exemplo 
%%%%%%%%%%%%% 
% help fc_lib_calcnum_Interpolacao_Plot_Exemplo 
% Belongs to private library 
%%%%%%%%%%%%% 
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC) 
% COPYRIGHT: Free for non evil use. (Não use este código para o mal) 
%%%%%%%%%%%%% 
% fc_lib_calcnum_Interpolacao_Plot_Exemplo(x,y,t,z) 
% y(x); z(t) 
% Funções exemplo para ajudar a memória no futuro. 
% x = linspace(-10,1,100); 
% y = 5*x.^3-8*x.^2+20*x; 
% t = [-7 -5 -3]; 
% z = 5*t.^3-8*t.^2+20*t; 
%%%%%%%%%%%%% 
% version 01: 04.04.2018 
%     Criação 
%%%%%%%%%%%%% Example 
% x = [0 1 2 3 4 5]; 
% y = [1.0000    0.3679    0.0183    0.0001    0.0000    0.0000]; 
% Xint = [0 1 2 3 4 5]; 
% fc_lib_calcnum_Interpolacao_Plot_Exemplo(x,y,t,z) 
%%%%%%%%%%%%% 
%% algorithm 
function fc_lib_calcnum_Interpolacao_Plot_Exemplo(x,y,t,z) 
for int = 1:length(x) 
    Xint = x(int); 
    Yint(int) = LagrangeINT(t,z,Xint); 
end 
plot(x,y,x,Yint,'r',t,z,'*'); grid; 
xlabel('t'); ylabel('z'); 
legend('Valores exatos', 'Polinômio de Lagrange', 'Dados usados na interp.'); 
end