function [xe,ye]=plot(eli,varargin)
% MELLI/PLOT - draw in 2-D a MELLI object
%   
% plot(eli,ridx,cidx)
%
% <eli> : melli object that describes an ellipsoid of nxm matrices
% <ridx> : rows of coefficients to be plotted
% <cidx> : comulns of coefficients to be plotted
% the plot is the projection of the ellipsoid on the plane of coefficients
% defined by <ridx> and <cidx> where <length(ridx)*length(cidx)=2> 
%
% [xe,ye]=plot(eli,ridx,cidx) 
%
% outputs vectors of the 2D plot
%
% plot(eli,ridx,cidx,opt)
% 
% plots using graphical options defined by <opt> (see PLOT)
%
% SEE ALSO melli
      
%   This file is part of RoMulOC
%   Last Update 14-Sept-2012
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France
  
if nargin<2
  options ='';
  ridx=[];
  cidx=[];
elseif nargin==2
  options = varargin{1};
  ridx=[];
  cidx=[];
elseif nargin==3
  options = '';
  ridx = varargin{1};
  cidx = varargin{2};
elseif nargin>3
  options = varargin{3:end};
  ridx = varargin{1};
  cidx = varargin{2};
end

if isempty(ridx)
  if (size(eli.X,1)*size(eli.Z,1))~=2
    error('the {X,Y,Z}-elipsoid cannot be plotted in 2D - choose rows and cols');
  else
    ridx=1:size(eli.Z,1);
    cidx=1:size(eli.X,1);
  end
end

if (length(ridx)*length(cidx))~=2
  error('wrong dimensions of 2nd and 3rd argument');
end

M0 = center(eli);
R  = radius(eli);
if min(eig(R))<eps | min(eig(eli.Z))<eps
  error('cannot plot : set is not an ellipse');
end

% make projection with respect to columns

L = full(sparse(1:length(cidx),cidx,ones(1,length(cidx)),length(cidx),size(eli.X,1)));
eli2.X = L*eli.X*L';
eli2.Y = L*eli.Y;
eli2.Z = eli.Z;

% make projection with respect to rows

L = full(sparse(ridx,1:length(ridx),ones(1,length(ridx)),size(eli2.Z,1),length(ridx)));
Z = inv(L'/eli2.Z*L);
Y = eli2.Y/eli2.Z*L*Z;
X = eli2.X-eli2.Y/eli2.Z*eli2.Y'+eli2.Y/eli2.Z*L*Z*L'/eli2.Z*eli2.Y';
eli3 = melli(X,Y,Z);
M0 = center(eli3);
R = radius(eli3);

if size(eli3.Z,1)==2
  P = eli3.Z;
else
  P = inv(R);
  R = inv(eli3.Z);
end;
P=P/R;
x0 = M0(1); y0 = M0(2);
P = chol(P);
theta = linspace(-pi,pi,1000);
xy_tilde = [cos(theta); sin(theta)];
P = inv(P);
xy_bar = P*xy_tilde;
xe = xy_bar(1,:)+x0;
ye = xy_bar(2,:)+y0;
if nargout==0
  opt=[];
  if isstruct(options)
      for ii=1:length(options)
          opt=[opt,',options{',num2str(ii),'}'];
      end
  else
      opt=[',options'];
  end
  eval(['h = plot(xe,ye',opt,');']);
  xlabel(sprintf('coef (%i,%i)',ridx(1),cidx(1)));
  if length(ridx)==2
    ylabel(sprintf('coef (%i,%i)',ridx(2),cidx(1)));
  else
    ylabel(sprintf('coef (%i,%i)',ridx(1),cidx(2)));
  end
end

