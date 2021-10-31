function out = isempty(delta)
% ISEMPTY - overloaded  
  
%   This file is part of RoMulOC
%   Last Update 31-Jan-2005
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

  out = ( delta.nbb == 0 );
