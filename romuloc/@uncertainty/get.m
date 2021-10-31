function out = get(delta,info)
% UNCERTAINTY/GET - Extract block from UNCERTAINTY object
%
%  d = get( delta, i )   or   d = delta{i} 
%  outputs the uncertainty composed only of the block index by <i>
% 
%  SEE ALSO uncertainty, udata

%   This file is part of RoMulOC
%   Last Update 8-Mar-2013
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

  if nargin~=2
    help uncertainty/get
  else
    S.type='{}';
    S.subs={info};
    out=subsref(delta,S);
  end
