function sys = nominal(usys)
% USSMODEL/NOMINAL - Get the nominal system
% 
% sys = nominal(usys)
%
% if 'usys' is LFT then 'sys' 
%    is the closed-loop with zero uncertainty
% if 'usys' is polytopic, parallelotopic, or interval
%    then 'sys' is center of the set
%
% SEE ALSO ussmodel
    
%   This file is part of RoMulOC
%   Last Update 23-May-2013
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

if isequal(usys.type(1:3),'LFT')
  sys = certain(usys.ssmodel,nominal(usys.uncertainty));
else
  sys = nominal(usys.ssmodel,usys.type(1:3));
end