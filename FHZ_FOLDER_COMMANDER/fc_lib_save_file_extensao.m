%% fc_lib_save_file_extensao
%%%%%%%%%%%%%
% help fc_lib_save_file_extensao
% Belongs to private library
%%%%%%%%%%%%%
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC)
% COPYRIGHT: Free for non evil use. (Não use este código para o mal)
%%%%%%%%%%%%%
% This function calls save_file_tex to create a file with file_name of the
% extension str_ext with the contents of the string_to_file string
%%%%%%%%%%%%%
% version 01: 06.06.2016 - Creation
% version 02: 16.01.2019 - Options of many input argument added to handle "encod"
%       If "encod" not informed, default encoding is ISO-8859-1
% % encod options
% % encod = 'US-ASCII';
% % encod = 'Windows-1252';
% % encod = 'ISO-8859-1';
% % encod = 'Shift_JIS';
% % encod = 'UTF-8';
%%%%%%%%%%%%% About file encoding
% currentCharacterEncoding = slCharacterEncoding();
% slCharacterEncoding(encoding);
%%%%%%%%%%%%% About varargin AND nargin
% Source: https://www.mathworks.com/help/matlab/matlab_prog/support-variable-number-of-inputs.html
%%%%%%%%%%%%% Example 01
% string_to_file = char('á é í ó ú', 'linha 1', 'linha 2');
% str_ext = '.tex'; file_name = 'tmp';
% fc_lib_save_file_extensao(file_name, str_ext, string_to_file);
%%%%%%%%%%%%% Example 02
% syms alpha;
% string_to_file = char('á é í ó ú', '$x_1$', '$\theta$', sprintf('$%s$',latex(alpha)));
% str_ext = '.tex'; file_name = 'tmp';
% fc_lib_save_file_extensao(file_name, str_ext, string_to_file);
%%%%%%%%%%%%% Example 03 - encoding selection
% syms alpha;
% string_to_file = char('á é í ó ú', '$x_1$', '$\theta$', sprintf('$%s$',latex(alpha)));
% str_ext = '.tex'; file_name = 'tmp_encod';
% encod = 'UTF-8';
% fc_lib_save_file_extensao(file_name, str_ext, string_to_file, encod);
%%%%%%%%%%%%%
%% algorithm
function fc_lib_save_file_extensao(file_name, str_ext, string_to_file, varargin)
if nargin == 3 % || nargin == 0
    fid = fopen([file_name,str_ext],'w');
else
    fid = fopen([file_name,str_ext],'w', 'native', char(varargin{1}));
end
save_file_tex(fid, string_to_file);
fclose(fid);
end