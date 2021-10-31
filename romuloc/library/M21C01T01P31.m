function cstr = M21C01T01P31(us,perf,varsglob,varsloc)
% M21C01T01P31 - Polytopic model - Analysis - Quadratic stability - H2 test 
  
%   This file is part of RoMulOC
%   Last Update 7-Nov-2014
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

%%% Variable to be used for computing WC uncertainties
forWC=zeros(us.nb,2);
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
  % check that H2 norm exists
  if any(any(any(us.Dzw)))
    error('cannot compute H2 norm: Dzw~=0');
  end
  R=[0 1;1 0];
end

cstr=lmi;
  
for vtx=1:us.nb
  MP1 = [speye(us.n);us.A(:,:,vtx)];
  MP2 = us.Bw(:,:,vtx);
  Mc1 = us.Cz(:,:,vtx);
  Mc2 = us.Dzw(:,:,vtx);
  lyap = MP1'*kron(R,P)*MP1 + tau*(Mc1'*Mc1);
  cost = trace(MP2'*P*MP2+tau*(Mc2'*Mc2));
  cstr = cstr + tag(lyap<= -varsglob{1,1},'Var Lyap <0');
  forWC(vtx,1)=length(cstr);
  cstr = cstr + tag(cost<=tau*gamma2,'trace(...)<g');
  forWC(vtx,2)=length(cstr);
end

cstrtmp{1}=cstr;
cstrtmp{2}=forWC;
cstr=cstrtmp;
