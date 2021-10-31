function plot(reg,opts)
% REGION/PLOT - plot a region object
% 
% plot(reg)
%
% SEE ALSO region

%   This file is part of RoMulOC
%   Last Update 31-May-2011
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

if nargin<2
  opts='';
end

if center(reg)<Inf
  theta=0:0.01:2*pi;
  x=center(reg)+abs(radius(reg))*(cos(theta)+i*sin(theta));
  plot(x,opts);
else
  V=axis;
  M=get(reg);
  M=M{1}{1};
  if abs(M(1,2)-M(2,1))>1e-5
    x=V(1:2);
    y=i*(M(1,1)+x*(M(1,2)+M(2,1)))/(M(1,2)-M(2,1));
  else
    y=V(3:4);
    x=-(M(1,1)/(M(1,2)+M(2,1)))*ones(1,2);
  end
  plot(x,y,opts);
end