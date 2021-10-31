%% fc_lib_calcnum_SerieFourier_FenomGibbs_nucleo 
%%%%%%%%%%%%% 
% help fc_lib_calcnum_SerieFourier_FenomGibbs_nucleo 
% Belongs to private library 
%%%%%%%%%%%%% 
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC) 
% COPYRIGHT: Free for non evil use. (N�o use este c�digo para o mal) 
%%%%%%%%%%%%% 
% fc_lib_calcnum_SerieFourier_FenomGibbs_nucleo(S, a0, N, X) 
% Funcao para calcular numericamente a aproxima��o S da s�rie de Fourier 
% trigonom�trica de uma fun��o 
% S: S = S(n,x) os coef. do somat�rio da s�rie de Fourier trigonom�trica 
% a0: Par�metro que n�o depende do somat�rio 
% N: Limite superior do somat�rio - Fen�meno de Gibbs 
% X: Vetor das abcssicas 
%%%%%%%%%%%%% 
% version 01: 03.11.2018 
%     Cria��o 
%%%%%%%%%%%%% Example 
% a0 = 0 
% % an = @(n)(0*n); 
% an = 0 
% bn = @(n)(4/n^2*sin(n*pi/2) - 2*pi/n*cos(n*pi/2)); 
% % L = 2*pi; c = pi/L 
% c = 2; 
% %S = @(c,n,x)(an(n)*cos(n*x/c)+bn(n)*sin(n*x/c)) 
% S = @(c,n,x)(bn(n)*sin(n*x/c)); 
% N = 10; 
% x0 = -pi; h = 0.05; xf = pi; 
% x = [x0:h:xf]; 
% y = fc_lib_calcnum_SerieFourier_FenomGibbs_nucleo(S, a0, N, x); 
%%%%%%%%%%%%% 
%% algorithm 
function y = fc_lib_calcnum_SerieFourier_FenomGibbs_nucleo(S, a0, N, x) 
l = length(x); 
y = zeros(l,1); 
for i = 1:N 
    for j = 1:l 
        y(j) = y(j) + S(i,x(j)); 
    end 
end 
y = y + (a0)/2; 
%% figuras 
% dkg = [0 0.5 0]; % Dark Green 
% figure; grid on; hold all; 
% plot(X0,Y0,'k--','LineWidth',1.5); 
% plot(X,Y,'b'); 
% plot(X,Y1,'r'); 
% plot(X,Y2,'c'); 
% plot(X,Y3,'Color',dkg); 
% xlabel('x'); ylabel('y = f_n(x)'); 
% title('Fen�meno de Gibbs da S�rie de Fourier') 
% l1 = sprintf('f_{%d}',m0); 
% l2 = sprintf('f_{%d}',m1); 
% l3 = sprintf('f_{%d}',m2); 
% l4 = sprintf('f_{%d}',m3); 
% legend('F', l1, l2, l3, l4,'Location','Best'); 
 
end