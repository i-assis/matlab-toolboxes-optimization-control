function cstr = M21C01T01P41(us,perf,varsglob,varsloc)
% M21C01T01P41 - Polytopic model - Analysis - Quadratic stability - impulse2peak test
  
%   This file is part of RoMulOC
%   Last Update 7-Nov-2014
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France


%%% Variable to be used for computing WC uncertainties
forWC=zeros(us.nb,4);
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
  % check that peak is not infitite at t=0
  if any(any(any(us.Dzw)))
    error('cannot compute peak at t=0: Dzw~=0');
  end
  R=[0 1;1 0];
end

cstr=lmi;

for vtx=1:us.nb
  MP1 = [speye(us.n);us.A(:,:,vtx)];
  cstr = cstr ...
    + tag(MP1'*kron(R,P)*MP1<= -varsglob{1,1},'Var Lyap <0');
  forWC(vtx,1)=length(cstr);
  MP2 = us.Bw(:,:,vtx);
  if any(any(MP2))
    cstr = cstr ...
      + tag(MP2'*P*MP2<=tau*gamma2*eye(us.mw),'|xinit|<g^2');
    forWC(vtx,2)=length(cstr);
  end
  Mc3 = us.Cz(:,:,vtx);
  if any(any(Mc3))
    cstr = cstr ...
      + tag(tau*(Mc3'*Mc3)<=P,'|z|<Lyap');
    forWC(vtx,3)=length(cstr);
  end
  Mc4 = us.Dzw(:,:,vtx);
  if any(any(Mc4))
    cstr = cstr ...
      + tag(tau*(Mc4'*Mc4)<=tau*gamma2,'|zinit|<g^2');
    forWC(vtx,4)=length(cstr);
  end
end

cstrtmp{1}=cstr;
cstrtmp{2}=forWC;
cstr=cstrtmp;
