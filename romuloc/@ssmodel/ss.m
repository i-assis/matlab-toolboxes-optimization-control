function [sys,zdi,zi,yi,wdi,wi,ui,name]=ss(S);
% SSMODEL/SS - get the SS model from a SSMODEL object 
%
% [sys,zdi,zi,yi,wdi,wi,ui,name]=ss(sysm);
%  
%   outputs <sys> the 'lti/ss' object where all inputs and all outputs
%   are concatenated. The index vectors <zdi>, <zi>, <yi> specify rows of
%   'sys.c' and 'sys.d' corresponding to the original outputs <zd>, <z>,
%   <y> of <sysm> and <wdi>, <wi>, <ui> specify columns of 'sys.b' and
%   'sys.d' corresponding to the original inputs <wd>, <w>, <u> of <sysm>.
% 
% SEE ALSO ssmodel
    
%   This file is part of RoMulOC
%   Last Update 31-Jan-2005
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France
  
  %%% get ss data
  A=S.M(S.r{1},S.c{1},:);
  B=S.M(S.r{1},[S.c{2} S.c{3} S.c{4}],:);
  C=S.M([S.r{2} S.r{3} S.r{4}],S.c{1},:);
  D=S.M([S.r{2} S.r{3} S.r{4}],[S.c{2} S.c{3} S.c{4}],:);
  sys=ss(A,B,C,D,S.T);
  %%% get indexes of inputs/outputs
  wdi=1:length(S.c{2});
  wi=max([wdi,0])+(1:length(S.c{3}));
  ui=max([wi,0])+(1:length(S.c{4}));
  zdi=1:length(S.r{2});
  zi=max([zdi,0])+(1:length(S.r{3}));
  yi=max([zi,0])+(1:length(S.r{4}));
  %%% get name
  name=S.name;
