function cstr = M21C11T21P31(us,perf,varsglob,varsloc)
% M21C11T21P31 - Polytopic model - State feedback - PDLF with slack vars - H2 test

%   This file is part of RoMulOC
%   Last Update 7-Nov-2014
%   author : Dimitri Peaucelle, Maud Sevin, Alberto Bortott
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France
  
n=us.n;
mw=us.mw;
mu=us.mu;
pz=us.pz;

F = varsglob{2,1};
S = varsglob{3,1};
MFA0 = varsloc{2,1};
MFC0 = varsloc{3,1};
P = varsloc{4,1};
T = varsloc{5,1};

if isa(F,'sdpvar')
  isLMI=1;
  cstr=lmi;
else
  isLMI=0;
  cstr=cell(3*us.nb,1);
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

MT=oio(0,pz,n);
MP=oio(pz,n,0);

for vtx=1:us.nb
    
  Mc=[us.Bw(:,:,vtx);zeros(n,mw)];
  MF=[us.A(:,:,vtx);-eye(n)];
  MS=[us.Bu(:,:,vtx);zeros(n,mu)];
  Lyap = kron(R,P{vtx})+tau*(Mc*Mc')+(MF*F+MS*S)*MFA0'+MFA0*(MF*F+MS*S)';
  
  Mc=[us.Dzw(:,:,vtx);zeros(n,mw)];
  MF=[us.Cz(:,:,vtx); -eye(n)];
  MS=[us.Dzu(:,:,vtx); zeros(n,mu)];
  onT=MP'*P{vtx}*MP-MT'*T{vtx}*MT+tau*(Mc*Mc')+(MF*F+MS*S)*MFC0'+MFC0*(MF*F+MS*S)';  
  
  if isLMI
    if perf
      cstr = cstr + tag([Lyap<= varsloc{1,1}],'Var Lyap<0');
      cstr = cstr + tag([onT<= varsloc{1,1}], 'T upperbound');
    else
      cstr = cstr + tag([Lyap<= -varsglob{1,1}],'Var Lyap<0');
      cstr = cstr + tag([onT<= -varsglob{1,1}], 'T upperbound');
    end
    cstr = cstr + tag([trace(T{vtx})<=tau*gamma2],'trace(...)<g');
  else
    cstr{3*vtx-2} = Lyap;
    cstr{3*vtx-1} = onT;
    cstr{3*vtx} = trace(T{vtx})-tau*gamma2;
  end
  
end




