function cstr = M21C11T21P01(us,R,varsglob,varsloc)
% M21C11T21P01 - Polytopic model - State Feedback - PDLF with slack vars - (D-)Stability test
  
%   This file is part of RoMulOC
%   Last Update 7-Nov-2014
%   author : Dimitri Peaucelle, Maud Sevin, Alberto Bortott
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

n=us.n;
mu=us.mu;

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


for vtx=1:1:us.nb
  MF=[us.A(:,:,vtx);-eye(n)];
  MS=[us.Bu(:,:,vtx);zeros(n,mu)];
  if size(R,1)==2
    lyap = [R(1,1)*P{vtx},R(1,2)'*P{vtx};R(2,1)'*P{vtx},R(2,2)*P{vtx}];
  else
    lyap = kron(R,P{vtx});
  end  
  lyap= lyap + (MF*F+MS*S)*MF0' + MF0*(MF*F+MS*S)';
  if isLMI
    cstr=cstr + tag([lyap<=varsloc{1,1}],'Var Lyap<0');
  else
    cstr{vtx} = lyap;
  end
end



