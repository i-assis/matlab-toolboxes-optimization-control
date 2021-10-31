%% fc_lib_backup_filename
%%%%%%%%%%%%%
% help fc_lib_backup_filename
% Belongs to private library
%%%%%%%%%%%%%
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC - Brazil)
% COPYRIGHT: Free for non evil use. (Não use este código para o mal)
%%%%%%%%%%%%%
% filename_backup = fc_lib_backup_filename(filename)
% Function to add date and time to a string.
%     Useful as chronological and undubious backup method.
%     Date and Time are based on ISO 8601. Therefore it should be free of
%     country and/or language local standards.
%%%%%%%%%%%%%
% version 01: 27.09.2017 - Creation
%       Alterando o script para uso como função
%       Mais compacto e versátil
% version 02: 16.06.2019 - Updating version notes to English
%     Preserving old version notes in Portuguese
%%%%%%%%%%%%% Example 00
% nova_string = fc_lib_backup_filename(string)
% nova_string = 'string_yyyymmdd_hhmmss'
%%%%%%%%%%%%%
% Source: https://pt.wikipedia.org/wiki/ISO_8601
%%%%%%%%%%%%%
%% algorithm
function filename_backup = fc_lib_backup_filename(filename)
dh = clock; str = '';
for k = 1:length(dh)
    if k == 4, str = sprintf('%s_',str); end
    str = sprintf('%s%02.0f',str,dh(k));
end
filename_backup = sprintf('%s_%s', filename, str);
end