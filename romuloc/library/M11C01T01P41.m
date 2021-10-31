function cstr = M11C01T01P41(us,perf,varsglob,varsloc)
% M11C01T01P41 - LFT model - Analysis - Quadratic stability - i2p test

%   This file is part of RoMulOC
%   Last Update 7-Nov-2014
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

n=us.n;
mw=us.mw;
md=us.md;

P = varsglob{2,1};

if isa(P,'sdpvar')
  isLMI=1;
  cstr=lmi;
else
  isLMI=0;
  cstr=cell(4,1);
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

if any(any(us.Cd)) && any(any(us.Bd))
  MP = [oio(0,us.n,us.md);us.A,us.Bd];
  MS = [us.Cd,us.Ddd;oio(n,md,0)];
  lyap = MP'*kron(R,P)*MP - MS'*varsloc{2,1}*MS ;
else
  MP = [eye(us.n);us.A];
  lyap = MP'*kron(R,P)*MP ;
end
if isLMI;
  cstr = tag(lyap<= -varsglob{1,1},'Var Lyap <0');
else
  cstr{1} = lyap;
end

if any(any(us.Ddw)) && any(any(us.Bd))
  MP = [us.Bw,us.Bd];
  Mg = oio(0,mw,md);
  MS = [us.Ddw,us.Ddd;oio(mw,md,0)];
  BPB = MP'*P*MP - tau*gamma2*(Mg'*Mg) - MS'*varsloc{3,1}*MS ;
else
  BPB = us.Bw'*P*us.Bw -tau*gamma2*eye(mw);
end
if isLMI;
  cstr = cstr + tag(BPB<= -varsglob{1,1},'|xinit|<g^2');
else
  cstr{2} = BPB;
end

if any(any(us.Cd)) && any(any(us.Dzd))
  MP = oio(0,n,md);
  Mc = [us.Cz,us.Dzd];
  MS = [us.Cd,us.Ddd;oio(n,md,0)];
  CC = tau*(Mc'*Mc) -MP'*P*MP - MS'*varsloc{4,1}*MS ;
else
  CC = tau*(us.Cz'*us.Cz) - P;
end
if isLMI;
  cstr = cstr + tag(CC<= -varsglob{1,1},'|z|<Lyap');
else
  cstr{3} = CC;
end

if any(any(us.Ddw)) && any(any(us.Dzd))
  Mg = oio(0,mw,md);
  Mc = [us.Dzw,us.Dzd];
  MS = [us.Ddw,us.Ddd;oio(mw,md,0)];
  DD = tau*(Mc'*Mc) - tau*gamma2*(Mg'*Mg) - MS'*varsloc{5,1}*MS;
else
  DD = tau*(us.Dzw'*us.Dzw) - tau*gamma2*eye(mw);
end
if isLMI;
  cstr = cstr + tag(DD<= -varsglob{1,1},'|zinit|<g^2');
else
  cstr{4} = DD;
end
