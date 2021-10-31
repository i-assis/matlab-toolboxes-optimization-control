%% fc_lib_save_variable_table
%%%%%%%%%%%%%
% help fc_lib_save_variable_table(v,z,p,filename,ext,flag_on_screen)
% Belongs to private library
%%%%%%%%%%%%%
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC)
% COPYRIGHT: Free for non evil use. (Não use este código para o mal)
%%%%%%%%%%%%%
% Function to save a variable in a datatable and/or a file
% This function uses:
%     fc_lib_backup_filename
%%%%%%%%%%%%%
% version 01: 29.09.2017 -- Creation
% version 02: 02.10.2017 -- Small corrections
% version 03: 28.12.2017 -- flag_on_screen has been created
% version 04: 16.06.2019 -- Updating version notes to English
%     Updating name to: fc_lib_save_variable_table
% version 05: 16.07.2019 -- Updating tb, removing "\\" from the last line
%     Adding new example
%     Replacing tb to a new function of latex_library
%       fc_lib_latex_tab_num
%%%%%%%%%%%%%
% fc_lib_save_variable_table(v,z,p,filename,ext,flag_on_screen)
% v: data matrix
% z: # of digits to the left, if negative the function use the
%    # of digits of the maximum value of v
% p: # of decimal places
% filename: without space, accents or punctuation
% ext: extension of file without period
% flag_on_screen: Shows on screen the result of the command "type"
% ---
% Visualize data with: type tmp.txt; type tmp.dat; etc
% ---
% %
% This funcion also saves a .mat file with v and tb
% tb is a LaTeX formatted Table
%   since "version 05", tb has been replaced into: fc_lib_latex_tab_num
%%%%%%%%%%%%% Example 01
% v = rand(20,5);
% fc_lib_save_variable_table(v,-1,4,'teste','dat',1);
%%%%%%%%%%%%% Example 02
% v = 100*randn(11,4);
% fc_lib_save_variable_table(v,3,2,'teste','dat',0);
%%%%%%%%%%%%% 
% load('teste_yyyymmdd_hhmmss.mat'); % vide arquivo de backup
% fc_lib_save_file_extensao('tabelaLaTeX','.tex', tb);
%%%%%%%%%%%%%
%% algorithm
function fc_lib_save_variable_table(v,z,p,filename,ext,flag_on_screen)
%% strings for right and left of period places
m = size(v,1);
fid = fopen(sprintf('%s.%s',filename, ext),'w');
if z < 0
    x = max(max(abs(v))); % maior valor da matriz
    z = ceil(log10(x)); % número de casas à esquerda da vírgula
end
str_base = sprintf('%s+0%d.%df ', '%', z+p+2, p);
str = '';
for i = 1:m
    % str = sprintf('%s%s+0%d.%df ', str, '%', z+p+2, p);
    str = sprintf('%s%s', str, str_base);
end
%% Salvando v no arquivo externo pedido
fprintf(fid,sprintf('%s%s', str, '\n'), v); %fprintf(fid,'%1.4f %1.4f\n',v);
fclose(fid);
if flag_on_screen == 1
    type(sprintf('%s.%s',filename, ext))
end
%% tb para tabela em LaTeX
% for i = 1:n
%     for j = 1:m
%         if j == 1
%             l = sprintf(sprintf('%s',str_base), v(i,j));
%         else
%             l = sprintf(sprintf('%s & %s',str_base, l), v(i,j));
%         end
%     end
%     if i ~= size(v,1)
%         l = sprintf('%s %s', l, '\\');
%     end
%     if i == 1, tb = l; else, tb = char(tb, l); end
% end
% c = repmat('c',1,m);
% tb = char(sprintf('\\begin{tabular}{%s}', c), tb, '\end{tabular}');
%% salvando v, tb em .mat
filename = fc_lib_backup_filename(filename);
save(filename, 'v');
%save(filename, 'v', 'tb');
end