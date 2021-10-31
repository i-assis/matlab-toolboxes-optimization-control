%% script_allFilesName_to_ListOfFiles
% %%%%%%%%%%%%%%%%%%%%
% Help
% %%%%%%%%%%%%%%%%%%%%
% Author: Fernando Henrique G. Zucatelli (UFABC - Brazil)
% COPYRIGHT: Free for non evil use. (Não use este código para o mal)
% %%%%%%%%%%%%%%%%%%%%
% 
% Code for bunch of rename of files in a folder
% must have the original file list and the new file list
% on separated files
% file creation is discussed in program:
% execute_DOS_command_from_Matlab
%
% %%%%%%%%%%%%%%%%%%%%
% OBS: Commented commands are options to work with a loaded file
% %%%%%%%%%%%%%%%%%%%%
% Source:https://www.mathworks.com/matlabcentral/answers/1760-how-to-rename-a-bunch-of-files-in-a-folder
% %%%%%%%%%%%%%%%%%%%%
% ----- End Help

% Histórico - History
%{
Autor: Fernando Henrique G. Zucatelli (UFABC - Brasil)
        
function para extrair a extensão do arquivo de um nome de arquivo dado
versão 01:
21.03.2016
    Criação do arquivo
    Uso de comandos do MS-DOS com "dos". Fantástico.
%}

%% algorithm
fprintf('... Iniciando - Start: allFilesName_to_ListOfFiles\n');
% flag_store_with_PATH = 1, for "without_PATH" use 0.
% local original dos arquivos da lista 'allFilesName.txt'
% original place of files from the list 'allFilesName.txt'
% PATH = 'C:\Users\MTALAB\Files_in_a_folder_Example';
PATH = 'Files_in_a_folder_Example';
% choosing if file will be store with or without its PATH
flag_store_with_PATH = 1;
% file with allFilesName of a PATH/folder
file_name_1 = 'allFilesName.txt';
if exist(file_name_1,'file')
    fid_1 = fopen(file_name_1, 'r');
else
    fprintf('Arquivo nao encontrado - File not found\n'); return;
end
% prealocate memory for filelist cell size N
N = 100; filelist = cell(N,1);
ii = 1;
while 1
    % === pega uma linha do arquivo - get a file line
    tline_1 = fgetl(fid_1); %tline_2 = fgetl(fid_2);
    % === crit?rio de sa?da quando n?o encontra mais linha - exit criterium and do not find a line
    if ~ischar(tline_1) %|| ~ischar(tline_2)
        break;
    end
    %fprintf('%s%s}\n\n', base, char(tline));
    if flag_store_with_PATH == 1
        filelist(ii) = {sprintf('%s%s%s', PATH, '\', tline_1)};
    else
        filelist(ii) = {tline_1};
    end
    ii = ii + 1;
end
% remove células excedentes
while N > (ii - 1)
    filelist(N,:) = [];
    N = N - 1;
end
fprintf('... Concluido - Finished: allFilesName_to_ListOfFiles\n');
%% End of File