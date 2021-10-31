%% initial_corretor_arquivos_Super_Find_Replace
% %%%%%%%%%%%%%%%%%%%%
% Help
% %%%%%%%%%%%%%%%%%%%%
% Author: Fernando Henrique G. Zucatelli (UFABC - Brazil)
% COPYRIGHT: Free for non evil use. (N�o use este c�digo para o mal)
% %%%%%%%%%%%%%%%%%%%%
%
% This code has comments and portuguese and english.
%
% This code is like a Super Find and Replace. It loads files and create new 
% modified one with the desired modification given by "opcao":
%   1 - Search only for valids characters
%       Example: You cannot have any accent in your file/code
%           This option simply removes it
%   2 - Find and Replace in a batch
%       Example: You wrote "var1" and "Var1" but the compiler is case
%       sensitive.
%           You select in "input_keywords" the old undesired word and in
%           "output_keywords" the new desired one.
%           Main advantage you can do it for all words and files in a single
%           task or key stroke.
%       Example: You write "a=1", but likes "a = 1", with a space.
%           You search for every "=" and then makes it " = ".
%           And also searches for every "  =  " with double space and make
%           it " = ", with a single space.
%       Example: You wrote "\textbf{" for bold format in LaTeX, but it
%           should have been "\textit{". You may correct all files in
%           "filelist" and also at the same time do some other correction you need.
% ----- End Help

%{
Autor: Fernando Henrique G. Zucatelli (UFABC - Brasil)

% --- Comandos para gerar lista de todos os arquivos de um diret�rio
% --- Commands on DOS to create a list of all files in a directory
% encontrar diret�rio: PATH
% Comando no DOS:
% cd PATH
% dir /b /a-d>allFilesName.txt
% ---
% Ser� gerado o arquivo "allFilesName.txt" com todos os nomes de arquivos
% do diret�rio
% File "allFilesName.txt" will be created with all names of the files
% of the directory
% ---        

Script de corre��o de c�digo em um programa
vers�o 01:
03.01.2016
    Cria��o do arquivo.
        Abertura de arquivo externo fopen
            Sele��o linha por linha
            Executando remo��o de caracteres indesejados
            Alterando caracteres de palavras chave conforme desejado
vers�o 02:
11.11.2016
    Desmembrando preparo de vari�veis da execu��o de comandos
    Preparo:
        initial_corretor_arquivos
    Execu��o encapsulada:
        fc_corretor_arquivos
16.11.2016
    Alterando file_name para filelist e executando a fun��o para uma lista
    de arquivos.
% -----
    opcao:
        1 - Apenas string valida
        2 - Localizar e substituir em massa
05.01.2017
    Editando textos para ingl�s e publica��o na Mathworks
20.01.2017
    Pequenas corre��es nos coment�rios

vers�o 02:
21.03.2016
    Adi��o dos scripts:
        script_execute_DOS_command_from_Matlab
        script_allFilesName_to_ListOfFiles
    O primeiro para gerar automaticamente a lista de arquivos de uma pasta usando
    comando do DOS direto de dentro do MATLAB
    E o segundo para transformar um arquivo com nomes em uma lista com os
    mesmos nomes dentro de uma vari�vel do tipo c�lula o que permite o uso
    f�cil na fun��o principal desse c�digo a "fc_corretor_arquivos"
    
%}

%% limpeza - cleaning
clc, %clear all;
%% op��o de execu��o - options
opcao = 2;
%% defini��o de lista de arquivos externo a serem abertos
% --- Os arquivos na lista devem conter os nomes dos arquivos e a extens�o do arquivo
% --- Files on the list must have the file names and the file extension
% ------- Exemplos - Examples
% --- Arquivo �nico - single file
% filelist = {'Lanterna.java'};

% --- Arquivo m�ltiplos - multiple files
% filelist = {'Lanterna.java', 'Relatorio_TCC_Include_Obj_1_0_FHZ.tex'};

% --- Caso especial - Special case
% - Cria arquivo allFilesName na PATH/pasta
% - Create file of allFilesName in a PATH/folder
% - Chamar este script � opcional - Call this script is optional
script_execute_DOS_command_from_Matlab;

% - Cria uma c�lula com a lista destes arquivos com ou sem PATH
% - Create a cell with the list of theses files with(out) the PATH
% - Chamar este script � opcional - Call this script is optional
script_allFilesName_to_ListOfFiles;

% - Seleciona use total ou partial de filelist
% - Claro que o usu�rio pode editar o arquivo ou a lista manualmente antes
% - Selects total or partial use of filelist
% - Of course user can edit the file or the list manually before
% filelist = filelist(end-8);
% filelist = filelist(5:7);
% filelist = filelist([1, 3:4, 6]);

%% Sufixo para o arquivo a ser criado com o resultado - Sufix to the new file
sufixo_file_name_resultado = '_modificado';
%% palavras chave em c�lulas - Keywords in cells
% entrada e saida com mesmo n�mero de palavras
% input and output must have the same number of words
%%{
input_keywords = {'void',...
    'false', 'true', 'public', 'class', 'private', '=', 'unsigned', 'if', 'boolean', 'Engenharia',...
    '\textbf'};
%}
%{
input_keywords = {'="', '",', '"'};
%}
%% palavras chave em c�lulas - Keywords in cells
%%{
output_keywords = {'void ',...
    'false ', 'true ', 'public ', 'class ', 'private ', ' = ', 'unsigned ', 'if ', 'boolean ', 'BATATA ',...
    '\textit'};
%}
%{
output_keywords = {' = {', '},', '}'};
%}
%% caracteres v�lidos - o circunflexo e os colchetes fazem parte do c�digo '[^ ... ]'
% Valid characters - the "^" and brackets is part of the code '[^ ... ]'
str_validacao_char  = '[^a-zA-Z_0-9(). ]';
%% fun��o corretora de arquivos em massa
% File coorrections function in butch
for ii = 1:length(filelist)
    file_name = char(filelist(ii));
    fc_corretor_arquivos(file_name, sufixo_file_name_resultado, input_keywords, output_keywords, str_validacao_char, opcao);
end
%% Fim - End