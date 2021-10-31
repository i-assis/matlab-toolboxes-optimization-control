%% fc_lib_save_file_extensao
%%%%%%%%%%%%%
% help fc_lib_save_file_extensao
%%%%%%%%%%%%%
% fc_lib_save_file_extensao(file_name, str_ext, string_to_file)
% Function call save_file_tex to create a file with file_name of the
% extension str_ext with the contents of string_to_file
%%%%%%%%%%%%%

%{
Autor:  Fernando Henrique G. Zucatelli
        Magno Enrique Mendoza Meza
Interface de controle 2
Compensadores no domínio da frequência

Programa que define cria o arquivo e chama a função para escrever uma
string dentro do arquivo
versão 01:
04.01.2016
    Criação do arquivo.
%}
%% algoritmo
function fc_lib_save_file_extensao(file_name, str_ext, string_to_file)
fid = fopen([file_name,str_ext],'w');
save_file_tex(fid, string_to_file);
fclose(fid);
end