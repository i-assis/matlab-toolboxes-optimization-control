function vol = volume(eli)
% MELLI/VOLUME - Gives volume of {X,Y,Z}-ellipsoid
%   
% vol = volume(elli)
%
% <elli> is a MELLI object
% If compact, matrix ellipsoid writes as
%    (M-C)' Z (M-C) <= R
% where C is the center and R is the radius
% the volume is sqrt((det(R)^m/det(Z)^p) times the volume of the unit
% sphere (where m is the nb of rows of R and p that of Z)
%
% SEE ALSO melli/center
      
%   This file is part of RoMulOC
%   Last Update 23-Nov-2012
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France
  
  if min(eig(eli.Z))>eps
    vol = sqrt((det(radius(eli)))^size(eli,2)/(det(eli.Z))^size(eli,1));
  else
    vol = Inf;
  end
