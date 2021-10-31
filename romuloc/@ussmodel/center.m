function sys = center(usys)
% USSMODEL/CENTER - Get the central system
% 
% sys = center(usys)
%
% if 'usys' is LFT then 'sys' 
%    is the closed-loop with central uncertainty (SEE uncertainty/center)
% if 'usys' is parallelotopic, or interval
%    then 'sys' is center of the set
% if 'usys' is polytopic
%    then 'sys' is the sum of vertices divided by their number
%
% SEE ALSO ussmodel
    
%   This file is part of RoMulOC
%   Last Update 26-Nov-2012
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

switch usys.type(1:3)
   case 'LFT'
     sys=certain(usys.ssmodel,center(usys.uncertainty));
  otherwise  
    sys = nominal(usys.ssmodel,usys.type(1:3));
  end;
 