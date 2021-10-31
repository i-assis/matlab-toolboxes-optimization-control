function cstr = M21C11T01P21(us,perf,varsglob,varsloc)
% M21C11T01P21 - Polytopic model - State feedback - Quadratic stability - Hinfinity test 
  
%   This file is part of RoMulOC
%   Last Update 7-Nov-2014
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

n=us.n;
mu=us.mu;
mw=us.mw;
pz=us.pz;

P = varsglob{2,1};
S = varsglob{3,1};

if isa(P,'sdpvar')
  isLMI=1;
  cstr=lmi;
else
  isLMI=0;
  cstr=cell(us.nb,1);
end

if perf
  gamma2 = perf^2;
  tau = varsloc{1,1};
else
  gamma2 = varsloc{1,1};
  tau = 1;
end

RS = [zeros(mu,mu), S;...
      S', zeros(n,n)];
    
if us.T == 0
  RP = [zeros(n,n),P;...
        P,zeros(n,n)];
  Mg = [zeros(n,pz);...
        eye(pz)];
else
  RP = [-P, zeros(n, 2*n); ...
        zeros(n,2*n), P;...
        zeros(n,n), P, zeros(n,n)];
  Mg = [zeros(n,pz);...
        eye(pz);...
        zeros(n,pz)];
end

A=us.A;
Bw=us.Bw;
Bu=us.Bu;
Cz=us.Cz;
Dzw=us.Dzw;
Dzu=us.Dzu;

for vtx=1:us.nb
  if us.T == 0
    MP = [A(:,:,vtx), eye(n);...
          Cz(:,:,vtx), zeros(pz,n)];
    MS = [Bu(:,:,vtx), eye(n);...
          Dzu(:,:,vtx), zeros(pz,n)];
    Mc = [Bw(:,:,vtx);...
          Dzw(:,:,vtx)];
  else
    MP = [eye(n),A(:,:,vtx),zeros(n,n);...
          zeros(pz,n),Cz(:,:,vtx),zeros(pz,n);...
          zeros(n,n), -0.5*eye(n), eye(n)];
    MS = [Bu(:,:,vtx),zeros(n,n);...
          Dzu(:,:,vtx),zeros(pz,n);...
          zeros(n,mu),eye(n)];
    Mc = [Bw(:,:,vtx);...
          Dzw(:,:,vtx);...
          zeros(n,mw)];
  end 
  lyap = MP*RP*MP' + MS*RS*MS' - tau*gamma2*(Mg*Mg') + tau*(Mc*Mc');
  if isLMI;
    cstr = cstr + tag(lyap<= -varsglob{1,1},'Var Lyap <0');
  else
    cstr{vtx} = lyap;
  end
end
