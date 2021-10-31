function M = usample(eli,sample_nb)
% MELLI/USAMPLE - Uniform random distribution in {X,Y,Z}-ellipsoid
%
% M = usample(elli,nb)
%
% <nb> is the number of samples to be generated
% <rdel> is a 3D matrix, the third dimension stacks the samples
%
% Random values are (when possible) generated with uniform distribution.
% It uses RACT toolbox (http://sourceforge.net/projects/ract)
% it needs to be installed.
%
% The distributions are not uniform if elli.Z is not positive definite.
% In that case the set is unbounded, random values are generated on the
% modified set obatined by changing elli.Z into elli.Z+eps*I where eps is
% some small positive scalar.
%
% SEE ALSO melli, melli/rand

%   This file is part of RoMulOC
%   Last Update 15-Oct-2012
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France


if nargin<2
  sample_nb=1;
end

if min(eig(eli.Z))<eps
  eli.Z=eli.Z+1e-5*eye(size(eli.Z,1));
end
C=center(eli);
iZ=inv(sqrtm(eli.Z));
sR=sqrtm(radius(eli));
q=size(eli.Z,1);
p=size(eli.X,1);
% preallocate dimensions
M=zeros(q,p,sample_nb);
if eli.real
  for jj=1:sample_nb
    M(:,:,jj) = C+iZ*randext('real_matrix_uniform','nominal',zeros(q,p),'p_norm',2,'rho',1)*sR;
  end
else
  for jj=1:sample_nb
    M(:,:,jj) = C+iZ*randext('complex_matrix_uniform','nominal',zeros(q,p),'p_norm',2,'rho',1)*sR;
  end
end
end
