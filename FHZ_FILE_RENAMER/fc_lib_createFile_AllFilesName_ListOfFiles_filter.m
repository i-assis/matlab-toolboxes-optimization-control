%% fc_lib_createFile_AllFilesName_ListOfFiles_filter
% %%%%%%%%%%%%%%%%%%%%
% Help
% filelist = fc_lib_createFile_AllFilesName_ListOfFiles_filter(...
%   PATH,flag_copy_to_edit_changes,flag_store_with_PATH,file_name,extension)
% Pertence à biblioteca particular
% %%%%%%%%%%%%%%%%%%%%
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC - Brazil)
% COPYRIGHT: Free for non evil use. (Não use este código para o mal)
% %%%%%%%%%%%%%%%%%%%%
% Code to encapsulate all functions
% %%%%%%%%%%%%%%%%%%%% Example
% PATH = 'Edo_tanque'
% flag_copy_to_edit_changes = 0;
% flag_store_with_PATH = 1;
% file_name = 'allFilesName.txt';
% extension = {'.xls','.m'};
% filelist = fc_lib_createFile_AllFilesName_ListOfFiles_filter(PATH,flag_copy_to_edit_changes,flag_store_with_PATH,file_name,extension);
% %%%%%%%%%%%%%%%%%%%%
% OBS: Commented commands are options to work with a loaded file
% %%%%%%%%%%%%%%%%%%%%
% Source:https://www.mathworks.com/matlabcentral/answers/1760-how-to-rename-a-bunch-of-files-in-a-folder
% %%%%%%%%%%%%%%%%%%%%
% ----- End Help

% filelist = fc_lib_createFile_AllFilesName_ListOfFiles_filter(PATH,1,1,'allFilesName.txt',extension)

function filelist = fc_lib_createFile_AllFilesName_ListOfFiles_filter(PATH,flag_copy_to_edit_changes,flag_store_with_PATH,file_name,extension)
fc_lib_createFile_AllFilesName(PATH, flag_copy_to_edit_changes);
filelist = fc_lib_allFilesName_to_ListOfFiles(PATH,flag_store_with_PATH,file_name);
filelist = fc_lib_ListOfFiles_filter(filelist,extension);
end
%% End of File