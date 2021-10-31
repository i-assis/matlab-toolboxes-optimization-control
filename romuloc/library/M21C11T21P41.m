function cstr = M21C11T21P41(us,perf,varsglob,varsloc)
% M21C11T21P41 - Polytopic model - State feedback - PDLF with slack vars - impulse2peak test
  
%   This file is part of RoMulOC
%   Last Update 7-Nov-2014
%   author : Dimitri Peaucelle, Maud Sevin, Alberto Bortott
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

n=us.n;
mu=us.mu;
pz=us.pz;

F = varsglob{2,1};
S = varsglob{3,1};
MFA0 = varsloc{2,1};
MFC0 = varsloc{3,1};
P = varsloc{4,1};

if isa(F,'sdpvar')
  isLMI=1;
  cstr=lmi;
else
  isLMI=0;
  cstr=cell(4*us.nb,1);
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

MP=oio(pz,n,0);
Mg = oio(0,n,pz);

for vtx=1:us.nb

  MF = [us.A(:,:,vtx); -eye(n)];
  MS = [us.Bu(:,:,vtx); zeros(n,mu)];
  Lyap = kron(R,P{vtx}) +(MF*F+MS*S)*MFA0'+MFA0*(MF*F+MS*S)';

  MF = [us.Cz(:,:,vtx); -eye(n)];
  MS = [us.Dzu(:,:,vtx); zeros(n,mu)];
  onT=MP'*P{ii}*MP-tau*gamma2*(Mg'*Mg)+(MF*F+MS*S)*MFC0'+MFC0*(MF*F+MS*S)';
  
  if isLMI
    if perf
      cstr = cstr + tag([Lyap<= varsloc{1,1}],'Var Lyap<0');
      cstr = cstr + tag([onT<= varsloc{1,1}], '|xinit|<g^2');
    else
      cstr = cstr + tag([Lyap<= -varsglob{1,1}],'Var Lyap<0');
      cstr = cstr + tag([onT<= -varsglob{1,1}], '|xinit|<g^2');
    end
    cstr = cstr + tag([tau*(us.Bw(:,:,vtx)*us.Bw(:,:,vtx)')<=P],'|z|<Lyap');    
    cstr = cstr + tag([tau*(us.Dzw(:,:,vtx)*us.Dzw(:,:,vtx)')<=tau*gamma2],'|zinit|<g^2');
  else
    cstr{4*vtx-3}=Lyap;
    cstr{4*vtx-2}=onT;
    cstr{4*vtx-1}=tau*(us.Bw(:,:,vtx)*us.Bw(:,:,vtx)')-P;
    cstr{4*vtx}=tau*(us.Dzw(:,:,vtx)*us.Dzw(:,:,vtx)')-tau*gamma2;
  end
end
    
