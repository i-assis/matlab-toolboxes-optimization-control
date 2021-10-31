%% fc_lib_LaTeX_fig_insert
% %%%%%%%%%%%%%%%%%%%%
% Help
% fc_lib_LaTeX_fig_insert(PATH,flags,file_name,extension,...
%     lv_up,caption_list,texfilename,linewidth)
% %%%%%%%%%%%%%%%%%%%%
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC - Brazil)
% COPYRIGHT: Free for non evil use. (Não use este código para o mal)
% %%%%%%%%%%%%%%%%%%%%
% Code to create a LaTeX file with a list of inserted Figures
% version 01: 22.02.2018 - Created 
% version 02: 02.03.2018 - name_filter added 
% %%%%%%%%%%%%%%%%%%%%
% This function uses the following library functions:
% fc_lib_createFile_AllFilesName_ListOfFiles_filter
% fc_lib_geracao_bloco_figura_LaTeX
% fc_lib_save_file_extensao -> save_file_tex
% %%%%%%%%%%%%%%%%%%%% Example
% PATH = 'Folder_where_figures_are';
% %flags = [flag_copy_to_edit_changes, flag_store_with_PATH];
% flags = [0, 1];
% file_name = 'allFilesName.txt';
% extension = {'.png'}; name_filter = {'tipo_01'}; % name_filter = 'tipo_01';
% texfilename = 'input_figuras_lv_up_1_caption_list_created';
% linewidth = 0.8;
% % --- lv_up
% %0: figures are stored in folder given by PATH1
% %1: figures are on a subfolder  given by PATH from the level up folder
% lv_up = 1;
% % --- caption_list
% % if a correct size cell is given for caption, it will be used
% % else the captions will be automatically created
% % for example: caption_list = ''.
% caption_list = '';
% % caption_list = {'First results.','Intermediate results.','Final results.'};
% name_filter = ''; % no filter
% name_filter = {'type_01'};
% fc_lib_LaTeX_fig_insert(PATH,flags,file_name,extension,...
%     lv_up,caption_list,texfilename,name_filter,linewidth)
% %%%%%%%%%%%%%%%%%%%%
% ----- End Help
%%
function fc_lib_LaTeX_fig_insert(PATH,flags,file_name,extension,...
    lv_up,caption_list,texfilename,name_filter,linewidth)

flag_copy_to_edit_changes = flags(1);
flag_store_with_PATH = flags(2);
filelist = fc_lib_createFile_AllFilesName_ListOfFiles_filter(PATH,flag_copy_to_edit_changes,flag_store_with_PATH,file_name,extension);
filelist = strrep(filelist,'\','/');
if ~strcmp(name_filter,'')
    filelist = fc_lib_ListOfFiles_filter(filelist,name_filter);
end
if isempty(filelist)
    disp('Filelist is empty. No file created.'); return;
end
ext = char(extension(1));
if lv_up == 1
    fig_adress_name_list = fc_int_fileaddress_list(filelist,PATH,ext);
else
    fig_adress_name_list = fc_int_fileaddress_list(filelist,'',ext);
end
if ischar(caption_list) || length(caption_list) ~= length(filelist)
    caption_list = fc_int_caption_list(length(filelist));
end
label_list = fc_int_label_list(filelist, PATH, ext);
str = '';
for k = 1:length(filelist)
    fig_adress_name = char(fig_adress_name_list(k));
    caption = char(caption_list(k));
    label = char(label_list(k));
    bloco = fc_lib_LaTeX_figure_block_generator(fig_adress_name, caption, label, linewidth);
    str = char(str, bloco);
end
fc_lib_save_file_extensao(texfilename, '.tex', str);
end
% =======================
% intern functions
%   accessable only from the main function
% =======================
function fig_adress_name_list = fc_int_fileaddress_list(fig_adress_name_list, PATH, ext)
if strcmp(PATH,'')
    old = {sprintf('%s',ext)};
    new = {''};
    %fig_adress_name_list = erase(filelist,old);
else
    old = {sprintf('%s',PATH), sprintf('%s',ext)};
    new = {sprintf('..%s%s','/',PATH), ''};
    %fig_adress_name_list = regexprep(filelist,old,new);
end
%fig_adress_name_list = regexprep(filelist,old,new);
for k = 1:length(old)
    fig_adress_name_list = strrep(fig_adress_name_list,char(old(k)),char(new(k)));
end
end

function caption_list = fc_int_caption_list(N)
caption_list = cell(N,1);
for k = 1:N
    caption_list(k) = {sprintf('Text %d.',k)};
end
end

function label_list = fc_int_label_list(filelist, PATH, ext)
old = {sprintf('%s%s',PATH,'/'), sprintf('%s',ext)};
new = {'fig:',''};
label_list = regexprep(filelist,old,new);
end
