%% fc_lib_allFilesName_to_ListOfFiles
%%%%%%%%%%%%%
% help fc_lib_allFilesName_to_ListOfFiles
% Belongs to private library
%%%%%%%%%%%%%
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC - Brazil)
% COPYRIGHT: Free for non evil use. (Não use este código para o mal)
%%%%%%%%%%%%%
% Function to convert a .txt file with all names of files into a cell named
% filelist
% The file creation is discussed in the function:
%   fc_lib_createFile_AllFilesName
%%%%%%%%%%%%%
% version 01: 21.03.2016 -- Creation
%     Uso de comandos do MS-DOS com "dos".
% 24.12.2017 -- Transformando em função de biblioteca
% version 02: 28.11.2018 -- Adicionando PATH na busca por file_name
% version 03: 16.06.2019 - Updating version notes to English
%     Preserving old version notes in Portuguese
%     Changing variable "ii" to "k"
%%%%%%%%%%%%%
% fprintf('... Iniciando - Start: allFilesName_to_ListOfFiles\n');
% flag_store_with_PATH = 1, for "without_PATH" use 0.
% local original dos arquivos da lista 'allFilesName.txt'
% original place of files from the list 'allFilesName.txt'
%%%%%%%%%%%%% Example 01
% PATH = 'C:\Users\FHZ\Dropbox\Matlab_FHZ_library';
% filelist = fc_lib_allFilesName_to_ListOfFiles(PATH,0,'allFilesName.txt')
% filelist = fc_lib_allFilesName_to_ListOfFiles(PATH,1,'allFilesName.txt')
%%%%%%%%%%%%%
% Source: https://www.mathworks.com/matlabcentral/answers/1760-how-to-rename-a-bunch-of-files-in-a-folder
%%%%%%%%%%%%%
%% algorithm
function filelist = fc_lib_allFilesName_to_ListOfFiles(PATH,flag_store_with_PATH,file_name)
file_name_path = sprintf('%s\\%s',PATH,file_name);
if exist(file_name_path,'file')
    fid_1 = fopen(file_name_path, 'r');
else
    fprintf('Arquivo nao encontrado - File not found\n');
    filelist = {''}; return;
end
% prealocate memory for filelist cell size N
N = 100; filelist = cell(N,1);
k = 1;
while 1
    % === pega uma linha do arquivo - get a file line
    tline_1 = fgetl(fid_1); %tline_2 = fgetl(fid_2);
    % === critério de saída quando não encontra mais linha - exit criterium and do not find a line
    if ~ischar(tline_1) %|| ~ischar(tline_2)
        break;
    end
    if flag_store_with_PATH == 1
        filelist(k) = {sprintf('%s%s%s', PATH, '\', tline_1)};
    else
        filelist(k) = {tline_1};
    end
    k = k + 1;
end
% remove células excedentes - removing excendent cells
while N > (k - 1)
    filelist(N,:) = [];
    N = N - 1;
end
fclose(fid_1);
end