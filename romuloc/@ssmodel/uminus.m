function syso = uminus(sysi)
% SSMODEL/UMINUS - unary minus of ssmodel object
%
% syso = - sysi
%   command input u is replaced by -u
%
%   converts
%     dx =  A*x +  Bd*wd +  Bw*w +  Bu*u  
%     zd = Cd*x + Ddd*wd + Ddw*w + Ddu*u
%      z = Cz*x + Dzd*wd + Dzw*w + Dzu*u
%      y = Cy*x + Dyd*wd + Dyw*w + Dyu*u
%   into
%     dx =  A*x +  Bd*wd +  Bw*w +  (-Bu)*u  
%     zd = Cd*x + Ddd*wd + Ddw*w + (-Ddu)*u
%      z = Cz*x + Dzd*wd + Dzw*w + (-Dzu)*u
%      y = Cy*x + Dyd*wd + Dyw*w + (-Dyu)*u
%
% SEE ALSO ssmodel

%   This file is part of RoMulOC
%   Last Update 9-Nov-2012
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

  syso=ssmodel;
  syso.T=sysi.T;
  if ~isempty(sysi.name)
    syso.name=['-',sysi.name];
  end
  maxc1=0;
  maxc2=length(sysi.c{1});
  syso.c{1}=1:maxc2;
  maxc1=maxc2;
  maxc2=length(sysi.c{2});
  syso.c{2}=maxc1+(1:maxc2);
  maxc1=maxc1+maxc2;
  maxc2=length(sysi.c{3});
  syso.c{3}=maxc1+(1:maxc2);
  maxc1=maxc1+maxc2;
  maxc2=length(sysi.c{4});
  syso.c{4}=maxc1+(1:maxc2);
  syso.r=sysi.r;
  syso.nb=sysi.nb;
  
  syso.M(:,1:maxc1,1:sysi.nb)...
	=sysi.M(:,[sysi.c{1},sysi.c{2},sysi.c{3}],1:sysi.nb);
  
  syso.M(:,syso.c{4},1:sysi.nb)...
  =-sysi.M(:,sysi.c{4},1:sysi.nb);
