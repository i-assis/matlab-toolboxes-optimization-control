%% fc_lib_control_get_ABCD_from_sys
%%%%%%%%%%%%% 
% help fc_lib_control_get_ABCD_from_sys
% Belongs to private library 
%%%%%%%%%%%%% 
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC) 
% COPYRIGHT: Free for non evil use. (Não use este código para o mal) 
%%%%%%%%%%%%% 
% [A,B,C,D] = fc_lib_control_get_ABCD_from_sys(sys)
% This function returns the matrices A,B,C,D from a state space sys object
%%%%%%%%%%%%% 
% version 01: 13.08.2018 
%     Criação
%%%%%%%%%%%%% Example 01
% sys = rss(2,1,1);
% [A,B,C,D] = fc_lib_control_get_ABCD_from_sys(sys)
%%%%%%%%%%%%% Example 02
% sys = rss(2,1,3);
% [A,B,C,D] = fc_lib_control_get_ABCD_from_sys(sys)
%%%%%%%%%%%%% Example 03
% sys = rss(2,2,2);
% [A,B,C,D] = fc_lib_control_get_ABCD_from_sys(sys)
%%%%%%%%%%%%% 
%% algorithm 
function [A,B,C,D] = fc_lib_control_get_ABCD_from_sys(sys)
A = sys.a; B = sys.b; C = sys.c; D = sys.d;
end