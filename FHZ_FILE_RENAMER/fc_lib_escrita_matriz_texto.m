%% fc_lib_escrita_matriz_texto
% %%%%%%%%%%%%%%%%%%%%
% Help
% fc_lib_escrita_matriz_texto(v,z,p,var,fid)
% Pertence à biblioteca particular
% %%%%%%%%%%%%%%%%%%%%
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC - Brazil)
% COPYRIGHT: Free for non evil use. (Não use este código para o mal)
% %%%%%%%%%%%%%%%%%%%%
% Code write a matrix on a .m file
% %%%%%%%%%%%%%%%%%%%% Example
% v = randn(4,3); z = 1; p = 14; var = 'A';
% fc_lib_escrita_matriz_texto(v,z,p,var)
%%%%%%%%%%%%%%%%%%%%
% ----- End Help

function fc_lib_escrita_matriz_texto(v,z,p,var,fid)
if z < 0
    x = max(max(abs(v))); % maior valor da matriz
    z = ceil(log10(x)); % número de casas à direita da vírgula
end
str_base = sprintf('%s+0%d.%df ', '%', z+p+2, p);
str = '';
for ii = 1:size(v,2)
    % str = sprintf('%s%s+0%d.%df ', str, '%', z+p+2, p);
    str = sprintf('%s%s', str, str_base);
end
%% Escrevendo v em texto
fprintf(fid, '%s = [...\n', var);
fprintf(fid, sprintf('%s%s', str, '\n'),v); %fprintf(fid,'%1.4f %1.4f\n',v);
fprintf(fid, '];\n', var);
end