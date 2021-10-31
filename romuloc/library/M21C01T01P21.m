function cstr = M21C01T01P21(us,perf,varsglob,varsloc)
% M21C01T01P21 - Polytopic model - Analysis - Quadratic stability - Hinfinty test
  
%   This file is part of RoMulOC
%   Last Update 7-Nov-2014
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France


%%% Variable to be used for computing WC uncertainties
forWC=zeros(us.nb,1);
%%%

P = varsglob{2,1};
if perf
  gamma2 = perf^2;
  tau = varsloc{1,1};
else
  gamma2 = varsloc{1,1};
  tau = 1;
end
  
if us.T
  R=[-1 0;0 1];
else
  R=[0 1;1 0];
end

cstr=lmi;
Mg = oio(us.n,us.mw,0);
  
for vtx=1:us.nb
  MP = [oio(0,us.n,us.mw);us.A(:,:,vtx),us.Bw(:,:,vtx)];
  Mc = [us.Cz(:,:,vtx),us.Dzw(:,:,vtx)];
  lyap = MP'*kron(R,P)*MP - tau*gamma2*(Mg'*Mg) + tau*(Mc'*Mc);
  cstr = cstr + tag(lyap<= -varsglob{1,1},'Var Lyap <0');
  forWC(vtx,1)=length(cstr);
end
  
cstrtmp{1}=cstr;
cstrtmp{2}=forWC;
cstr=cstrtmp;
