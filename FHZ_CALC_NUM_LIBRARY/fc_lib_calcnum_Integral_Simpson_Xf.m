%% fc_lib_calcnum_Integral_Simpson_Xf 
%%%%%%%%%%%%% 
% help fc_lib_calcnum_Integral_Simpson_Xf 
% Belongs to private library 
%%%%%%%%%%%%% 
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC) 
% COPYRIGHT: Free for non evil use. (Não use este código para o mal) 
%%%%%%%%%%%%% 
% fc_lib_calcnum_Integral_Simpson_Xf(X,f) 
%%%%%%%%%%%%% 
%X : vetor com os pts da abscissas; 
%f : função f(X) dos resultados ou pts experimentais; 
%%%%%%%%%%%%% 
% version 01: 04.04.2018 -- Creation 
%%%%%%%%%%%%% Example 
% X = [0 1 2 3 4 5 6]; 
% f = inline('exp(-x.^2)'); 
% I = fc_lib_calcnum_Integral_Simpson_Xf(X,f) 
% plot (X,Y,'r'); grid on; 
%%%%%%%%%%%%% 
%% algorithm 
function I = fc_lib_calcnum_Integral_Simpson_Xf(X,f) 
Y = f(X); 
n = length(X)-1; 
I = 0; 
if mod(n,2) == 0 
    for i = 2:2:n 
        I = I + ( ((X(i)-X(i-1)))/3 * (Y(i-1) + 4*Y(i) + Y(i+1)) ); 
    end 
else 
    fprintf('# pts do intervalo deve ser ímpar'); 
end 
end 
%% old implementation 
%for i = 1:((n)/2) 
%    I = I + ( ((X(2*i)-X(2*i-1)))/3 * (Y(2*i-1) + 4*Y(2*i) + Y(2*i+1)) ); 
%end