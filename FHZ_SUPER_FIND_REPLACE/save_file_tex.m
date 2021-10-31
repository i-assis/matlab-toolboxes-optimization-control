function save_file_tex(fid, str_latex)
[l_str_latex c_str_latex] = size(str_latex);
for ii = 1:l_str_latex
    str_latex_file_buffer = str_latex(ii,:);
    for jj = c_str_latex:-1:1
        if  str_latex_file_buffer(jj) == ' '
            str_latex_file_buffer(jj) = '';
        else
            break;
        end
    end
    if ii == l_str_latex
        fprintf(fid, '%s', str_latex_file_buffer);
    else
        fprintf(fid, '%s\n', str_latex_file_buffer);
    end
end