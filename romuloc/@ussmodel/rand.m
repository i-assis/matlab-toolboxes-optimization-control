function out = rand(in,dilat)
% USSMODEL/RAND - Random value of a USSMODEL
%	
%  sys = rand(usys)
%
% SEE ALSO isin
  
%   This file is part of RoMulOC
%   Last Update 15-Oct-2012
%   author : Dimitri Peaucelle, Alberto Bortott
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

if nargin<2
    dilat=1;
end

switch lower(in.type(1:3))
  case 'lft'
    out = certain(in,rand(in.uncertainty,dilat));
  otherwise
    out = rand(in.ssmodel,dilat,lower(in.type(1:3)));
end