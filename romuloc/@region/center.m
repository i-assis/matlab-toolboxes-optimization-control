function C = center(reg)
% REGION/CENTER - Gives center of disc-type regions
%   
% C = center(reg)
%
% where <reg> is a REGION object
% outputs (if exists) the center of the region
%
% SEE ALSO region, region/rand
      
%   This file is part of RoMulOC
%   Last Update 4-Mar-2013
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France
  
  R=reg.mat{1}{1};
  
  if abs(R(2,2))>eps
    C = -R(2,1)/R(2,2);
  else
    C = Inf;
  end
