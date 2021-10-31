function cstr = M11C01T01P01(us,R,varsglob,varsloc)
% M11C01T01P01 - LFT model - Analysis - Quadratic stability - (D-)Stability test

%   This file is part of RoMulOC
%   Last Update 7-Nov-2014
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

n=us.n;
md=us.md;

P = varsglob{2,1};
sepvar = varsloc{2,1};

if isa(P,'sdpvar')
  isLMI=1;
  cstr=lmi;
else
  isLMI=0;
  cstr=cell(1,1);
end

MS = [us.Cd , us.Ddd ; oio(n,md,0)];
MP = [oio(0,n,md); us.A , us.Bd ];

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

