function cstr = M21C01T21P21 (us,perf,varsglob,varsloc)
% M21C01T21P21 - Polytopic model - Analysis - PDLF with slack vars - Hinfinty test   
  
%   This file is part of RoMulOC
%   Last Update 7-Nov-2014
%   author : Dimitri Peaucelle, Alberto Bortott
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

%%% Variable to be used for computing WC uncertainties
forWC=zeros(us.nb,1);
%%%

if perf
  gamma2 = perf^2;
  tau = varsloc{1,1};
else
  gamma2 = varsloc{1,1};
  tau = 1;
end
Ga = varsloc{2,1};
P = varsloc{3,1};

% reduced size SVs
if size(Ga,2)~=us.n
  M=[us.A,us.Bw];
  Mtest=repmat(M(:,:,1),[1,1,us.nb])-M;
  rSV=any(any(Mtest,3),2);
  nrSV=~any(any(Mtest,3),2);
  M=[M(:,:,1),-eye(us.n)];
  MG0 = null(M(nrSV,:));
else
  rSV=1:us.n;
  MG0 = eye(2*us.n+us.mw);
end

if us.T
  R=[-1 0;0 1];
else
  R=[0 1;1 0];
end

cstr=lmi;
MP = [oio(0,us.n,us.mw+us.n);...
  oio(us.n+us.mw,us.n,0)]*MG0;
Mg = oio(us.n,us.mw,us.n)*MG0;
for vtx=1:us.nb
  Mc = [us.Cz(:,:,vtx),us.Dzw(:,:,vtx),sparse(us.pz,us.n)]*MG0;
  MG = [us.A(:,:,vtx),us.Bw(:,:,vtx),-speye(us.n)]*MG0;
  MG = MG(rSV,:); %%% remove rows that are identical
  lyap = MP'*kron(R,P{vtx})*MP - tau*gamma2*(Mg'*Mg) + tau*(Mc'*Mc) + MG'*Ga' + Ga*MG;
  cstr = cstr + tag(lyap<= -varsglob{1,1},'Var Lyap <0');
  forWC(vtx,1)=length(cstr);
end

cstrtmp{1}=cstr;
cstrtmp{2}=forWC;
cstr=cstrtmp;
