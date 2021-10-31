%% fc_lib_calcnum_Integral_Simpson_XY 
%%%%%%%%%%%%% 
% help fc_lib_calcnum_Integral_Simpson_XY 
% Belongs to private library 
%%%%%%%%%%%%% 
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC) 
% COPYRIGHT: Free for non evil use. (Não use este código para o mal) 
%%%%%%%%%%%%% 
% fc_lib_calcnum_Integral_Simpson_XY(X,Y) 
%%%%%%%%%%%%% 
% version 01: 04.04.2018 -- Creation 
%%%%%%%%%%%%% Example 
% X = [0 1 2 3 4 5 6]; 
% Y = [1.0000    0.3679    0.0183    0.0001    0 0 0]; 
% I = fc_lib_calcnum_Integral_Simpson_XY(X,Y) 
% plot (X,Y,'r'); grid on; 
%%%%%%%%%%%%% 
%% algorithm 
function I = fc_lib_calcnum_Integral_Simpson_XY(X,Y) 
%X : vetor com os pts da abscissas; 
%Y : vetor com os resultados de f(X) ou pts experimentais; 
n = length(X)-1; 
m = length(Y); 
I = 0; 
if (n+1) == m 
    if mod(n,2) == 0 
        for i = 2:2:n 
            I = I + ( ((X(i)-X(i-1)))/3 * (Y(i-1) + 4*Y(i) + Y(i+1)) ); 
        end 
    else 
        fprintf('# pts do intervalo deve ser ímpar'); 
    end 
else 
    fprintf('Vetores com tamanhos diferentes'); 
end 
end 
%%%% 
%for i = 1:((n)/2) 
%    I = I + ( ((X(2*i)-X(2*i-1)))/3 * (Y(2*i-1) + 4*Y(2*i) + Y(2*i+1)) ); 
%end 
%%%%