%% fc_lib_calcnum_ElimGauss_Jordan_Inversa 
%%%%%%%%%%%%% 
% help fc_lib_calcnum_ElimGauss_Jordan_Inversa 
% Belongs to private library 
%%%%%%%%%%%%% 
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC) 
% COPYRIGHT: Free for non evil use. (Não use este código para o mal) 
%%%%%%%%%%%%% 
% fc_lib_calcnum_ElimGauss_Jordan_Inversa(A,b) 
% Funcao para calcular a inversa de uma matriz 
% usando a fatoração LU 
% A: matriz dada 
% b: coeficientes do sistema 
% M: recebe A e b para resolver o sistema 
% U: recebe A para se tornar Upper 
% L: recebe identidade com L linhas de A e é trabalhada até ser Lower 
% p: recebe identidade e sofre as permutações. 
% I: recebe U para se tornar a Identidade 
% Z: recebe L quando U é Upper para se tornar inversa 
%%%%%%%%%%%%% 
% version 01: 04.04.2018 
%     Criação 
%%%%%%%%%%%%% Example 
% A = randi(10,3,3) 
% b = randi(10,3,1) 
% [L, U, P, X, inv_A] = ElimGauss_Jordan_Inversa(A,b) 
%%%%%%%%%%%%% 
%% algorithm 
function [L, U, P, X, Z] = fc_lib_calcnum_ElimGauss_Jordan_Inversa(A,b) 
M = [A, b]; 
[Lm, Cm] = size(M); 
L = eye(Lm); 
P = eye(Lm); 
U = A; 
%pivotiamento para M, p e U 
for i = 1:Lm-1 
    [el_max, pos_max] = max(abs(A(i,:))); 
    if (el_max ~=  0) 
        if (el_max ~=  M(i,1)) 
            M_temp = M(i,:); 
            M(i,:) = M(pos_max,:); 
            M(pos_max,:) = M_temp; 
            P_temp = P(i,:); 
            P(i,:) = P(pos_max,:); 
            P(pos_max,:) = P_temp; 
            U_temp = U(i,:); 
            U(i,:) = U(pos_max,:); 
            U(pos_max,:) = U_temp; 
        end 
    else 
        fprintf('Matriz é singular\n'); 
        return; 
    end 
end 
% Eliminação de Gauss 
for i = 1:Lm-1 
    for j = i+1:Lm 
        m = M(j,i)/M(i,i); 
        M(j,:) = M(j,:) - m*M(i,:); 
        U(j,:) = U(j,:) - m*U(i,:); 
        L(j,i) = m; %Esta já é a inv(Lo) pois Lo teria -m 
    end 
end 
%resolução do sistema para M = [A b] 
X = zeros(Lm,1); 
X(Lm) = M(Lm,Cm)/M(Lm,Lm); 
for j = Lm-1:-1:1 
    X(j) = (M(j,Cm) - M(j,j+1:Lm) * X(j+1:Lm))/M(j,j); 
end 
%U é Upper e L é lower 
%Parte de Jordan para identificar Inversa Z a partir da Lower L 
I = eye(Lm); 
L_Aux = L; 
for i = 1:Lm 
    for j = i+1:Lm 
        m = L_Aux(j,i)/L_Aux(i,i); 
        L_Aux(j,:) = L_Aux(j,:) - m*L_Aux(i,:); 
        I(j,:) = I(j,:) - m*I(i,:); 
    end 
end 
y = I*P; % A = P'*L*U  = > U*inv(A) = inv(L)*P = I*P  = > UZ = y 
Z = zeros(Lm); 
for i = 1:Lm 
    M = [U y(:,i)]; 
    [Lm, Cm] = size(M); 
    z1 = zeros(Lm,1); %matriz coluna 
    z1(Lm) = M(Lm,Cm)/M(Lm,Lm); 
    for j = Lm-1:-1:1 
        z1(j) = (M(j,Cm) - M(j,j+1:Lm) * z1(j+1:Lm))/M(j,j); 
    end 
    Z (:,i) = Z(:,i) + z1; 
end