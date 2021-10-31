function M = rand(eli,dilat)
% MELLI/RAND - Random value in {X,Y,Z}-ellipsoid
%   
% M = rand(elli)
%
% Random value with uniform distribution. Uses RACT toolbox
% (http://sourceforge.net/projects/ract) provided that it is installed.
%
% If RACT is not installed (old version of MELLI/RAND) the random value is
% generated with a scaled usage of Matlab built-in RANDN function.
%
% SEE ALSO melli

%   This file is part of RoMulOC
%   Last Update 15-Oct-2012
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France
  
  if nargin<2
    dilat=1;
  end
  if min(eig(eli.Z))<eps
    eli.Z=eli.Z+1e-5*eye(size(eli.Z,1));
  end
  q=size(eli.Z,1); 
  p=size(eli.X,1);
  israndext=which('randext');
  if isempty(israndext)
    L = randn(q,p);
    L = rand^(1/dilat)*L/norm(L,2);
  else
    if eli.real
      L = randext('real_matrix_uniform','nominal',zeros(q,p),'p_norm',2,'rho',1);
    else
      L = randext('complex_matrix_uniform','nominal',zeros(q,p),'p_norm',2,'rho',1);
    end
  end
  M = center(eli)+inv(sqrtm(eli.Z))*L*sqrtm(radius(eli));
