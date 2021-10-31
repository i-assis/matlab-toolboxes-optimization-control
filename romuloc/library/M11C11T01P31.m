function cstr = M11C11T01P31(us,perf,varsglob,varsloc)
% M11C11T01P31 - LFT model - State feedback - Quadratic stability - H2 test

%   This file is part of RoMulOC
%   Last Update 7-Nov-2014
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

n=us.n;
mu=us.mu;
pd=us.pd;
md=us.md;
pz=us.pz;
mw=us.mw;

P = varsglob{2,1};
S = varsglob{3,1};
T = varsloc{3,1};

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

if isLMI;
  cstr = tag([trace(T)<tau*gamma2], 'trace(T)<g');
else
  cstr{1}=trace(T)-tau*gamma2;
end

RS = [zeros(mu,mu), S;...
      S', zeros(n, n)];
    
if ~any(any(us.Bd))
  if us.T == 0
    RP = [zeros(n,n), P;...
          P, zeros(n,n)];
    MP = [us.A, eye(n)];
    MS = [us.Bu, eye(n)];
    Mc = us.Bw;
  else
    RP = [-P, zeros(n,2*n); ...
          zeros(n,2*n), P;...
          zeros(n,n), P, zeros(n,n)];
    MP = [eye(n), us.A, zeros(n,n); ...
          zeros(n,n), -0.5*eye(n), eye(n)];
    MS = [us.Bu, zeros(n,n); ...
          zeros(n,mu),eye(n)];
    Mc = [us.Bw; zeros(n,mw)];
  end
  cstr1 = MP*RP*MP' + MS*RS*MS' + tau*(Mc*Mc');
else
  if us.T == 0
    RP = [zeros(n,n), P;...
          P, zeros(n,n)];
    MP = [us.A, eye(n); us.Cd, zeros(md,n)];
    MS = [us.Bu, eye(n); us.Ddu, zeros(pd,n)];
    Mc = [us.Bw; us.Ddw];
    Mt = [us.Bd, zeros(n,pd); us.Ddd, eye(pd)];
  else
    RP = [-P, zeros(n,2*n); ...
          zeros(n,2*n), P; ...
          zeros(n,n), P, zeros(n,n)];
    MP = [eye(n), us.A, zeros(n,n); ...
          zeros(n,n), us.Cd, zeros(n,n); ...
          zeros(n,n), -0.5*eye(n), eye(n)];
    MS = [us.Bu, zeros(n,n); us.Ddu, zeros(pd,n); ...
          zeros(n,n), eye(n)];
    Mc = [us.Bw; us.Ddw; zeros(n,mw)];
    Mt = [us.Bd, zeros(n,pd); us.Ddd, eye(pd); ...
          zeros(n, md+pd)];
  end
  cstr1 = MP*RP*MP' + MS*RS*MS' + tau*(Mc*Mc') - Mt*varsloc{2,1}*Mt';
end
if isLMI;
  cstr = cstr + tag([cstr1<= -varsglob{1,1}],'Var Lyap <0');
else
  cstr{2}=cstr1;
end

RP = [zeros(n,n), P;...
      P, zeros(n,n)];
if ~any(any(us.Dzd))
  MP = [us.Cz, zeros(pz,n); ...
        -0.5*eye(n), eye(n)];
  MS = [us.Dzu, zeros(pz,n); ...
    zeros(n,mu), eye(n)];
  Mc = [us.Dzw; zeros(n,mw)];
  MT = [eye(pz); zeros(n,pz)];
  cstr2 = MP*RP*MP' + MS*RS*MS' + tau*(Mc*Mc') - MT*T*MT';
else
  MP = [us.Cz, zeros(pz,n); ...
        us.Cd, zeros(pz,n); ...
        -0.5*eye(n),eye(n)];
  MS = [us.Dzu, zeros(pz,n); ...
        us.Ddu, zeros(pz,n); ...
        zeros(n,mu), eye(n)];
  Mc = [us.Dzw; us.Ddw; zeros(n,mw)];
  MT = [eye(pz); zeros(pd+n,pz)];
  Mt = [us.Dzd, zeros(pd,pd); us.Ddd, eye(pd); ...
        zeros(n,md+pd)];
  cstr2 = MP*RP*MP' + MS*RS*MS' + tau*(Mc*Mc') - MT*T*MT' - Mt*varsloc{4,1}*Mt';
end
if isLMI;
  cstr = cstr + tag([cstr2<= -varsglob{1,1}], '... < T');
else
  cstr{3}=cstr2;
end

