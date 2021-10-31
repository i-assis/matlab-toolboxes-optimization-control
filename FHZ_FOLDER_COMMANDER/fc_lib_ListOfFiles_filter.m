%% fc_lib_ListOfFiles_filter
%%%%%%%%%%%%%
% help fc_lib_ListOfFiles_filter
% Belongs to private library
%%%%%%%%%%%%%
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC - Brazil)
% COPYRIGHT: Free for non evil use. (Não use este código para o mal)
%%%%%%%%%%%%%
% Function to filter a filelist from a desired extension set file
%%%%%%%%%%%%%
% version 01: 24.12.2017 - Creation
%   Transforming into a library function
% version 02: 16.06.2019 - Updating version notes to English
%%%%%%%%%%%%% Example 01
% filelist = {'f1.xls','f2.m','f3.pdf'};
% extension = {'.xls','.m'};
% filelist_filter = fc_lib_ListOfFiles_filter(filelist,{'.xls','.m'})
%%%%%%%%%%%%%
% Source:https://www.mathworks.com/matlabcentral/answers/1760-how-to-rename-a-bunch-of-files-in-a-folder
%%%%%%%%%%%%%
%% algorithm
function filelist_filter = fc_lib_ListOfFiles_filter(filelist,extension)
N = length(filelist);
filelist_filter = cell(N,1);
i = 1;
for k = 1:N
    if contains(filelist(k),extension)
        filelist_filter(i) = filelist(k);
        i = i + 1;
    end
end
% remove células excedentes -- removing excedent cells
while N > (i - 1)
    filelist_filter(N,:) = [];
    N = N - 1;
end
end