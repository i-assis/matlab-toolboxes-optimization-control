function cstr = M11C01T11P31(us,perf,varsglob,varsloc)
% M11C01T11P31 - LFT model - Analysis - PDLF T11 - H2
     
%   This file is part of RoMulOC
%   Last Update 7-Nov-2014
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

P = varsglob{2,1};
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

MP = [oio(0,us.n+us.md,us.md);
  us.A,us.Bd,sparse(us.n,us.md);
  oio(us.n+us.md,us.md,0)];
Mc = [us.Cz,us.Dzd,sparse(us.pz,us.md)];
MS = [us.Cd,us.Ddd,sparse(us.pd,us.md);
  us.Cd*us.A,us.Cd*us.Bd,us.Ddd;
  oio(us.n,2*us.md,0)];
lyap = MP'*kron(R,P)*MP + tau*(Mc'*Mc) - MS'*varsloc{2,1}*MS ;
if ~ishermitian(lyap)
  warning('Something is going wrong, probably due to bad conditionning');
  lyap = 0.5*(lyap+lyap');
end
cstr = tag(lyap<= -varsglob{1,1},'Var Lyap <0');
  
T = varsloc{3,1};

if any(any(us.Ddw))
  MP = [us.Bw,us.Bd,sparse(us.n,us.md);...
    oio(us.mw+us.md,us.md,0)];
  MT = oio(0,us.mw,2*us.md);
  Mc = [us.Dzw,us.Dzd,sparse(us.pz,us.md)];
  MS = [us.Ddw,us.Ddd,sparse(us.pd,us.md);
    us.Cd*us.Bw,us.Cd*us.Bd,us.Ddd;
    oio(us.mw,2*us.md,0)];
else
  MP = [us.Bw,sparse(us.n,us.md);...
    oio(us.mw,us.md,0)];
  MT = oio(0,us.mw,us.md);
  Mc = [us.Dzw,sparse(us.pz,us.md)];
  MS = [us.Cd*us.Bw,us.Ddd;...
    oio(us.mw,us.md,0)];
end
cstronT = MP'*P*MP - MT'*T*MT + tau*(Mc'*Mc) - MS'*varsloc{4,1}*MS ;
if ~ishermitian(cstronT)
  warning('Something is going wrong, probably due to bad conditionning');
  cstronT = 0.5*(cstronT+cstronT');
end
cstr = cstr + tag(cstronT<= -varsglob{1,1},'.. < T')...
  + tag(trace(T)<=tau*gamma2,'trace(T)<g');

    
