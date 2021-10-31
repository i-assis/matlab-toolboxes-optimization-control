%% fc_lib_createFile_AllFilesName_ListOfFiles_filter
%%%%%%%%%%%%%
% help fc_lib_createFile_AllFilesName_ListOfFiles_filter
% Belongs to private library
%%%%%%%%%%%%%
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC - Brazil)
% COPYRIGHT: Free for non evil use. (Não use este código para o mal)
%%%%%%%%%%%%%
% Function to encapsulate all functions that together creates a cell with
% the list of the name of all files in a given PATH
% Used functions:
%     fc_lib_createFile_AllFilesName
%     fc_lib_allFilesName_to_ListOfFiles
%     fc_lib_ListOfFiles_filter
%%%%%%%%%%%%%
% version 01: 24.12.2017 -- Creation by collecting other functions
% version 02: 14.03.2018 -- "delete(file_name)" added at the end
% version 03: 13.06.2019 -- Removed the need of the input "filename"
%%%%%%%%%%%%%  Example 01
% PATH = pwd;
% flag_copy_to_edit_changes = 0;
% flag_store_with_PATH = 1;
% extension = {'.xls','.m'};
% filelist = fc_lib_createFile_AllFilesName_ListOfFiles_filter(PATH,flag_copy_to_edit_changes,flag_store_with_PATH,extension);
%%%%%%%%%%%%%
% Source: https://www.mathworks.com/matlabcentral/answers/1760-how-to-rename-a-bunch-of-files-in-a-folder
%%%%%%%%%%%%%
%% algorithm
function filelist = fc_lib_createFile_AllFilesName_ListOfFiles_filter(PATH,flag_copy_to_edit_changes,flag_store_with_PATH,extension)
fc_lib_createFile_AllFilesName(PATH,flag_copy_to_edit_changes);
filename = 'allFilesName.txt';
filelist = fc_lib_allFilesName_to_ListOfFiles(PATH,flag_store_with_PATH,filename);
filelist = fc_lib_ListOfFiles_filter(filelist,extension);
file_name_path = sprintf('%s\\%s',PATH,filename);
delete(file_name_path);
end