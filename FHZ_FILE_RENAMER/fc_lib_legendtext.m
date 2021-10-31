%% fc_lib_legendtext
%%%%%%
% help
% function fc_lib_legendtext(str,N,P)
% Pertence à biblioteca particular
%%%%%%
% Autor: M.Eng. Fernando Henrique G. Zucatelli (UFABC)
% Função para criar legendas em lote de N repetições para mesma variável
%
% versão 01: 20.02.2018
%     Criação
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