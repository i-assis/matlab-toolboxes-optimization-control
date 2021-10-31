%% fc_lib_search_bibtex_entries_single_file
%%%%%%%%%%%%%
% help fc_lib_search_bibtex_entries_single_file
% Belongs to private library
%%%%%%%%%%%%%
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC - Brazil)
% COPYRIGHT: Free for non evil use. (Não use este código para o mal)
%%%%%%%%%%%%%
% Function to find the entry of a bibliography in bibitex
% This code is normally called by:
%   fc_lib_search_bibtex_entries
% to create a full list of search items.
%%%%%%%%%%%%%
% version 01: 03.03.2019 - Creation
%%%%%%%%%%%%% Example
% file_name = 'Example_excel_matlab/example_files_bibtex.bib';
% biblist = fc_lib_search_bibtex_entries_single_file(file_name);
%%%%%%%%%%%%%
%% algorithm
function biblist = fc_lib_search_bibtex_entries_single_file(file_name)
if exist(file_name,'file')
    fid_1 = fopen(file_name, 'r');
else
    fprintf('Arquivo nao encontrado - File not found\n');
    biblist = {''}; return;
end
% prealocate memory for biblist cell size N
N = 100; biblist = cell(N,1);
i = 1;
while 1
    % === pega uma linha do arquivo - get a file line
    tline_1 = fgetl(fid_1); %tline_2 = fgetl(fid_2);
    % === criterio de saida quando nao encontra mais linha - exit criterium and do not find a line
    if ~ischar(tline_1) %|| ~ischar(tline_2)
        break;
    end
    if ~isempty(tline_1)
        if strcmp(tline_1(1),'@')
            x = strfind(tline_1,'{');
            y = strfind(tline_1,',');
            biblist(i) = {tline_1(x+1:y-1)};
            i = i + 1;
        end
    end
end
% remove celulas excedentes - remove excedent cells
while N > (i - 1)
    biblist(N,:) = [];
    N = N - 1;
end
fclose(fid_1);
end