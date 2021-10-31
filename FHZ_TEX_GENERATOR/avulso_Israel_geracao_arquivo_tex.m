%% avulso_Israel_geracao_arquivo_tex
%%%%%%%%%%%%% 
% help avulso_Israel_geracao_arquivo_tex
% Belongs to private library 
%%%%%%%%%%%%% 
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC - Brazil) 
% COPYRIGHT: Free for non evil use. (Não use este código para o mal) 
%%%%%%%%%%%%% 
%% preparacao
flag_copy_to_edit_changes = 0;
flag_store_with_PATH = 0;
file_name = 'allFilesName.txt';
%extension = {'.xls','.m'};
extension = {'.m'};
PATH = pwd;
filelist = fc_lib_createFile_AllFilesName_ListOfFiles_filter(PATH,flag_copy_to_edit_changes,flag_store_with_PATH,file_name,extension);
%% geração do LaTeX com texto padrão e parte construído
l1 = '% --- ';
%l2 = '\lstinputlisting[firstnumber = 1, firstline = 30, lastline = 35]'
%l2 = '\lstinputlisting[firstline = 30]';
l2 = '\lstinputlisting';
%l3 = '{C:/Users/FHZ/Dropbox/Matlab_FHZ_library/';
%l3 = '% ---';
l3 = '{';
for k = 1:length(filelist)
    str = sprintf('%s%s}',l3,char(filelist(k)));
    if k == 1
        r = char(l1,l2,str);
    else
        r = char(r,l1,l2,str);
    end
end
fc_lib_save_file_extensao('tmp', '.tex', r);
