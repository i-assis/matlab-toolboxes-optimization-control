function cstr = M11C01T11P41(us,perf,varsglob,varsloc)
% M11C01T11P41 - LFT model - Analysis - PDLF T11 - I2P

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
sepvar1 = varsloc{2,1};
sepvar2 = varsloc{3,1};
sepvar3 = varsloc{4,1};
sepvar4 = varsloc{5,1};

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

MP = [oio(0,n+md,md);
  us.A,us.Bd,sparse(n,md);
  oio(n+md,md,0)];
MS = [us.Cd,us.Ddd,sparse(pd,md);
  us.Cd*us.A,us.Cd*us.Bd,us.Ddd;
  oio(n,2*md,0)];
lyap = MP'*kron(R,P)*MP - MS'*sepvar1*MS ;
if ~ishermitian(lyap)
  warning('Something is going wrong, probably due to bad conditionning');
  lyap = 0.5*(lyap+lyap');
end

if any(any(us.Ddw))
  MP = [us.Bw,us.Bd,sparse(n,md);...
    oio(mw+md,md,0)];
  Mg = oio(0,mw,2*md);
  MS = [us.Ddw,us.Ddd,sparse(pd,md);
    us.Cd*us.Bw,us.Cd*us.Bd,us.Ddd;
    oio(mw,2*md,0)];
else
  MP = [us.Bw,sparse(n,md);
    oio(mw,md,0)];
  Mg = oio(0,mw,md);
  MS = [us.Cd*us.Bw,us.Ddd;
    oio(mw,md,0)];
end
BPB = MP'*P*MP - tau*gamma2*(Mg'*Mg) - MS'*sepvar2*MS ;
if ~ishermitian(BPB)
  warning('Something is going wrong, probably due to bad conditionning');
  BPB = 0.5*(BPB+BPB');
end

Mc = [us.Cz,us.Dzd];
MS = [us.Cd,us.Ddd;...
  oio(n,md,0)];
CC = tau*(Mc'*Mc) - P - MS'*sepvar3*MS ;
if ~ishermitian(CC)
  warning('Something is going wrong, probably due to bad conditionning');
  CC = 0.5*(CC+CC');
end

if any(any(us.Ddw))
  Mc = [us.Dzw,us.Dzd];
  Mg = oio(0,mw,md);
  MS = [us.Ddw,us.Ddd;...
    oio(mw,md,0)];
  DD = tau*(Mc'*Mc) - tau*gamma2*(Mg'*Mg) - MS'*sepvar4*MS ;
  if ~ishermitian(DD)
    warning('Something is going wrong, probably due to bad conditionning');
    DD = 0.5*(DD+DD');
  end
else
  DD = tau*(us.Dzw'*us.Dzw) - tau*gamma2*eye(mw);
end

if isLMI
  cstr = tag([lyap<= -varsglob{1,1}],'Var Lyap <0');
  cstr = cstr + tag([BPB<= -varsglob{1,1}],'|xinit|<g^2');
  cstr = cstr + tag([CC<= -varsglob{1,1}],'|z|<Lyap');
  cstr = cstr + tag([DD<= -varsglob{1,1}],'|zinit|<g^2');
else
  cstr{1} = lyap;
  cstr{2} = BPB;
  cstr{3} = CC;
  cstr{4} = DD;
end


