function y = blkdiag3d(varargin)
%BLKDIAG3D  Block diagonal concatenation of 3D matrices
%
% See also BLKDIAG

%   This file is part of RoMulOC based on /elmat/blkdiag.m
%   Last Update 15-Oct-2012
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

plein=find(~cellfun('isempty',varargin));
varargin={varargin{plein}};
if length(varargin)==1
  y=varargin{1};
else
  thirddim=cellfun('size',varargin,3);
  if any(thirddim-thirddim(1))
    error('All input arguments should have same size in third dimension');
  end
  thirddim=thirddim(1);
  
  if any(~cellfun('isclass',varargin,'double'))
    y = [];
    for k=1:nargin
      x = varargin{k};
      p1 = size(y,1); p2 = size(x,1);
      m1 = size(y,2); m2 = size(x,2);
      y = [y zeros(p1,m2,thirddim); zeros(p2,m1,thirddim) x];
    end
    return
  end
  
  for k=1:nargin
    x = varargin{k};
    p2(k+1) = size(x,1); %Precompute matrix sizes
    m2(k+1) = size(x,2); %Precompute matrix sizes
  end
  %Precompute cumulative matrix sizes
  p1 = cumsum(p2);
  m1 = cumsum(m2);
  y = zeros(p1(end),m1(end),thirddim); %Preallocate for full doubles only
  for k=1:nargin
    y(p1(k)+1:p1(k+1),m1(k)+1:m1(k+1),1:thirddim) = varargin{k};
  end
end
