%% script_search_bibtex_entries_change
%%%%%%%%%%%%%
% help script_search_bibtex_entries_change
% Belongs to private library
%%%%%%%%%%%%%
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC - Brazil)
% COPYRIGHT: Free for non evil use. (Não use este código para o mal)
%%%%%%%%%%%%%
% Script to organize the calling of functions and scripts to search and
% replace bibtex entries
% For further information see:
%   fc_lib_search_bibtex_entries
%%%%%%%%%%%%% Very important note
% Each Session of this file works independently of each other
% DO NOT execute the whole file at once
% it WILL NOT generate the desired result
% you MUST edit the generated files on your own to insert the corrections
% only you, as a human, can do.
%%%%%%%%%%%%%
% version 01: 03.03.2019 - Creation
%%%%%%%%%%%%%
%% Session 1 - Calling the function to create input and output filelists
% the output scritp must be modified before moving to the next session
PATH = pwd;
[str, input] = fc_lib_search_bibtex_entries(PATH);
%% Session 2 - replace session
% === Define a filter and/or extension of files in the PATH selected folder
% === extension must be a cell variable because it call handle multiple
% === words to filter
% extension = {'.bib','Include'};
% extension = {'Include'};
% extension = {'input'};
extension = {'.bib','.tex'};
% === load input e output filelists from generated scripts
% === These files must be edited to achieve desired results
script_bib_entries_input;
script_bib_entries_output;
% === Define CharacterEncoding of the files to be converted
% === They must all have the same enconding to work properly
encod = 'ISO-8859-1';
% encod = 'UTF-8';
% === Changing MATLAB's enconding to match files enconding
slCharacterEncoding(encod);
% === creation converted files
fc_lib_file_corrector(PATH,extension,input,output,encod);
% === returning MATLAB's enconding to its original
encod = 'Windows-1252';
slCharacterEncoding(encod);
%% Session 3 - Create a list of files to rename them
% === The file the suffix "_copy" is the one to be modified as desired
fc_lib_createFile_AllFilesName(pwd,1);
%% Session 4 - Renaming files
% === I chose to creating the converted files with an suffix attached to them
% === so there is a safe zone for regrets and turn backs
file_name_1 = 'allFilesName.txt'; file_name_2 = 'allFilesName_copy.txt';
fc_lib_rename_allFilesName(file_name_1,file_name_2,pwd);