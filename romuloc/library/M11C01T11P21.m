function cstr = M11C01T11P21(us,perf,varsglob,varsloc)
% M11C01T11P21 - LFT model - Analysis - PDLF T11 - Hinfinity

%   This file is part of RoMulOC
%   Last Update 7-Nov-2014
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

n=us.n;
mw=us.mw;
md=us.md;
pz=us.pz;
pd=us.pd;

P = varsglob{2,1};

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
sepvar = varsloc{2,1};

if us.T
  R=[-1 0;0 1];
else
  R=[0 1;1 0];
end

if any(any(us.Ddw))
  MP = [oio(0,n,mw+3*md);
    oio(n+mw,md,2*md);
    us.A,us.Bw,us.Bd,us.Bd,sparse(n,md);
    oio(n+mw+2*md,md,0)];
  Mc = [us.Cz,us.Dzw,us.Dzd,us.Dzd,sparse(pz,md)];
  Mg = oio(n,mw,3*md);
  MS = [us.Cd,sparse(pd,mw),us.Ddd,sparse(pd,2*md);
    sparse(pd,n),us.Ddw,sparse(pd,md),us.Ddd,sparse(pd,md);
    us.Cd*us.A,us.Cd*us.Bw,us.Cd*us.Bd,us.Cd*us.Bd,us.Ddd;
    oio(n+mw,3*md,0)];
else
  MP = [oio(0,n+md,mw+md);
    us.A,us.Bd,us.Bw,zeros(n,md);
    oio(n+md+mw,md,0)];
  Mc = [us.Cz,us.Dzd,us.Dzw,zeros(pz,md)];
  Mg = oio(n+md,mw,md);
  MS = [us.Cd,us.Ddd,us.Ddw,sparse(pd,md);
    us.Cd*us.A,us.Cd*us.Bd,us.Cd*us.Bw,us.Ddd;
    oio(n,md,mw+md);
    oio(n+md+mw,md,0)];
end

lyap = MP'*kron(R,P)*MP - tau*gamma2*(Mg'*Mg) + tau*(Mc'*Mc) - MS'*sepvar*MS ;
if ~ishermitian(lyap)
  warning('Something is going wrong, probably due to bad conditionning');
  lyap = 0.5*(lyap+lyap');
end

if isLMI;
  cstr = tag([lyap<= -varsglob{1,1}*eye(size(lyap,1))],'Var Lyap <0');
else
  cstr{1} = lyap;
end

