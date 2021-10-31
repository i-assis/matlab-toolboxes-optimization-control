function eli = melli(X,Y,Z,r)
% MELLI - Define a matrix ellipsoid object
%   
% elli = melli(X,Y,Z,r)
%
% Defines the real (r=1, default) 
% or complex (r=0) valued set 
% such that M in {X,Y,Z}-elliposoid if
% [ 1 M' ][ X  Y ][ 1 ]
%         [ Y' Z ][ M ] <=0
% Z should be positive semi-definite
%
% SEE ALSO center, radius, rand, isin
      
%   This file is part of RoMulOC
%   Last Update 31-Jan-2005
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France
  
  if nargin<3
    error('Not enougth input arguments');
  elseif nargin<4
    if all([isreal(X) isreal(Y) isreal(Z)])
      r=1;
    else 
      r=0;
    end
  end
  
%   if all([isreal(X) isreal(Y) isreal(Z)]) & r==0
%     error('Input matrices must be real for complex valued ellipsoids');
%   end
%Changed beceau coupld not guess why this was seemingly the wrong way
%(Dimitri)
  if ~all([isreal(X) isreal(Y) isreal(Z)]) & r
    error('Input matrices must be real for real valued ellipsoids');
  end
  
  if min(eig(Z))<0
    error('3rd input arg. must be positive semi-definite');
  end  
  
  if size(X,1)~=size(X,2)
    error('1st input arg. must be smuare');
  elseif size(X,1)~=size(Y,1)
    error('1st and 2nd input arg. must have same nb of rows');
  elseif size(Y,2)~=size(Z,2)
    error('2nd and 3rd input arg. must have same nb of columns');
  elseif size(Z,1)~=size(Z,2)
    error('3rd input arg. must be smuare');
  end
  if any(any(X-X'))
    if max(max(abs(X-X')))>1e-10
      warning('1st input arg. is made Hermitian');
    end
    X=0.5*(X+X');
  end
  if any(any(Z-Z'))
    if max(max(abs(Z-Z')))>1e-10
      warning('3rd input arg. is made Hermitian');
    end
    Z=0.5*(Z+Z');
  end  
  eli.X=X;
  eli.Y=Y;
  eli.Z=Z;
  eli.real=r;
  eli=class(eli,'melli');
