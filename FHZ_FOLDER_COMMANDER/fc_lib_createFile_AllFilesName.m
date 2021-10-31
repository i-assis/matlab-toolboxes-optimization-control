%% fc_lib_createFile_AllFilesName
%%%%%%%%%%%%%
% help fc_lib_createFile_AllFilesName
% Belongs to private library
%%%%%%%%%%%%%
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC - Brazil)
% COPYRIGHT: Free for non evil use. (Não use este código para o mal)
%%%%%%%%%%%%%
% fc_lib_createFile_AllFilesName(PATH, flag_copy_to_edit_changes)
%     This function receives the PATH to a folder and an option.
%     It goes to the defined PATH
%     where it uses a DOS' command to create a .txt file with all name
%     of files of that PATH, then moves allFilesName.txt to this_PATH
%     and return to the this_PATH
%%%%%%%%%%%%% flag to decide if a copy will be created
% flag_copy_to_edit_changes = 1; % create
% flag_copy_to_edit_changes = 0; % do not create
% This copy is necessary for the "fc_lib_rename_allFilesName" function.
%%%%%%%%%%%%%
% version 01: 21.03.2016 - Creation do arquivo
%     Uso de comandos do MS-DOS com "dos". Fantástico.
% 24.12.2017 - Transformando em função de biblioteca
% version 02: 10.03.2019 - Correcting full path and moving issue
% version 03: 16.06.2019 - Updating version notes to English
%     Preserving old version notes in Portuguese
%%%%%%%%%%%%% Example 01 - Creating with a "_copy" to edit
% PATH = pwd;
% fc_lib_createFile_AllFilesName(PATH,1);
%%%%%%%%%%%%% Example 02 - Creating without a "_copy" to edit
% PATH = pwd;
% fc_lib_createFile_AllFilesName(PATH,0)
%%%%%%%%%%%%% Sintaxe for Windows users
% find folder: PATH
% DOS' command:
% cd PATH
% dir /b /a-d>allFilesName.txt
%%%%%%%%%%%%% Sintaxe for MAC users
% ls > allFilesName.txt    %MAC
% Source: http://osxdaily.com/2012/10/11/save-list-of-files-folder-contents-as-text/
%%%%%%%%%%%%%
%% algorithm
function fc_lib_createFile_AllFilesName(PATH, flag_copy_to_edit_changes)
%% Store the folder/path where this code is
this_PATH = pwd;
%% Goes to desired PATH
cd(PATH);
%% Create allFilesName.txt with all file names in PATH
filename = 'allFilesName';
dos(sprintf('dir /b /a-d>%s.txt', filename)); % L = ls
%% Full path name analysis
new_PATH = pwd;
x = strfind(new_PATH,'\'); x = x(end);
new_PATH = new_PATH(x+1:end);
%% Move allFilesName.txt to this_PATH
if ~strcmp(PATH, pwd) && ~strcmp(PATH, new_PATH)
    movefile(sprintf('%s.txt', filename), this_PATH);
end
%% Create a copy to edit the changes to rename
if flag_copy_to_edit_changes == 1
    copyfile(sprintf('%s.txt', filename), sprintf('%s_copy.txt', filename), 'f');
end
%% Return to this_PATH
cd(this_PATH); %dos(cd(this_PATH))
end