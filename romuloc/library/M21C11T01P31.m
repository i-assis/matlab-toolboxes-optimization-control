function cstr = M21C11T01P31(us,perf,varsglob,varsloc)
% M21C11T01P31 - Polytopic model - State feedback - Quadratic stability - H2 test
  
%   This file is part of RoMulOC
%   Last Update 7-Nov-2014
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

P = varsglob{2,1};
S = varsglob{3,1};
if perf
  gamma2 = perf^2;
  tau = varsloc{1,1};
else
  gamma2 = varsloc{1,1};
  tau = 1;
end
T = varsloc{2,1};

if isa(P,'sdpvar')
  isLMI=1;
  cstr=lmi;
else
  isLMI=0;
  cstr=cell(3*us.nb,1);
end

n=us.n;
mu=us.mu;
mw=us.mw;
pz=us.pz;

RS = [zeros(mu,mu), S;...
      S', zeros(n,n)];
    
if us.T == 0
  RPa = [zeros(n,n),P;...
        P,zeros(n,n)];
else
  RPa = [-P, zeros(n, 2*n); ...
        zeros(n,2*n), P;...
        zeros(n,n), P, zeros(n,n)];
end
RPc = [zeros(n,n), P;...
  P, zeros(n,n)];

A=us.A;
Bw=us.Bw;
Bu=us.Bu;
Cz=us.Cz;
Dzw=us.Dzw;
Dzu=us.Dzu;
    
for vtx=1:us.nb
  if ~us.T
    MP = [A(:,:,vtx), eye(n)];
    MS = [Bu(:,:,vtx), eye(n)];
    Mc = Bw(:,:,vtx);
  else
    MP = [eye(n), A(:,:,vtx), zeros(n,n); ...
          zeros(n,n), -0.5*eye(n), eye(n)];
    MS = [Bu(:,:,vtx), zeros(n,n); ...
          zeros(n,mu),eye(n)];
    Mc = [Bw(:,:,vtx); zeros(n,mw)];
  end
  cstr1 = MP*RPa*MP' + MS*RS*MS' + tau*(Mc*Mc');
  if isLMI;
    cstr = cstr + tag(cstr1<= -varsglob{1,1},'Var Lyap <0');
  else
    cstridx=cstridx+1;
    cstr{3*(vtx-1)+1} = cstr1;
  end
  
  MP = [Cz(:,:,vtx),zeros(pz,n); ...
        -0.5*eye(n), eye(n)];
  MS = [Dzu(:,:,vtx), zeros(pz,n); ...
        zeros(n,mu),eye(n)];
  Mc = [Dzw(:,:,vtx); zeros(n,mw)];
  MT = [eye(pz); zeros(n,pz)];
  cstr2 = MP*RPc*MP' + MS*RS*MS' + tau*(Mc*Mc') - MT*T{vtx}*MT';
  if isLMI
    cstr = cstr ...
      + tag(cstr2<= -varsglob{1,1},'T upperbound') ...
      + tag(trace(T{vtx})<=tau*gamma2,'trace(...)<g');
  else
    cstr{3*(vtx-1)+2} = cstr2;
    cstr{3*(vtx-1)+3} = trace(T)-tau*gamma2;
  end
end
