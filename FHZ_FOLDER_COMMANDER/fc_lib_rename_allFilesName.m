%% fc_lib_rename_allFilesName
%%%%%%%%%%%%%
% help fc_lib_rename_allFilesName
% Belongs to private library
%%%%%%%%%%%%%
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC - Brazil)
% COPYRIGHT: Free for non evil use. (Não use este código para o mal)
%%%%%%%%%%%%%
% Function to rename a bunch of files of a given folder
% This function needs two files: The original filelist and the new filelist
%   file creation is discussed in the function:
%       fc_lib_createFile_AllFilesName
%%%%%%%%%%%%%
% version 01: 24.12.2017 - Creation
% version 02: 16.06.2019 - Updating version notes to English
%     Removing old unnecessary comments
%%%%%%%%%%%%% Example 001
% file_name_1 = 'allFilesName.txt';
% file_name_2 = 'allFilesName_copy.txt';
% fc_lib_rename_allFilesName(file_name_1,file_name_2,pwd);
%%%%%%%%%%%%%
% Source:https://www.mathworks.com/matlabcentral/answers/1760-how-to-rename-a-bunch-of-files-in-a-folder
%%%%%%%%%%%%%
%% algorithm
function fc_lib_rename_allFilesName(file_name_1,file_name_2,PATH)
clc;
fprintf('... Iniciando - Start: fc_lib_rename_allFilesName\n');
%% Files
fid_1 = fopen(file_name_1, 'r'); % file_name_1 = 'allFilesName.txt';
fid_2 = fopen(file_name_2, 'r'); % file_name_2 = 'allFilesName_copy.txt';
%% Defining Paths to go and come back
cd(PATH);
%% DOS Rename loop
while 1
    % === pega uma linha do arquivo - get a file line
    tline_1 = fgetl(fid_1); tline_2 = fgetl(fid_2);
    % === criterio de saida quando nao encontra mais linha - exit criterium and do not find a line
    if ~ischar(tline_1) || ~ischar(tline_2)
        break;
    end
    %rename(PATH, char(tline_1), char(tline_2));
    if exist(tline_1,'file')  %'dir' for folder
        dos(['rename "' tline_1 '" "' tline_2 '"']); % (1)
    end
end
%% Returning and exit message
fclose(fid_1); fclose(fid_2);
% cd(this_PATH); % returns to this_PATH
fprintf('... Concluido - Finished: fc_lib_rename_allFilesName\n');
end