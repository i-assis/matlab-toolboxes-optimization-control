function out = set(sys,info,data)
% SSMODEL/SET - set some data of a SSMODEL object
%  
% sys = set(sys,info,data);  or   sys.info = data;
%
%   <sys> is a SSMODEL object
%   <info> describes the field to set to <data>  
%  
%   Same use as ssmodel/get.
%
% SEE ALSO ssmodel
  
%   This file is part of RoMulOC
%   Last Update 31-Jan-2005
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France
  
  out=[];  
  if nargin<3
    help ssmodel/set
  else
    if ~ischar(info)
      error('2nd argument must be a string');
    end;
    S.type='.';
    S.subs=info;
    out=subsasgn(sys,S,data);
  end  
  
    
