%% fc_lib_LaTeX_figure_block_generator
% %%%%%%%%%%%%%%%%%%%%
% Help
% fc_lib_LaTeX_figure_block_generator(fig_adress_name, caption, label, linewidth)
% %%%%%%%%%%%%%%%%%%%%
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC - Brazil)
% COPYRIGHT: Free for non evil use. (Não use este código para o mal)
% %%%%%%%%%%%%%%%%%%%%
% Code to create a block of figure insertion for LaTeX with my custom
% command \figIncLongCap
% Maybe some day it will become interchangeable
% %%%%%%%%%%%%%%%%%%%% Example
% fig_adress_name = 'fig_results';
% caption = 'Caption';
% label = 'fig:fig_results';
% linewidth = 0.8;
% bloco = fc_lib_LaTeX_figure_block_generator(fig_adress_name, caption, label, linewidth)
% %%%%%%%%%%%%%%%%%%%%
% ----- End Help
%%
function bloco = fc_lib_LaTeX_figure_block_generator(fig_adress_name, caption, label, linewidth)
%% bloco figure
l1 = '\begin{figure}[H]';
l2 = '\figIncLongCap';
%l3 = '{width = 0.8\linewidth, keepaspectratio}';
l3 = sprintf('{width = %g%slinewidth, keepaspectratio}',linewidth,'\');
l7 = '\end{figure}';
%% Montagem de str
bloco = sprintf('%s', l1);
bloco = char(bloco, sprintf('\t%s', l2));
bloco = char(bloco, sprintf('\t%s', l3));
bloco = char(bloco, sprintf('\t{%s}', sprintf('%s',fig_adress_name)));
bloco = char(bloco, sprintf('\t{%s}', caption));
bloco = char(bloco, sprintf('\t%slabel{%s}', '\', label));
bloco = char(bloco, sprintf('%s', l7), '');
end