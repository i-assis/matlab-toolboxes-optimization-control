%% fc_lib_move_filelist_filter
%%%%%%%%%%%%%
% help fc_lib_move_filelist_filter
% Belongs to private library
%%%%%%%%%%%%%
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC - Brazil)
% COPYRIGHT: Free for non evil use. (Não use este código para o mal)
%%%%%%%%%%%%%
% This function receives two folders and some filter options.
% It moves all filtered files from PATH1 to PATH2
%
% This function uses the following library functions
% - fc_lib_createFile_AllFilesName_ListOfFiles_filter
%       fc_lib_createFile_AllFilesName
%       fc_lib_allFilesName_to_ListOfFiles
%       fc_lib_ListOfFiles_filter
%%%%%%%%%%%%%
% version 01: 21.03.2016 - Creation
%%%%%%%%%%%%% Example 01
% PATH1 = pwd;
% PATH1 = 'C:\Users\FHZ\Dropbox\Matlab_FHZ_library\file_library\Example_excel_matlab';
% folder = 'moved_files_Example';
% if ~exist(folder,'dir'); mkdir(folder); end;
% PATH2 = folder;
% extension = {'.xls'};
% fc_lib_move_filelist_filter(PATH1,PATH2,extension);
%%%%%%%%%%%%% Example 02 - Reverting Example 01 results
% extension = {'Excel'};
% fc_lib_move_filelist_filter(PATH2,PATH1,extension);
%%%%%%%%%%%%% Example 03
% PATH1 = pwd;
% PATH2 = 'old_versions';
% extension = {'_old'};
% fc_lib_move_filelist_filter(PATH1,PATH2,extension);
%%%%%%%%%%%%%
%% algorithm
function fc_lib_move_filelist_filter(PATH1, PATH2, extension)
%% Start
fprintf('... Iniciando - Start: fc_lib_move_filelist_filter\n');
%% Analysis
if strcmp(PATH1,PATH2)
    fprintf('... PATH1 and PATH2 are the same, no need to move files\n'); return;
end
if ~exist(PATH1,'dir')
    fprintf('... PATH1 does not exist, cannot move files from PATH1\n'); return;
end
if ~exist(PATH2,'dir')
    fprintf('... PATH2 does not exist, cannot move files to PATH2\n'); return;
end
%% Creating a filelist of PATH1
filelist = fc_lib_createFile_AllFilesName_ListOfFiles_filter(PATH1,0,1,extension);
%% move filelist from PATH1 to PATH2
for i = 1:length(filelist)
    file_name = char(filelist(i));
    movefile(file_name, PATH2);
end
%% Finish
fprintf('... Concluido - Finish: fc_lib_move_filelist_filter\n');
end