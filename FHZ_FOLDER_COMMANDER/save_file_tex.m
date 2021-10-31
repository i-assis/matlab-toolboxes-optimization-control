%% save_file_tex
%%%%%%%%%%%%%
% help save_file_tex
% Belongs to private library
%%%%%%%%%%%%%
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC)
% COPYRIGHT: Free for non evil use. (Não use este código para o mal)
%%%%%%%%%%%%%
% Function to write a string of any size into a file
%     It works better when writing into a .tex file,
%     but it also works with .txt, .m, etc.
%%%%%%%%%%%%%
% version 01: 06.05.2016 -- Creation
% version 02: 16.06.2019 - Updating version notes to English
%     Changing name of variables "ii", "jj" into "i", "j"
%     Adding examples of usage
%%%%%%%%%%%%% Example 01
% str_latex = char('line 1', 'line 2', 'line 3');
% fid = fopen(['tmp','.tex'],'w');
% % fid = fopen(['tmp','.txt'],'w');
% save_file_tex(fid, str_latex);
% fclose(fid);
%%%%%%%%%%%%%
%% algorithm
function save_file_tex(fid, str_latex)
[l_str_latex, c_str_latex] = size(str_latex);
for i = 1:l_str_latex
    str_latex_file_buffer = str_latex(i,:);
    for j = c_str_latex:-1:1
        if  str_latex_file_buffer(j) == ' '
            str_latex_file_buffer(j) = '';
        else
            break;
        end
    end
    if i == l_str_latex
        fprintf(fid, '%s', str_latex_file_buffer);
    else
        fprintf(fid, '%s\n', str_latex_file_buffer);
    end
end