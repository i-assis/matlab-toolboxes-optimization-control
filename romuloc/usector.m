function delta = usector(amin,amax,name)
% USECTOR - Creates a real sector uncertainty
%
%  delta = usector(alpha_min,alpha_max,name)
%     
%  The uncertainty is 
%
%  <name> is an optional string
%
% SEE ALSO unb, unbc, udiss, upos, uinter, upoly, uparal
    
%   This file is part of RoMulOC
%   Last Update 7-Mar-2013
%   author : Dimitri Peaucelle, Alberto Bortott
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France
  
  if nargin>3 | nargin<2
    error('usage is delta = usector(alpha_min,alpha_max,name)');
  elseif nargin==2
    name='';
  end;      
  if (amin>pi) || (amax>pi)
      error('alpha must be < 180°');
  end;
  rows=1;
  cols=1;
  data.size=[rows,cols];
  data.names{1}=name;
  data.constr{1}=sprintf('sector with %0.4g<alpha<%0.4g',amin,amax);
  data.complex=0;
  data.rows{1}=(1:rows)';
  data.cols{1}=(1:cols)';
  data.X{1}=amin*amax;
  data.Y{1}=0.5*(amin*amax);
  data.Z{1}=1;
  data.vtx{1} = {};
  data.ubase{1}=[];
  delta=uncertainty('new',data);