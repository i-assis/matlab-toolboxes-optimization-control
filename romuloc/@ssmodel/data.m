function [M,ixr,izd,iz,iy,ixc,iwd,iw,iu,Ts,name]=data(S);
% SSMODEL/DATA - get all data from an SSMODEL object 
%
% [M,ixr,izd,iz,iy,ixc,iwd,iw,iu,Ts,name]=data(sys)
%  
% Does the converse of the fundamental ssmodel definition
% 
% SEE ALSO ssmodel
    
%   This file is part of RoMulOC
%   Last Update 29-Jan-2012
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France
  
  M=S.M([S.r{1},S.r{2},S.r{3},S.r{4}],...
        [S.c{1},S.c{2},S.c{3},S.c{4}],...
        :);

  rmin=1;
  rmax=length(S.r{1});
  ixr=rmin:rmax;
  rmin=rmax+1;
  rmax=rmax+length(S.r{2});
  izd=rmin:rmax;
  rmin=rmax+1;
  rmax=rmax+length(S.r{3});
  iz =rmin:rmax;
  rmin=rmax+1;
  rmax=rmax+length(S.r{4});
  iy =rmin:rmax;

  cmin=1;
  cmax=length(S.c{1});
  ixc=cmin:cmax;
  cmin=cmax+1;
  cmax=cmax+length(S.c{2});
  iwd=cmin:cmax;
  cmin=cmax+1;
  cmax=cmax+length(S.c{3});
  iw =cmin:cmax;
  cmin=cmax+1;
  cmax=cmax+length(S.c{4});
  iu =cmin:cmax;
  
  Ts =S.T;
  name =S.name;
