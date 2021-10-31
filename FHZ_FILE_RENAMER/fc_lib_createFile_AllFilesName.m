%% fc_lib_createFile_AllFilesName
% %%%%%%%%%%%%%%%%%%%%
% Help
% fc_lib_createFile_AllFilesName(PATH, flag_copy_to_edit_changes)
% Pertence à biblioteca particular
% %%%%%%%%%%%%%%%%%%%%
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC - Brazil)
% COPYRIGHT: Free for non evil use. (Não use este código para o mal)
% %%%%%%%%%%%%%%%%%%%%
% This function receives a folder and an option.
% It goes to the defined PATH
% where it use DOS' command to create a .txt file with all filenames
% of that PATH, then moves allFilesName.txt to the this_PATH
% and return to the this_PATH
% %%%%%%%%%%%%%%%%%%%%
% PATH = 'Files_in_a_folder_Example'
% fc_lib_createFile_AllFilesName(PATH,1)
% %%%%%%%%%%%%%%%%%%%%
% find folder: PATH
% DOS' command:
% cd PATH
% dir /b /a-d>allFilesName.txt
% %%%%%%%%%%%%%%%%%%%%
% ls > allFilesName.txt    %MAC
% Source: http://osxdaily.com/2012/10/11/save-list-of-files-folder-contents-as-text/
% %%%%%%%%%%%%%%%%%%%%
% ----- End Help

% Histórico - History
%{
Autor:  Fernando Henrique G. Zucatelli (UFABC - Brasil)
        
função criar lista de arquivos de uma pasta e mover para a pasta onde este
    script se encontra
versão 01:
21.03.2016
    Criação do arquivo
    Uso de comandos do MS-DOS com "dos". Fantástico.
24.12.2017
    Transformando em função de biblioteca
%}
function fc_lib_createFile_AllFilesName(PATH, flag_copy_to_edit_changes)
%% Algorithm
% fprintf('... Iniciando - Start: execute_DOS_command_from_Matlab\n');
%% flag to decide if a copy will be created
% flag_copy_to_edit_changes = 1; % create
% flag_copy_to_edit_changes = 0; % do not create
%% store the folder/path where this code is
this_PATH = pwd;
%% Goes to desired PATH
% PATH = 'C:\Users\MTALAB\Files_in_a_folder_Example';
% PATH = 'Files_in_a_folder_Example';
% PATH = 'C:\Users\FHZ\Dropbox\Doutorado\Doutorado_Unicamp_2017_S2\PED C - EM707 - Arquivos\Programas\Moodle';
cd(PATH); %dos(cd(PATH))
%% create allFilesName.txt with all file names in PATH
filename = 'allFilesName';
dos(sprintf('dir /b /a-d>%s.txt', filename));
%% move allFilesName.txt to this_PATH
if ~strcmp(PATH, pwd)
    movefile(sprintf('%s.txt', filename), this_PATH);
end
%% return to this_PATH
cd(this_PATH); %dos(cd(this_PATH))
%% Create a copy to edit the changes to rename
if flag_copy_to_edit_changes == 1
    copyfile(sprintf('%s.txt', filename), sprintf('%s_copy.txt', filename));
end
% fprintf('... Concluido - Finished: execute_DOS_command_from_Matlab\n');
%% End of File