%% fc_ext_save_file_extensao

%{
Autor:  Fernando Henrique G. Zucatelli
        Magno Enrique Mendoza Meza
Interface de controle 2
Compensadores no dom�nio da frequ�ncia

Programa que define cria o arquivo e chama a fun��o para escrever uma
string dentro do arquivo
vers�o 01:
04.01.2016
    Cria��o do arquivo.
%}
%% algoritmo
function fc_ext_save_file_extensao(file_name, str_ext, string_to_file)
fid = fopen([file_name,str_ext],'w');
save_file_tex(fid, string_to_file);
fclose(fid);
%% Fim