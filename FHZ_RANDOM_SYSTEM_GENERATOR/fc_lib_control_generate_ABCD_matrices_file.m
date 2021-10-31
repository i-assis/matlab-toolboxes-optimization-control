%% fc_lib_control_generate_ABCD_matrices_file
%%%%%%%%%%%%%
% help fc_lib_control_generate_ABCD_matrices_file
% Belongs to private library
%%%%%%%%%%%%%
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC)
% COPYRIGHT: Free for non evil use. (Não use este código para o mal)
%%%%%%%%%%%%%
% fc_lib_control_generate_ABCD_matrices_file(A,B,C,D,z,p,fid)
% This function writes the matrices A,B,C,D in the file fid
%%%%%%%%%%%%%
% version 01: 13.08.2018
%     Criação
%%%%%%%%%%%%% Example
% z = 1; p = 17; sys = rss(3,1,1);
% [A,B,C,D] = fc_lib_control_get_ABCD_from_sys(sys);
% fc_lib_control_generate_ABCD_matrices_file(A,B,C,D,z,p,fid);
%%%%%%%%%%%%%
%% algorithm
function fc_lib_control_generate_ABCD_matrices_file(A,B,C,D,z,p,fid)
fc_lib_escrita_matriz_texto(A,z,p,'A',fid);
fc_lib_escrita_matriz_texto(B,z,p,'B',fid);
fc_lib_escrita_matriz_texto(C,z,p,'C',fid);
fc_lib_escrita_matriz_texto(D,z,p,'D',fid);
end