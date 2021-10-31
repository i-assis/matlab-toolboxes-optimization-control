function R = radius(eli)
% MELLI/RADIUS - Gives radius of {X,Y,Z}-ellipsoid
%   
% R = radius(elli)
%
% <elli> is a MELLI object
% If compact, matrix ellipsoid write as
%    (M-C)' Z (M-C) <= R
% where C is the center and R is the radius
%
% SEE ALSO melli/center
      
%   This file is part of RoMulOC
%   Last Update 31-Jan-2005
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France
  
  if min(eig(eli.Z))>eps
    R = eli.Y*inv(eli.Z)*eli.Y'-eli.X;
  else
    R = Inf;
  end

