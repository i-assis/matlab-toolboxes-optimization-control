%% fc_lib_write_matrix_text
%%%%%%%%%%%%%
% help fc_lib_write_matrix_text
% Belongs to private library
%%%%%%%%%%%%%
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC - Brazil)
% COPYRIGHT: Free for non evil use. (Não use este código para o mal)
%%%%%%%%%%%%%
% Function to write a matrix on a .m file
% z: # of zeros at the left of comma/point
% p: # of decimals
%%%%%%%%%%%%%
% version 01: 06.04.2019 - Creation
% version 02: 16.06.2019 - Updating version notes to English
%     Updating function name to English
%%%%%%%%%%%%%  Example 01
% v = randn(4,3); z = 1; p = 14; var = 'A';
% fid = fopen('tmp.tex','w');
% fc_lib_write_matrix_text(v,z,p,var,fid);
% fclose(fid);
%%%%%%%%%%%%%  Example 02
% v = 10*randn(5,6); z = 3; p = 10; var = 'M';
% fid = fopen('tmp.txt','w');
% fc_lib_write_matrix_text(v,z,p,var,fid);
% fclose(fid);
%%%%%%%%%%%%%
%% algorithm
function fc_lib_write_matrix_text(v,z,p,var,fid)
if z < 0
    x = max(max(abs(v))); % maior valor da matriz
    z = ceil(log10(x)); % número de casas à direita da vírgula
end
str_base = sprintf('%s+0%d.%df ', '%', z+p+2, p);
str = '';
for k = 1:size(v,2)
    % str = sprintf('%s%s+0%d.%df ', str, '%', z+p+2, p);
    str = sprintf('%s%s', str, str_base);
end
%% Escrevendo v em texto
fprintf(fid, '%s = [...\n', var);
fprintf(fid, sprintf('%s%s', str, '\n'), v); %fprintf(fid,'%1.4f %1.4f\n',v);
fprintf(fid, '];\n');
end