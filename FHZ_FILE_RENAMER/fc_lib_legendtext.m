%% fc_lib_legendtext
%%%%%%
% help
% function fc_lib_legendtext(str,N,P)
% Pertence � biblioteca particular
%%%%%%
% Autor: M.Eng. Fernando Henrique G. Zucatelli (UFABC)
% Fun��o para criar legendas em lote de N repeti��es para mesma vari�vel
%
% vers�o 01: 20.02.2018
%     Cria��o
%%%%%% Example
% text = 'x';
% N = 5;
% p = 2;
% legendtext = fc_lib_legendtext(text,N,p)
%%%%%%
function legendtext = fc_lib_legendtext(text,N,p)
forma = sprintf('%s0%dd', '%', p);
str = sprintf('%s_{%s}',text,forma);
for k = 1:N
    if k ~= 1
        legendtext = char(legendtext,...
            sprintf(str,k));
    else
        legendtext = sprintf(str,k);
    end
end
end