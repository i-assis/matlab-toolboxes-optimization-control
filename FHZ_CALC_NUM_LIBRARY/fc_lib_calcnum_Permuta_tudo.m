%% fc_lib_calcnum_Permuta_tudo
%%%%%%%%%%%%%
% help fc_lib_calcnum_Permuta_tudo
% Belongs to private library
%%%%%%%%%%%%%
% Author: M.Eng. Fernando Henrique G. Zucatelli (UFABC)
% COPYRIGHT: Free for non evil use. (Não use este código para o mal)
%%%%%%%%%%%%%
% fc_lib_calcnum_Permuta_tudo(A)
%%%%%%%%%%%%%
% version 01: 04.04.2018 -- Creation
%   02.06.2019: Syntax revision
%%%%%%%%%%%%% Example
% A = randi(10,3,3);
% [M, p] = fc_lib_calcnum_Permuta_tudo(A);
%%%%%%%%%%%%%
%% algorithm
function [M, p] = fc_lib_calcnum_Permuta_tudo(A)
M = A;
L = size(M,1);
p = eye(L);
for i = 1:L
    [el_max, pos_max] = max(abs(A(i,:)));
    if (abs(el_max) ~= 0)
        if el_max ~= M(i,1)
            M_temp = M(i,:);
            M(i,:) = M(pos_max,:);
            M(pos_max,:) = M_temp;
            p_temp = p(i,:);
            p(i,:) = p(pos_max,:);
            p(pos_max,:) = p_temp;
        end
    else
        fprintf('Matriz é singular\n');
        return;
    end
    Lo = eye(L); % Criar a identidade de tamanho Linhas de M
    for j = i+1:L
        m = M(j,i)/M(i,i);
        M(j,:) = M(j,:) - m*M(i,:);
        Lo(j,i) = m; %Esta já é a inv(Lo) pois Lo teria -m
    end
end
end