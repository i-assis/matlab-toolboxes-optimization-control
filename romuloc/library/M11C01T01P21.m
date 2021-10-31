function cstr = M11C01T01P21(us,perf,varsglob,varsloc)
% M11C01T01P21 - LFT model - Analysis - Quadratic stability - Hinfinity test  
  
%   This file is part of RoMulOC
%   Last Update 7-Nov-2014
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

n=us.n;
mw=us.mw;
md=us.md;

P = varsglob{2,1};
sepvar = varsloc{2,1};

if isa(P,'sdpvar')
  isLMI=1;
  cstr=lmi;
else
  isLMI=0;
  cstr=cell(1,1);
end

if perf
  gamma2 = perf^2;
  tau = varsloc{1,1};
else
  gamma2 = varsloc{1,1};
  tau = 1;
end

if us.T
  R=[-1 0;0 1];
else
  R=[0 1;1 0];
end

MP=[oio(0,n,md+mw);us.A,us.Bd,us.Bw];
Mc=[us.Cz,us.Dzd,us.Dzw];
Mg=oio(n+md,mw,0);
MS=[us.Cd,us.Ddd,us.Ddw;oio(n,md,mw)];


lyap = MP'*kron(R,P)*MP - tau*gamma2*(Mg'*Mg) + tau*(Mc'*Mc) - MS'*sepvar*MS ;

if isLMI
  cstr = tag([lyap<= -varsglob{1,1}],'Var Lyap <0');
else
  cstr{1} = lyap;
end
