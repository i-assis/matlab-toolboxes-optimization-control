%% fc_lib_rename_allFilesName
% %%%%%%%%%%%%%%%%%%%%
% Help
% %%%%%%%%%%%%%%%%%%%%
% Author: Fernando H.G. Zucatelli (UFABC - Brasil)
% COPYRIGHT: Free for non evil use. (Não use este código para o mal)
% %%%%%%%%%%%%%%%%%%%%
% Code to rename a bunch of files in a folder
% must have the original filelist and the new filelist on separated files
% file creation is discussed in program:
% fc_lib_createFile_AllFilesName
% %%%%%%%%%%%%%%%%%%%%
% file_name_1 = 'allFilesName.txt';
% file_name_2 = 'allFilesName_copy.txt';
% fc_lib_rename_allFilesName(file_name_1,file_name_2,pwd)
% %%%%%%%%%%%%%%%%%%%%
% OBS: Commented commands are options to work with a loaded file
% %%%%%%%%%%%%%%%%%%%%
% Source:https://www.mathworks.com/matlabcentral/answers/1760-how-to-rename-a-bunch-of-files-in-a-folder
% %%%%%%%%%%%%%%%%%%%%
function fc_lib_rename_allFilesName(file_name_1,file_name_2,PATH)
%% Algorithm
clc;
fprintf('... Iniciando - Start: script_create_allFilesName_with_DOS_command_from_Matlab\n');
%% Files
% file_name_1 = 'allFilesName.txt';
fid_1 = fopen(file_name_1, 'r');
% file_name_2 = 'allFilesName_copy.txt';
fid_2 = fopen(file_name_2, 'r');
%% mover arquivos para PATH
% movefile(file_name_1, PATH);
% movefile(file_name_2, PATH);
%% Defining Paths to go and come back
this_PATH = pwd; % Pasta atual
% PATH = 'C:\Users\FHZ\Dropbox\Mestrado\Interface_Controle_2_Magno\versao22\pasta_V21_PT';
% PATH = pwd;
cd(PATH);
%% DOS Rename loop
while 1
    % === pega uma linha do arquivo - get a file line
    tline_1 = fgetl(fid_1); tline_2 = fgetl(fid_2);
    % === criterio de saida quando nao encontra mais linha - exit criterium and do not find a line
    if ~ischar(tline_1) || ~ischar(tline_2)
        break;
    end
    %fprintf('%s%s}\n\n', base, char(tline));
    %rename(PATH, char(tline_1), char(tline_2));
    if exist(tline_1,'file')
        dos(['rename "' tline_1 '" "' tline_2 '"']); % (1)
    end
end
%% Returning and exit message
fclose(fid_1); fclose(fid_2);
cd(this_PATH); % returns to this_PATH
fprintf('... Concluido - Finished: script_create_allFilesName_with_DOS_command_from_Matlab\n');
end
%% End of File