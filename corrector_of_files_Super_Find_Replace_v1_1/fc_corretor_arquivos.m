%% fc_corretor_arquivos
% %%%%%%%%%%%%%%%%%%%%
% Help
% %%%%%%%%%%%%%%%%%%%%
% Author: Fernando Henrique G. Zucatelli (UFABC - Brazil)
% COPYRIGHT: Free for non evil use. (Não use este código para o mal)
% %%%%%%%%%%%%%%%%%%%%
% 
% Code correct any input_keyword for the respective output_keyword
% of a given file.
% Creating a modified copy of it at the same folder
%
% %%%%%%%%%%%%%%%%%%%%
% ----- End Help

% Histórico - History
%{
Autor: Fernando Henrique G. Zucatelli (UFABC - Brasil)
        
Script de correção de código em um programa
versão 01:
03.11.2016
    Criação do arquivo.
        Abertura de arquivo externo fopen
            Seleção linha por linha
            Executando remoção de caracteres indesejados
            Alterando caracteres de palavras chave conforme desejado
versão 02:
11.11.2016
    Desmembrando preparo de variáveis da execução de comandos
    Preparo:
        initial_corretor_arquivos
    Execução encapsulada:
        fc_corretor_arquivos
    Adicionada opções de alterações conforme
    opcao:
    1 - Apenas string valida
    2 - Localizar e substituir em massa
05.01.2017
    Editando textos para inglês e publicação na Mathworks
21.03.2017
    Editando cabeçalho
%}
function fc_corretor_arquivos(file_name, sufixo_file_name_resultado, input_keywords, output_keywords, str_validacao_char, opcao)

%% limpeza - cleaning
fprintf('Iniciando - Start fc_corretor_arquivos ...\n\topcao - option: %d\n', opcao);
%% abertura arquivo externo - open external file
if exist(file_name, 'file')
    fid = fopen(file_name, 'r');
else
    fprintf('O arquivo: %s não existe\nFile: %s does not exist\n', file_name, file_name);
    return; 
end
%fline = fgetl(fid);
%% verificação de tamanho - size verification
if size(input_keywords) ~= size(output_keywords)
    fprintf('Tamanho de input_keywords e output_keywords diferentes\n');
    fprintf('Size of input_keywords and output_keywords are different\n');
    return;
end
%% laço procura em todas as linhas do arquivo - loop searching for every file line
while 1
    % === pega uma linha do arquivo - get a file line
    tline = fgetl(fid);
    % === critério de saída quando não encontra mais linha - exit criterium and do not find a line
    if ~ischar(tline)
        break;
    end
    %disp(tline);
    %% switch opcao - switch option
    switch opcao
        case 1
            % === remoção de caracteres não válidos - remove invalid char
            str = regexprep(tline, str_validacao_char, '');
            % fprintf('%s\n', str);
        case 2
            % === Remove os espaços - remove spaces
            % str = strrep(tline, ' ', '');
            str = tline;
            % === procura pelas palavras chaves e correção - search for
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
            fprintf('opcao não encontrada - option not found\n');
    end
    
    % === criação do resultado dinamicamente - dynamical creation of results
    if ~exist('string_to_file','var')
        string_to_file = str;
    else
        string_to_file = char(string_to_file, str);
    end
end
fclose(fid);
%% criação arquivo do resultado - Creating file with results
% --- função que obtém a extensão do arquivo fornecido
% --- function to get file extension
str_ext = fc_obter_extensao(file_name);
% --- controle do nome do arquivo modificado
% --- control of modified file name
if isempty(sufixo_file_name_resultado) || strcmp(sufixo_file_name_resultado, ' ')
    sufixo_file_name_resultado = '_Copia';
end
file_name_resultado = strrep(file_name,str_ext,...
    sprintf('%s',sufixo_file_name_resultado));
% === função externa que guarda a string no formato pedido - usa "save_file_tex.p"
% === extern function to store string with desired file format - uses "save_file_tex.p"
fc_ext_save_file_extensao(file_name_resultado, str_ext, string_to_file);
fprintf('\nConcluido - Finished\n');

% Auxiliary codes used while developing and learning
%{
% criacao da string a ser editada - creation of string to be edited
str = sprintf('%s%s%s_%s',char(keywords(1)), char(keywords(2)), char(keywords(3)), str_naoValidos)
fprintf('%s\n', str);

% remoção de caracteres não válidos - removing undesired characters
str = regexprep(str, str_validacao_char, ''); %Remove caracteres especiais
fprintf('%s\n', str);

% procura pelas palavras chaves e correção - search for words and correction
for i = 1:length(keywords)
str = strrep(str, sprintf('%s',char(keywords(i))), sprintf('%s ', char(keywords(i))) );
fprintf('%s\n', str);
end
%}