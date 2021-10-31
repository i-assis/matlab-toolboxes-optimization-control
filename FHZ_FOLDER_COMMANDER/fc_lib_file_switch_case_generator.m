%% fc_lib_file_switch_case_generator
%%%%%%%%%%%%%
% help fc_lib_file_switch_case_generator
% Belongs to private library
%%%%%%%%%%%%%
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC - Brazil)
% COPYRIGHT: Free for non evil use. (Não use este código para o mal)
%%%%%%%%%%%%%
% Function to create a string of a sistematic switch case function calls
% of a single variable of a codified/standard named files
%%%%%%%%%%%%%
% version 01: 28.02.2018 -- Creation
%%%%%%%%%%%%% Example 01
% txt = 'output = fc_num_';
% sufix = '(t,n)';
% var = 'planta';
% output = '[output]';
% fc_name = 'fc_change_my_name';
% input = '(t,n,planta)';
% N = 5; p = 3;
% str = fc_lib_file_switch_case_generator(txt,var,sufix,output,fc_name,input,p,N);
% file_name = fc_name; ext = '.m';
% fc_lib_save_file_extensao(file_name, ext, str);
%%%%%%%%%%%%% Example 02
% txt = '[w, dw] = fc_automatically_created';
% sufix = '(opcao,tsimu)';
% var = 'planta';
% output = '[w, dw]';
% input = '(opcao,tsimu,planta)';
% fc_name = 'tmp';
% N = 7; p = 2;
% str = fc_lib_file_switch_case_generator(txt,var,sufix,output,fc_name,input,p,N);
% fc_lib_save_file_extensao(fc_name, '.m', str);
%%%%%%%%%%%%%
%% algorithm
function codigo = fc_lib_file_switch_case_generator(txt,var,sufix,output,fc_name,input,p,N)
header = sprintf('function %s = %s%s', output, fc_name, input);
swt = sprintf('switch %s', var);
forma = sprintf('%s0%dd', '%', p);
str = sprintf('\t\t%s%s%s;',txt,forma,sufix);
codigo = char(sprintf('\tcase %d',1), sprintf(str,1));
for k = 2:N
    codigo = char(codigo, sprintf('\tcase %d',k), sprintf(str,k));
end
codigo = char(header, swt, codigo, 'end','end');
end