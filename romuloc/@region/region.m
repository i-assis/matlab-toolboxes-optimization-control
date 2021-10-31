function R = region(varargin)
% REGION - Define a region of the complex plane
%
% r = region('plane',a)     : half-plane such that Re(z)<Re(a)
% r = region('plane',a,pi)  : half-plane such that Re(z)>Re(a)
% r = region('plane',a,psi) : half-plane below the inclined line
%                             that crosses the point 'a'
%                             and makes an angle of 'psi' with the imag. axis
%
% r = region('disk',c,rad)  : disk centered at 'c' with radius 'rad'
%                             default 'rad=1'
%                             if 'rad<0' the region is the exterior of the disk.
%
% SEE ALSO dstability

%   This file is part of RoMulOC
%   Last Update 4-Mar-2013
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

switch nargin
  case 0
    R.mat  = {};
    R.type = {};
  case 1
    if isa(varargin{1},'region')
      R.mat  = varargin{1}.mat;
      R.type = varargin{1}.type;
    else
      help region
    end
  case {2,3}
    switch lower(varargin{1}(1))
      case 'p'
        alpha = (varargin{2});
        if nargin==2
          psi=0;
          beta=1;
        else
          psi=mod(varargin{3},2*pi);
          beta = cos(psi)+i*sin(psi);
        end
        R.mat{1}{1}  = [-alpha'*beta-beta'*alpha,beta';beta,0];
        if psi==0
          R.type{1}{1} = sprintf('Half-plane such that: Re(z)<%g',real(alpha));
        elseif psi==pi
          R.type{1}{1} = sprintf('Half-plane such that: Re(z)>%g',real(alpha));
        else
          R.type{1}{1} = ['Half-plane below inclinded line that crosses ',num2str(alpha),...
            ''',10,''and makes an angle of ',num2str(psi),...
            ' rad with the imag axis'];
        end
      case 'd'
        alpha = varargin{2};
        if nargin==2
          rad=1;
        else
          rad=varargin{3};
        end
        if rad>0
	R.mat{1}{1}  = [alpha'*alpha-rad^2,-alpha';-alpha,1];
	R.type{1}{1} = sprintf('Disk centered at %s with radius %g',num2str(alpha),rad);
      else
	R.mat{1}{1}  = -[alpha'*alpha-rad^2,-alpha';-alpha,1];
	R.type{1}{1} = sprintf('Exterior of disk centered at %s with radius %g',num2str(alpha),-rad);
        end
      otherwise
        help region
        error
    end
  otherwise
    help region
    error
end

R=class(R,'region');


