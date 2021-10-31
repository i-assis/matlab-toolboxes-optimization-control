function out = randu(in,dilat)
% UNCERTAINTY/RANDU - obsolete, use uncertainty/rand instead
  
%   This file is part of RoMulOC
%   Last Update 2-Dec-2008
%   author : Dimitri Peaucelle, Alberto Bortott
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

  if isa(in,'ussmodel')
    a = struct(in);
    out = rand(a.uncertainty,dilat);
  else
    out = rand(in,dilat);
  end
  
