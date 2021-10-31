function cstr = M11C01T01P31(us,perf,varsglob,varsloc)
% M11C01T01P31 - LFT model - Analysis - Quadratic stability - H2 test

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
  cstr=cell(3,1);
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
  % check that H2 norm exists
  if any(any(us.Dzw))
    error('cannot compute H2 norm: Dzw~=0');
  end
  if any(any(us.Dzd)) && any(any(us.Ddw))
    error('cannot comupte H2 norm: both Dzd~=0 and Ddw~=0')
  end
  R=[0 1;1 0];
end

if any(any(us.Cd))
  MP = [oio(0,n,md);us.A,us.Bd];
  Mc = [us.Cz,us.Dzd];
  MS = [us.Cd,us.Ddd;oio(n,md,0)];
  lyap = MP'*kron(R,P)*MP + tau*(Mc'*Mc) - MS'*varsloc{2,1}*MS ;
else
  MP = [eye(n);us.A];
  Mc = us.Cz;
  lyap = MP'*kron(R,P)*MP + tau*(Mc'*Mc) ;
end
if isLMI;
  cstr = tag(lyap<= -varsglob{1,1},'Var Lyap <0');
else
  cstr{1} = lyap;
end

if any(any(us.Ddw))
  MP = [us.Bw,us.Bd];
  Mc = [us.Dzw,us.Dzd];
  MT = oio(0,mw,md);
  MS = [us.Ddw,us.Ddd;oio(mw,md,0)];
  T = varsloc{3,1};
  cstronT = MP'*P*MP + tau*(Mc'*Mc) -MT'*T*MT - MS'*varsloc{4,1}*MS ;
  if isLMI;
    cstr = cstr ...
      + tag(cstronT<= -varsglob{1,1},'.. < T')...
      + tag(trace(T)<=tau*gamma2,'trace(T)<g');
  else
    cstr{2} = cstronT;
    cstr{3} = trace(T)-tau*gamma2;
  end
else
  if isLMI;
    cstr = cstr + tag(trace(us.Bw'*P*us.Bw+tau*(us.Dzw'*us.Dzw))<=tau*gamma2,'trace(..)<g');
  else
    cstr{2} = trace(us.Bw'*P*us.Bw+tau*(us.Dzw'*us.Dzw))-tau*gamma2;
    cstr{3} = -1;
  end
end


