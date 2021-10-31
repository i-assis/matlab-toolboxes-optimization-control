%% fc_lib_copyfile_oldversion
%%%%%%%%%%%%%
% help fc_lib_copyfile_oldversion
% Belongs to private library
%%%%%%%%%%%%%
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC)
% COPYRIGHT: Free for non evil use. (Não use este código para o mal)
%%%%%%%%%%%%%
% Function to create a old-version-copy of a given file into a given folder
%%%%%%%%%%%%%
% version 01: 23.07.2019 -- Creation
% version 02: 23.07.2019 -- pasta and ext are varargin inputs
%%%%%%%%%%%%% Example 01
% file_name = 'fc_lib_copyfile_oldversion';
% fc_lib_copyfile_oldversion(file_name);
%%%%%%%%%%%%% Example 02
% file_name = 'fc_lib_copyfile_oldversion';
% pasta = 'old_versions';
% fc_lib_copyfile_oldversion(file_name, pasta);
%%%%%%%%%%%%% Example 03
% file_name = 'fc_lib_copyfile_oldversion';
% pasta = 'old_versions'; ext = '';
% fc_lib_copyfile_oldversion(file_name, pasta, ext);
%%%%%%%%%%%%% Example 04
% file_name = 'fc_lib_copyfile_oldversion';
% pasta = 'old_versions';
% fc_lib_copyfile_oldversion(file_name, pasta, '.m');
%%%%%%%%%%%%%
%% algorithm
function fc_lib_copyfile_oldversion(file_name, varargin)
%% Creating folder and securing correct ext
if nargin == 2
    pasta  = char(varargin{1});
    ext = '.m';
elseif nargin == 3
    pasta  = char(varargin{1});
    ext = char(varargin{2});
    if strcmp(ext, ''); ext = '.m'; end
else
    pasta = 'old_versions';
    ext = '.m';
end
%% Creating folder and correct filename
if ~exist(pasta, 'dir'); mkdir(pasta); end
file_name_ext = sprintf('%s%s', file_name, ext);
%% Analysis of old copies and updating count
sufix = '_old_';
count = 1;
file_name_ext_destination = sprintf('%s/%s%s%02d%s', pasta, file_name, ...
    sufix, count, ext);
while exist(file_name_ext_destination, 'file')
    count = count + 1;
    file_name_ext_destination = sprintf('%s/%s%s%02d%s', pasta, file_name, ...
    sufix, count, ext);
end
%% Copy file with correct old version number
copyfile(file_name_ext, file_name_ext_destination);
end