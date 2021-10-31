function cstr = M11C11T01P01(us,R,varsglob,varsloc)
% M11C11T01P01 - LFT model - State Feedback - Quadratic stability - (D-)Stability test
  
%   This file is part of RoMulOC
%   Last Update 7-Nov-2014
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

n=us.n;
pd=us.pd;

P = varsglob{2,1};
S = varsglob{3,1};
sepvar = varsloc{2,1};

if isa(P,'sdpvar')
  isLMI=1;
  cstr=lmi;
else
  isLMI=0;
  cstr=cell(1,1);
end

payle = us.A * P + us.Bu * S;
MP11 = R(1,1) * P + R(1,2) * payle' + R(2,1) * payle;
paylf= us.Cd * P + us.Ddu * S;
MP12 = R(1,2) * paylf';
MP21 = R(2,1) * paylf;
MP22 = sparse(pd, pd);
lyapMP = [MP11, MP12; MP21, MP22];
MS = [us.Bd, sparse(n, pd);us.Ddd, eye(pd)];
lyapMS = MS * sepvar * MS';
lyap = lyapMP - lyapMS;

if R(2,2) == 0
  if isLMI;
    cstr = tag(lyap<= -varsglob{1,1},'Var Lyap <0');
  else
    cstr{1} = lyap;
  end
else
  Lyap = [ lyap, [payle; paylf]; ...
           [payle', paylf', -R(2,2) * P]];
  if isLMI;
    cstr = tag(Lyap<= -varsglob{1,1},'Var Lyap <0');
  else
    cstr{1} = lyap;
  end
end
