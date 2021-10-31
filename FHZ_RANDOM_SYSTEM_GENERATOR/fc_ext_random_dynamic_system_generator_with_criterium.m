%% fc_ext_random_dynamic_system_generator_with_criterium
%%%%%%%%%%%%%
% help fc_ext_random_dynamic_system_generator_with_criterium
% Belongs to private library
%%%%%%%%%%%%%
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC)
% COPYRIGHT: Free for non evil use. (Não use este código para o mal)
%%%%%%%%%%%%%
% fc_ext_random_dynamic_system_generator_with_criterium ...
% Description
%%%%%%%%%%%%%
% versão 01: 13.08.2018
%     Creation
%%%%%%%%%%%%% Example
% sys = fc_ext_random_dynamic_system_generator_with_criterium(N)
%%%%%%%%%%%%%
function S = fc_ext_random_dynamic_system_generator_with_criterium(N,P,M,qtd)
%% -- defining a structure
S = struct;
%% aux -
k = 1; l = 1; LIM = 100*qtd;
%%
while k <= qtd && l <= LIM
    sys = rss(N,P,M);
    QS = ctrb(sys.a,sys.b);
    if rank(QS) >= min(size(sys.a))
        % -- flexible writing in a structure
        S.(sprintf('sys%d',k)) = sys;
        k = k + 1;
    end
    l = l + 1;
end
if l >= LIM
   disp('Error: Attempts limit exceeded');
end
end