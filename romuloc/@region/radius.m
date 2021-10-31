function r = radius(reg)
% REGION/RADIUS - get radius of region object
% 
% r = radius(reg)
%
% SEE ALSO region

%   This file is part of RoMulOC
%   Last Update 31-May-2011
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

mat=reg.mat{1}{1};
r=inv(mat(2,2))*sqrt(-(mat(2,2)*mat(1,1)-mat(1,2)*mat(2,1)));