%% fc_lib_calcnum_RaizNLin_escrita_passagens 
%%%%%%%%%%%%% 
% help fc_lib_calcnum_RaizNLin_escrita_passagens 
% Belongs to private library 
%%%%%%%%%%%%% 
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC - Brazil) 
% COPYRIGHT: Free for non evil use. (Não use este código para o mal) 
%%%%%%%%%%%%% 
% Function to write passages of the non-linear resolutions steps 
%%%%%%%%%%%%% Example 
% F = @(x) x - cos(x); s = '%10.4f'; 
% X = [-0.4161    0.4420    0.8982    0.7279    0.7387    0.7391]; 
% fc_lib_calcnum_RaizNLin_escrita_passagens([-2,2,X],F,s); 
%%%%%%%%%%%%% 
%% algorithm 
function fc_lib_calcnum_RaizNLin_escrita_passagens(X,F,s) 
str = sprintf('%s x(n-1) = %s raiz = %s F(raiz) = %s tol = %s', ... 
    '%3d', s, s, s, s); 
for i = 2:length(X) 
    fprintf(sprintf('%s\n',str), i,X(i-1),X(i),F(X(i)),X(i)-X(i-1)); 
end 
end