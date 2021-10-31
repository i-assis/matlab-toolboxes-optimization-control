%% fc_lib_calcnum_Integral_Trapezios_Xf_vetor 
%%%%%%%%%%%%% 
% help fc_lib_calcnum_Integral_Trapezios_Xf_vetor 
% Belongs to private library 
%%%%%%%%%%%%% 
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC) 
% COPYRIGHT: Free for non evil use. (Não use este código para o mal) 
%%%%%%%%%%%%% 
% fc_lib_calcnum_Integral_Trapezios_Xf_vetor(X,f) 
%%%%%%%%%%%%% 
% version 01: 15.05.2019 -- Creation 
%   Based on: fc_lib_calcnum_Integral_Trapezios_Xf
% 05.06.2019 -- Update to function handles instead of inline
%%%%%%%%%%%%% Example 
% X = [0 1 2 3 4 5]; 
% % f = inline('exp(-x.^2)'); 
% f = @(x)exp(-x.^2);
% I = fc_lib_calcnum_Integral_Trapezios_Xf_vetor(X,f) 
% fprintf('%g\n',sum(I)); 
% x0 = 0; plot (X,f(X),'r', X(2:end),I,'b', X,cumsum([x0;I]),'m'); grid on; 
%%%%%%%%%%%%% 
%% algorithm 
function I = fc_lib_calcnum_Integral_Trapezios_Xf_vetor(X,f) 
Y = f(X); n = length(X); I = zeros(n-1,1); 
for i = 2:n 
    I(i-1) = ( (X(i) - X(i-1))/2 ) * ( Y(i) + Y(i-1) ); 
end 
end