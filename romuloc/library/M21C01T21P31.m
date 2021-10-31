function cstr = M21C01T21P31(us,perf,varsglob,varsloc)
% M21C01T21P31 - Polytopic model - Analysis - PDLF with slack vars - H2 test  
  
%   This file is part of RoMulOC
%   Last Update 7-Nov-2014
%   author : Dimitri Peaucelle, Alberto Bortott
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

if perf
  gamma2 = perf^2;
  tau = varsloc{1,1};
else
  gamma2 = varsloc{1,1};
  tau = 1;
end
Ga = varsloc{2,1};
Gb = varsloc{3,1};
P = varsloc{4,1};
T = varsloc{5,1};

% reduced size SVs
if size(Ga,2)~=us.n
  Ma=us.A;
  Matest=repmat(Ma(:,:,1),[1,1,us.nb])-Ma;
  rSVa=any(any(Matest,3),2);
  nrSVa=~any(any(Matest,3),2);
  Ma=[Ma(:,:,1),-eye(us.n)];
  MG0a = null(Ma(nrSVa,:));
else
  rSVa = 1:us.n;
  MG0a = eye(2*us.n);
end
if size(Gb,2)~=us.n
  Mb=us.Bw;
  Mbtest=repmat(Mb(:,:,1),[1,1,us.nb])-Mb;
  rSVb=any(any(Mbtest,3),2);
  nrSVb=~any(any(Mbtest,3),2);
  Mb=[Mb(:,:,1),-eye(us.n)];
  MG0b = null(Mb(nrSVb,:));
else
  rSVb = 1:us.n;
  MG0b = eye(us.mw+us.n);
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

%%% Initialize set of constraints
cstr=lmi;
%%% Variable to be used for computing WC uncertainties
forWC=zeros(us.nb,3);

for vtx=1:us.nb
  Mc = [us.Cz(:,:,vtx),sparse(us.pz,us.n)]*MG0a;
  MG = [us.A(:,:,vtx),-speye(us.n)]*MG0a;
  MG = MG(rSVa,:); %%% remove rows that are identical
  lyap = MG0a'*kron(R,P{vtx})*MG0a +tau*(Mc'*Mc) + MG'*Ga' + Ga*MG;
  cstr = cstr + tag(lyap<= -varsglob{1,1},'Var Lyap <0');
  forWC(vtx,1)=length(cstr);
  if ~isempty(rSVb)
    MGb = [us.Bw(:,:,vtx),-speye(us.n)]*MG0b;
    MGb = MGb(rSVb,:);
    MT  = oio(0,us.mw,us.n)*MG0b;
    MP  = oio(us.mw,us.n,0)*MG0b;
    Mc  = us.Dzw(:,:,vtx)*oio(0,us.mw,us.n)*MG0b;
    lyap2 = MP'*P{vtx}*MP + tau*(Mc'*Mc) - MT'*T{vtx}*MT + MGb'*Gb' + Gb*MGb;
    cstr = cstr + tag(lyap2<= -varsglob{1,1},'... < T');
    forWC(vtx,2)=length(cstr);
    cost = trace(T{vtx});
  else
    MP = us.Bw(:,:,vtx);
    Mc = us.Dzw(:,:,vtx);
    cost = trace(MP'*P{vtx}*MP+tau*(Mc'*Mc));
  end
  cstr = cstr + tag(cost<=tau*gamma2,'trace(...)<g^2');
  forWC(vtx,3)=length(cstr);
end

cstrtmp{1}=cstr;
cstrtmp{2}=forWC;
cstr=cstrtmp;

  
  