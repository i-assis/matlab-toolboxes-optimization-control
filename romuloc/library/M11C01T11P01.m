function cstr = M11C01T11P01(us,R,varsglob,varsloc)
% M11C01T11P01 - LFT model - Analysis - PDLF T11 - (D-)Stability test

%   This file is part of RoMulOC
%   Last Update 7-Nov-2014
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

n=us.n;
md=us.md;
pd=us.pd;

P = varsglob{2,1};
sepvar = varsloc{2,1};

if isa(P,'sdpvar')
  isLMI=1;
  cstr=lmi;
else
  isLMI=0;
  cstr=cell(1,1);
end

MP = [oio(0,n+md,md);
  us.A,us.Bd,sparse(n,md);...
  oio(n+md,md,0)];
MS = [us.Cd, us.Ddd,sparse(pd,md);...
  us.Cd*us.A, us.Cd*us.Bd, us.Ddd;...
  oio(n,2*md,0)];

if size(R,1)==2
  lyap = MP'*[R(1,1)*P,R(1,2)*P;R(2,1)*P,R(2,2)*P]*MP-MS'*sepvar*MS;
else
  lyap = MP'*kron(R,P)*MP-MS'*sepvar*MS;
end

if isLMI;
  cstr = tag([lyap<= -varsglob{1,1}],'Var Lyap <0');
else
  cstr{1} = lyap;
end

