%% fc_lib_pcode_folder
%%%%%%%%%%%%%
% help fc_lib_pcode_folder
% Belongs to private library
%%%%%%%%%%%%%
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC)
% COPYRIGHT: Free for non evil use. (Não use este código para o mal)
%%%%%%%%%%%%%
% Function para gerar arquivos .p a partir de arquivos .m de uma pasta
% Function to generate .p files of .m files of a folder
% ---
% opcao = 0: It stores files in the same folder
% opcao = 1: It creates a subfolder and stores files in it
%%%%%%%%%%%%%
% version 01: 16.01.2018 - Creation
% version 02: 16.06.2019 - Updating version notes to English
%%%%%%%%%%%%% Example 01
% PATH = pwd; extension = {'.m'}; opcao = 0;
% fc_lib_pcode_folder(PATH, extension, opcao);
%%%%%%%%%%%%% Example 02
% PATH = pwd; extension = {'.m'}; opcao = 1;
% fc_lib_pcode_folder(PATH, extension, opcao);
%%%%%%%%%%%%%
%% algorithm
function fc_lib_pcode_folder(PATH, extension, opcao)
%% avulso_geracao_pcode_em_massa
if opcao == 1
    pasta = 'pcode_created_files';
    if ~exist(pasta,'dir'); mkdir(pasta); end
end
lista_arquivos = fc_lib_createFile_AllFilesName_ListOfFiles_filter(PATH,0,0,extension);
for i = 1:length(lista_arquivos)
    arquivo = char(lista_arquivos(i));
    pcode(arquivo);
    if opcao == 1
        new_arquivo = strrep(arquivo,'.m','.p');
        movefile(new_arquivo,pasta);
    end
end