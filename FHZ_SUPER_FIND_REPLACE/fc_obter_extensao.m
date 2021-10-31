%% fc_obter_extensao
% %%%%%%%%%%%%%%%%%%%%
% Help
% %%%%%%%%%%%%%%%%%%%%
% Author: Fernando Henrique G. Zucatelli (UFABC - Brazil)
% COPYRIGHT: Free for non evil use. (N�o use este c�digo para o mal)
% %%%%%%%%%%%%%%%%%%%%
% 
% Code to extract the extension of a file
% If a file comes without .extension, then ".txt" is given as default
%
% %%%%%%%%%%%%%%%%%%%%
% ----- End Help

% Hist�rico - History
%{
Autor: Fernando Henrique G. Zucatelli (UFABC - Brasil)
        
function para extrair a extens�o do arquivo de um nome de arquivo dado
vers�o 01:
16.11.2016
    Cria��o do arquivo
05.01.2017
    Editando textos para ingl�s e publica��o na Mathworks
21.03.2016
    Editando cabe�alho
%}
function extensao = fc_obter_extensao(file_name)
[l c] = size(file_name);
jj = c;
while jj >= 1 && ~strcmp(file_name(jj), '.')
    if jj == c
        extensao = file_name(jj);
    else
        extensao = sprintf('%s%s', file_name(jj), extensao);
    end
    jj = jj - 1;
end
if jj == 0
    fprintf('O arquivo veio sem extens�o. Usarei ".txt" para guardar os resultados\n');
    fprintf('File came without extension. I will use ".txt" to save results\n');
    extensao = '.txt';
else
    extensao = sprintf('%s%s', '.', extensao);
end
end