%% fc_lib_file_load_excel_to_matlab
%%%%%%%%%%%%%
% help fc_lib_file_load_excel_to_matlab
% Belongs to private library
%%%%%%%%%%%%%
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC - Brazil)
% COPYRIGHT: Free for non evil use. (Não use este código para o mal)
%%%%%%%%%%%%%
% This function extracts data from all Excel spreadsheets of a given PATH.
% sheet: is a vector with all the sheet to extract
% xlRange_list: is a list with the range of each sheet
% struct_name_base: is the name given to the saved file
% -----------
% This function is a method to automated the basic command
% [data, txt, raw] = xlsread(excel_filename);
% To write in Excel, use the command: xlswrite
%%%%%%%%%%%%%
% This function use the following library functions:
%   fc_lib_createFile_AllFilesName_ListOfFiles_filter
%       - fc_lib_createFile_AllFilesName
%       - fc_lib_allFilesName_to_ListOfFiles
%       - fc_lib_ListOfFiles_filter
%%%%%%%%%%%%%
% version 01: 09.03.2019 - Creation
%%%%%%%%%%%%% Example 0
% PATH = pwd;
% PATH = 'C:\Users\FHZ\Dropbox\Matlab_FHZ_library\file_library\Example_excel_matlab';
% sheet = [1,2];
% xlRange_list = {'',''};
% struct_name_base = 'Simulation';
% excel_list = fc_lib_file_load_excel_to_matlab(PATH, sheet, xlRange_list,struct_name_base);
% ----------- Acessing files
% load(sprintf('%s\\%s_001.mat',PATH,struct_name_base));
% Simulation_001.sheet1.data
% Simulation_001.sheet2.data
% load(sprintf('%s\\%s_002.mat',PATH,struct_name_base));
% Simulation_002.sheet1.data
% Simulation_002.sheet2.data
%%%%%%%%%%%%%
%% algorithm
function excel_list = fc_lib_file_load_excel_to_matlab(PATH, sheet, xlRange_list, struct_name_base)
%% Verification
if length(sheet) ~= length(xlRange_list)
    fprintf('Error - sheet and xlRange_list size must be equal\n');
    excel_list = ''; return;
end
%% Creating excel_filename_list
extension = {'.xls','.xlsx'};
excel_list = fc_lib_createFile_AllFilesName_ListOfFiles_filter(PATH,0,1,extension);
%% Creating base struct
struct_code = 1:length(excel_list);
%% loop
fprintf('Iniciando - Starting\n');
for i = 1:length(struct_code)
    % getting filename from the list and the range
    excel_filename = char(excel_list(i));
    struct_name = sprintf('%s_%03d',struct_name_base, struct_code(i));
    for j = 1:length(sheet)
        xlRange = char(xlRange_list(j));
        data = fc_int_load_excel_to_matlab_single_file...
            (excel_filename, sheet(j), xlRange);
        % -- creating struct with var inside
        eval(sprintf('%s.sheet%d.data = data;', struct_name, j));
    end
    % -- saving struct with it own name
    save_name = sprintf('%s\\%s',PATH,struct_name);
    save(save_name,struct_name);
end
fprintf('Concluido - Finished\n');
end
%% internal functions
function data = fc_int_load_excel_to_matlab_single_file(excel_filename, sheet, xlRange)
if strcmp(xlRange,'')
    data = xlsread(excel_filename,sheet);
elseif sheet == 0
    data = xlsread(excel_filename);
else
    data = xlsread(excel_filename,sheet,xlRange);
end
end
%% Adding Excel file name to the struct
%{
for i = 1:length(excel_filename_list)
    struct_name = sprintf('%s_%03d',struct_name_base, struct_code(i));
    nome_planilha = char(excel_filename_list(i));
    eval(sprintf('%s.nome_planilha = nome_planilha;', struct_name));
    save(struct_name,struct_name);
end
%}