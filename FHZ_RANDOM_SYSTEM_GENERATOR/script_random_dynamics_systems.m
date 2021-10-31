%% script_random_dynamics_systems
%% cleaning
clear; close all; clc;
%%
din = 2;
out = 1;
inp = 1;
qtd = 5;
S = fc_ext_random_dynamic_system_generator_with_criterium(din,out,inp,qtd);
%% folder creation and base name definition
folder = 'tmp_folder';
if ~exist(folder,'dir'); mkdir(folder); end
base = 'fc_ext_created_sys';
call_name = 'function [A,B,C,D] =';
%% At least 1 digit at left and always 17 at the right side of comma
z = 1; p = 17;
%% loop
for k = 1:qtd
    % ---- creating files
    file_name = sprintf('%s/%s_%03d',folder,base,k);
    fid = fopen([file_name,'.m'],'w');
    % ---- writing function call
    fc_call = sprintf('%s %s_%03d',call_name, base,k);
    fprintf(fid, '%s \n', fc_call);
    % ----- system
    sys = S.(sprintf('sys%d',k));
    [A,B,C,D] = fc_lib_control_get_ABCD_from_sys(sys);
    fc_lib_control_generate_ABCD_matrices_file(A,B,C,D,z,p,fid);
    fprintf(fid, 'end');
    fclose(fid);
end

