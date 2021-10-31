%% fc_lib_calcnum_Interpolacao_Newton 
%%%%%%%%%%%%% 
% help fc_lib_calcnum_Interpolacao_Newton 
% Belongs to private library 
%%%%%%%%%%%%% 
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC) 
% COPYRIGHT: Free for non evil use. (N�o use este c�digo para o mal) 
%%%%%%%%%%%%% 
% fc_lib_calcnum_Interpolacao_Newton 
% NewtonINT ajusta um polin�mio de Newton a um dado conjunto de pontos e 
% usa esse polin�mio para determinar o valor interpolado de um ponto. 
% Vari�veis de entrada: 
% x Vetor com as coordenadas x dos pontos dados 
% y Vetor com as coordenadas y dos pontos dados 
% Xint Coordenada x do ponto a ser interpolado 
% Vari�vel de sa�da: 
% Yint O valor interpolado de Xint. 
%%%%%%%%%%%%% 
% version 01: 04.04.2018 
%     Cria��o 
%%%%%%%%%%%%% Example 
% x = [0 1 2 3 4 5]; 
% y = [1.0000    0.3679    0.0183    0.0001    0.0000    0.0000]; 
% Xint = [0 1 2 3 4 5]; 
% I = fc_lib_calcnum_Interpolacao_Newton(x,y,Xint) 
%%%%%%%%%%%%% 
%% algorithm 
function Yint = fc_lib_calcnum_Interpolacao_Newton(x,y,Xint) 
n = length(x); %Comprimento do vetor x fornece o n�mero de coeficientes 
%(e termos) do polin�mio 
a(1) = y(1); % Primeiro coeficiente a1 
for i = 1:n-1, %Calcula as diferen�as divididas de ordem 1 
    %Elas s�o armazenadas na 1a coluna de divDIF 
    divDIF(i,1) = ( y(i+1)-y(i) )/ ( x(i+1)-x(i) ); 
end 
for j = 2:n-1, %Calcula as diferen�as divididas de ordem 2 at� (n-1) 
    %Elas s�o armazenadas nas colunas de divDIF 
    for i = 1:n-j, 
        divDIF(i,j) = (divDIF(i+1,j-1)-divDIF(i,j-1))/(x(j+i)-x(i)); 
    end 
end 
for j = 2:n, %Atribui os coeficientes a2 a an ao vetor a 
    a(j) = divDIF(1,j-1); 
end 
%Calcula o valor interpolado de Xint 
Yint = a(1); 
xn=1; 
for k = 2:n, 
    xn = xn*(Xint-x(k-1)); 
    Yint = Yint + xn*a(k); 
end 
 
end