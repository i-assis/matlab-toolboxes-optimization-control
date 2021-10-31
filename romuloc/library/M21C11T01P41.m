function cstr = M21C11T01P41(us,perf,varsglob,varsloc)
% M21C11T01P41 - Polytopic model - State feedback - Quadratic stability - impulse2peak test

%   This file is part of RoMulOC
%   Last Update 7-Nov-2014
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

n=us.n;
mu=us.mu;
pz=us.pz;

P = varsglob{2,1};
S = varsglob{3,1};

if isa(P,'sdpvar')
  isLMI=1;
  cstr=lmi;
else
  isLMI=0;
  cstr=cell(4*us.nb,1);
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
for vtx=1:us.nb
  if us.T == 0
    RP = [zeros(n,n), P;...
          P, zeros(n,n)];
    MP = [us.A(:,:,vtx), eye(n)];
    MS = [us.Bu(:,:,vtx), eye(n)];
  else
    RP = [-P, zeros(n, 2*n); ...
          zeros(n, 2*n), P;...
          zeros(n, n), P, zeros(n, n)];
    MP = [eye(n), us.A(:,:,vtx), zeros(n,n); ...
          zeros(n, n), -0.5*eye(n), eye(n)];
    MS = [us.Bu(:,:,vtx), zeros(n,n); ...
          zeros(n,mu),eye(n)];
  end
  cstr1 = MP*RP*MP' + MS*RS*MS';
  
  RP = [zeros(n,n), P;...
        P, zeros(n,n)];
  MP = [us.Cz(:,:,vtx),zeros(pz,n); ...
        -0.5*eye(n), eye(n)];
  MS = [us.Dzu(:,:,vtx), zeros(pz,n); ...
        zeros(n,mu), eye(n)];
  Mg = [eye(pz); zeros(n, pz)];
  cstr2 = MP*RP*MP'+ MS*RS*MS' - tau*gamma2*(Mg*Mg');
  
  Mc=us.Bw(:,:,vtx);
  cstr3 = -P + tau*(Mc*Mc');
  
  Mc=us.Dzw(:,:,vtx);
  cstr4 = tau*(Mc*Mc') - tau*gamma2*eye(pz);
  
  if isLMI
    cstr = cstr + tag([cstr1<= -varsglob{1,1}],'Var Lyap <=0');
    cstr = cstr + tag([cstr2<= -varsglob{1,1}],'Constraint on Cz');
    cstr = cstr + tag([cstr3<= -varsglob{1,1}],'Constraint on Bw');
    cstr = cstr + tag([cstr4<= -varsglob{1,1}],'Constraint on Dzw');

  else
    cstr{4*(vtx-1)+1} = cstr1;
    cstr{4*(vtx-1)+2} = cstr2;
    cstr{4*(vtx-1)+3} = cstr3;
    cstr{4*(vtx-1)+4} = cstr4;
  end
    
end
