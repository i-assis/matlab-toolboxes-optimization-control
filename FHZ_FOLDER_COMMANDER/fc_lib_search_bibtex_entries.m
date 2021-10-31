%% fc_lib_search_bibtex_entries
%%%%%%%%%%%%%
% help fc_lib_search_bibtex_entries
% Belongs to private library
%%%%%%%%%%%%%
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC - Brazil)
% COPYRIGHT: Free for non evil use. (Não use este código para o mal)
%%%%%%%%%%%%%
% Function to extract the bibtex entries from all .bib file from a folder
%     into a filelist
%
% This function uses the following library functions
% - fc_lib_createFile_AllFilesName_ListOfFiles_filter
%       fc_lib_createFile_AllFilesName
%       fc_lib_allFilesName_to_ListOfFiles
%       fc_lib_ListOfFiles_filter
% - fc_lib_save_file_extensao
%       save_file_tex
% - fc_lib_search_bibtex_entries_single_file
%  script_bib_entries_output
% This function generates two files:
%   script_bib_entries_input - it contains the original bibtex entries
%   script_bib_entries_output - it contains a copy to be modified
%
% There is also an auxiliary file named:
% - script_search_bibtex_entries_change
%       fc_lib_rename_allFilesName
% It is an auxiliar to perform the modifications to change
% the citations and to change the name of the files involved.
%
% Another method is to apply the "search_replace_wordset" library
%
% The variable "input" receive a list of entries of each file
%   therefore its size is not predictable before reading all files
%
% str: is a string that can be written into a file with
%   "fc_lib_save_file_extensao"
% input: is a cell with all entries of the bibtex file.
%%%%%%%%%%%%%
% version 01: 03.03.2019 - Creation
%%%%%%%%%%%%% Example 0
% PATH = 'C:\Users\FHZ\Dropbox\Matlab_FHZ_library\file_library\Example_excel_matlab';
% PATH = pwd;
% [str, input] = fc_lib_search_bibtex_entries(PATH);
%%%%%%%%%%%%%
%% algorithm
function [str, input] = fc_lib_search_bibtex_entries(PATH)
extension = {'.bib'};
filelist = fc_lib_createFile_AllFilesName_ListOfFiles_filter(PATH,0,1,extension);
for k = 1:length(filelist)
    file_name = char(filelist(k));
    lista = fc_lib_search_bibtex_entries_single_file(file_name);
    if k ~= 1
        input = [input;lista];
    else
        input = lista;
    end
end
% ====
str = 'output = {...';
for k = 1:length(input)
    str = char(str,sprintf('''%s''%s',char(input(k)),',...'));
end
str = char(str,'};');
str_ext = '.m'; file_name = 'script_bib_entries_output';
fc_lib_save_file_extensao(file_name, str_ext, str);
% ====
str = 'input = {...';
for k = 1:length(input)
    str = char(str,sprintf('''%s''%s',char(input(k)),',...'));
end
str = char(str,'};');
file_name = 'script_bib_entries_input';
fc_lib_save_file_extensao(file_name, str_ext, str);
end