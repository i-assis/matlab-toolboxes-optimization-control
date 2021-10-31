function cstr = M21C11T21P21(us,perf,varsglob,varsloc)
% M21C11T21P21 - Polytopic model - State feedback-  PDLF with slack vars - Hinfinity test
  
%   This file is part of RoMulOC
%   Last Update 7-Nov-2014
%   author : Dimitri Peaucelle, Maud Sevin, Alberto Bortott
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

n=us.n;
mu=us.mu;
mw=us.mw;

F = varsglob{2,1};
S = varsglob{3,1};
MF0 = varsloc{2,1};
P = varsloc{3,1};

if isa(F,'sdpvar')
  isLMI=1;
  cstr=lmi;
else
  isLMI=0;
  cstr=cell(us.nb,1);
end

if perf
  gamma2 = perf^2;
  tau = 1;
else
  gamma2 = varsloc{1,1};
  tau = 1;
end

if us.T
  R=[-1 0;0 1];
else
  R=[0 1;1 0];
end

MP=[oio(0,us.n,us.pz+us.n);
    oio(us.n+us.pz,us.n,0)];
Mg=oio(us.n,us.pz,us.n);

for vtx=1:us.nb
  Mc=[us.Bw(:,:,vtx)',us.Dzw(:,:,vtx)',zeros(mw,n)];
  MF=[us.A(:,:,vtx); us.Cz(:,:,vtx); -eye(n)];
  MS=[us.Bu(:,:,vtx); us.Dzu(:,:,vtx); zeros(n,mu)];
  Lyap=MP'*kron(R,P{vtx})*MP+tau*(Mc'*Mc)+(MF*F+MS*S)*MF0'+MF0*(MF*F+MS*S)'-tau*gamma2*(Mg'*Mg);  
  if isLMI
    if perf
      cstr=cstr + tag([Lyap<= varsloc{1,1}], 'Var lyap<0');
    else
      cstr=cstr + tag([Lyap<=-varsglob{1,1}], 'Var lyap<0');
    end
  else
    cstr{vtx}=Lyap;
  end
end
   



