function eli = melli2(R,Mo,Z,r)
% MELLI2 - Define a matrix ellipsoid object
%   
% elli = melli2(R,Mo,Z,r)
%
% Defines the real (r=1, default) 
% or complex (r=0) valued set 
% such that M in the ball defined by
% (M-Mo)'*Z*(M-Mo)<=R
% Z should be positive semi-definite
%
% SEE ALSO melli, center, radius, rand, isin
      
%   This file is part of RoMulOC
%   Last Update 10-Sep-2014
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France
  
  if nargin<3
    error('Not enougth input arguments');
  elseif nargin<4
    if all([isreal(R) isreal(Mo) isreal(Z)])
      r=1;
    else 
      r=0;
    end
  end
  
  if ~all([isreal(R) isreal(Mo) isreal(Z)]) & r
    error('Input matrices must be real for real valued ellipsoids');
  end
  
  if min(eig(R))<0
    error('1st input arg. must be positive semi-definite');
  end  
%  if min(eig(Z))<0
%    error('3rd input arg. must be positive semi-definite');
%  end  
  
  if size(R,1)~=size(R,2)
    error('1st input arg. must be square');
  elseif size(R,1)~=size(Mo,2)
    error('1st and 2nd input arg. must have same nb of columns');
  elseif size(Mo,1)~=size(Z,1)
    error('2nd and 3rd input arg. must have same nb of rows');
  elseif size(Z,1)~=size(Z,2)
    error('3rd input arg. must be square');
  end
  if any(any(R-R'))
    if max(max(abs(R-R')))>1e-10
      warning('1st input arg. is made Hermitian');
    end
    R=0.5*(R+R');
  end
  if any(any(Z-Z'))
    if max(max(abs(Z-Z')))>1e-10
      warning('3rd input arg. is made Hermitian');
    end
    Z=0.5*(Z+Z');
  end  
  eli=melli(Mo'*Z*Mo-R,-Mo'*Z,Z,r);
