%% fc_lib_createFile_AllFoldersName_ListOfFiles_filter
%%%%%%%%%%%%%
% help fc_lib_createFile_AllFoldersName_ListOfFiles_filter
% Belongs to private library
%%%%%%%%%%%%%
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC - Brazil)
% COPYRIGHT: Free for non evil use. (Não use este código para o mal)
%%%%%%%%%%%%%
% Function to encapsulate all functions that together creates a cell with
% the list of the name of all folders in a given PATH
% Used functions:
%     fc_lib_createFile_AllFoldersName
%     fc_lib_allFilesName_to_ListOfFiles
%     fc_lib_ListOfFiles_filter
%%%%%%%%%%%%%
% version 01: 07.17.2019 -- Creation based on
%   fc_lib_createFile_AllFilesName_ListOfFiles_filter
%%%%%%%%%%%%%  Example 01
% PATH = pwd;
% flag_copy_to_edit_changes = 0;
% flag_store_with_PATH = 1;
% extension = {'old','exc'};
% filelist = fc_lib_createFile_AllFoldersName_ListOfFiles_filter(PATH,flag_copy_to_edit_changes,flag_store_with_PATH,extension);
%%%%%%%%%%%%%
% Source: https://www.mathworks.com/matlabcentral/answers/1760-how-to-rename-a-bunch-of-files-in-a-folder
%   https://stackoverflow.com/questions/16078421/how-do-i-get-a-list-of-folders-and-sub-folders-without-the-files
%%%%%%%%%%%%%
%% algorithm
function filelist = fc_lib_createFile_AllFoldersName_ListOfFiles_filter(PATH,flag_copy_to_edit_changes,flag_store_with_PATH,extension)
fc_lib_createFile_AllFoldersName(PATH,flag_copy_to_edit_changes);
filename = 'AllFoldersName.txt';
filelist = fc_lib_allFilesName_to_ListOfFiles(PATH,flag_store_with_PATH,filename);
filelist = fc_lib_ListOfFiles_filter(filelist,extension);
file_name_path = sprintf('%s\\%s',PATH,filename);
delete(file_name_path);
end