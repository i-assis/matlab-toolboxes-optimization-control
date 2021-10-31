function display(S);
% DISPLAY - display a USSMODEL object describing an LTI system

%   This file is part of RoMulOC
%   Last Update 30-Oct-2013
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

  if S.ssmodel.nb
    fprintf('Uncertain model : %s\n',S.type);
    fprintf('-------- WITH --------\n');
    switch S.type
      case {'LFT','certain'}
        display(S.ssmodel)
      otherwise
        display(S.ssmodel,1)
    end
  else
    fprintf('Empty ssmodel object\n');
  end
  if any(size(S.uncertainty))
    fprintf('-------- AND  --------\n');
    display(S.uncertainty)
  end
