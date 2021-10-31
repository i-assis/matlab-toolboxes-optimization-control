%% fc_corretor_arquivos
% %%%%%%%%%%%%%%%%%%%%
% Help
% %%%%%%%%%%%%%%%%%%%%
% Author: Fernando Henrique G. Zucatelli (UFABC - Brazil)
% COPYRIGHT: Free for non evil use. (N�o use este c�digo para o mal)
% %%%%%%%%%%%%%%%%%%%%
% 
% Code correct any input_keyword for the respective output_keyword
% of a given file.
% Creating a modified copy of it at the same folder
%
% %%%%%%%%%%%%%%%%%%%%
% ----- End Help

% Hist�rico - History
%{
Autor: Fernando Henrique G. Zucatelli (UFABC - Brasil)
        
Script de corre��o de c�digo em um programa
vers�o 01:
03.11.2016
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
    Adicionada op��es de altera��es conforme
    opcao:
    1 - Apenas string valida
    2 - Localizar e substituir em massa
05.01.2017
    Editando textos para ingl�s e publica��o na Mathworks
21.03.2017
    Editando cabe�alho
%}
function fc_corretor_arquivos(file_name, sufixo_file_name_resultado, input_keywords, output_keywords, str_validacao_char, opcao)

%% limpeza - cleaning
fprintf('Iniciando - Start fc_corretor_arquivos ...\n\topcao - option: %d\n', opcao);
%% abertura arquivo externo - open external file
if exist(file_name, 'file')
    fid = fopen(file_name, 'r');
else
    fprintf('O arquivo: %s n�o existe\nFile: %s does not exist\n', file_name, file_name);
    return; 
end
%fline = fgetl(fid);
%% verifica��o de tamanho - size verification
if size(input_keywords) ~= size(output_keywords)
    fprintf('Tamanho de input_keywords e output_keywords diferentes\n');
    fprintf('Size of input_keywords and output_keywords are different\n');
    return;
end
%% la�o procura em todas as linhas do arquivo - loop searching for every file line
while 1
    % === pega uma linha do arquivo - get a file line
    tline = fgetl(fid);
    % === crit�rio de sa�da quando n�o encontra mais linha - exit criterium and do not find a line
    if ~ischar(tline)
        break;
    end
    %disp(tline);
    %% switch opcao - switch option
    switch opcao
        case 1
            % === remo��o de caracteres n�o v�lidos - remove invalid char
            str = regexprep(tline, str_validacao_char, '');
            % fprintf('%s\n', str);
        case 2
            % === Remove os espa�os - remove spaces
            % str = strrep(tline, ' ', '');
            str = tline;
            % === procura pelas palavras chaves e corre��o - search for
            % words and corrections
            for i = 1:length(input_keywords)
                str = strrep(str, sprintf('%s',char(input_keywords(i))),...
                    sprintf('%s', char(output_keywords(i))) );
%                 if strcmp( char(input_keywords(end)), char(input_keywords(i)))
%                     fprintf('%s\n', str);
%                 end
            end
            % fprintf('%s\n', str);
        otherwise
            fprintf('opcao n�o encontrada - option not found\n');
    end
    
    % === cria��o do resultado dinamicamente - dynamical creation of results
    if ~exist('string_to_file','var')
        string_to_file = str;
    else
        string_to_file = char(string_to_file, str);
    end
end
fclose(fid);
%% cria��o arquivo do resultado - Creating file with results
% --- fun��o que obt�m a extens�o do arquivo fornecido
% --- function to get file extension
str_ext = fc_obter_extensao(file_name);
% --- controle do nome do arquivo modificado
% --- control of modified file name
if isempty(sufixo_file_name_resultado) || strcmp(sufixo_file_name_resultado, ' ')
    sufixo_file_name_resultado = '_Copia';
end
file_name_resultado = strrep(file_name,str_ext,...
    sprintf('%s',sufixo_file_name_resultado));
% === fun��o externa que guarda a string no formato pedido - usa "save_file_tex.p"
% === extern function to store string with desired file format - uses "save_file_tex.p"
fc_ext_save_file_extensao(file_name_resultado, str_ext, string_to_file);
fprintf('\nConcluido - Finished\n');

% Auxiliary codes used while developing and learning
%{
% criacao da string a ser editada - creation of string to be edited
str = sprintf('%s%s%s_%s',char(keywords(1)), char(keywords(2)), char(keywords(3)), str_naoValidos)
fprintf('%s\n', str);

% remo��o de caracteres n�o v�lidos - removing undesired characters
str = regexprep(str, str_validacao_char, ''); %Remove caracteres especiais
fprintf('%s\n', str);

% procura pelas palavras chaves e corre��o - search for words and correction
for i = 1:length(keywords)
str = strrep(str, sprintf('%s',char(keywords(i))), sprintf('%s ', char(keywords(i))) );
fprintf('%s\n', str);
end
%}