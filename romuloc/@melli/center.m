function C = center(eli)
% MELLI/CENTER - Gives center of {X,Y,Z}-ellipsoid
%   
% C = center(elli)
%
% where <elli> is a MELLI object
% outputs (if exists) the center of the ellipsoid
%
% SEE ALSO melli, melli/radius, melli/rande
      
%   This file is part of RoMulOC
%   Last Update 31-Jan-2005
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France
  
  if min(eig(eli.Z))>eps
    C = -inv(eli.Z)*eli.Y';
  else
    C = Inf;
  end
