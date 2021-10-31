function cstr = M21C01T21P41(us,perf,varsglob,varsloc)
% M21C01T21P41 - Polytopic model - Analysis - PDLF with slack vars - impulse2peak test
  
%   This file is part of RoMulOC
%   Last Update 7-Nov-2014
%   author : Dimitri Peaucelle, Alberto Bortott
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

F = varsglob{2,1};
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
  % check that peak is not infitite at t=0
  if any(any(any(us.Dzw)))
    error('cannot compute peak at t=0: Dzw~=0');
  end
  R=[0 1;1 0];
end

%%% Initialize set of constraints
cstr=lmi;
%%% Variable to be used for computing WC uncertainties
forWC=zeros(us.nb,4);

for vtx=1:us.nb
  MG = [us.A(:,:,vtx),-speye(us.n)]*MG0a;
  MG = MG(rSVa,:); %%% remove rows that are identical
  lyap = MG0a'*kron(R,P{vtx})*MG0a;
  if ~isempty(MG)
    lyap = lyap + MG'*Ga' + Ga*MG;
  end
  cstr = cstr + tag(lyap<= -varsglob{1,1},'Var Lyap <0');
  forWC(vtx,1)=length(cstr);
  
  MGb = [us.Bw(:,:,vtx),-speye(us.n)]*MG0b;
  MGb = MGb(rSVb,:); %%% remove rows that are identical
  Mg  = oio(0,us.mw,us.n)*MG0b;
  MP  = oio(us.mw,us.n,0)*MG0b;
  xinit = MP'*P{vtx}*MP - tau*gamma2*(Mg'*Mg);
  if ~isempty(MGb)
     xinit =  xinit + MGb'*Gb' + Gb*MGb;
  end
  cstr = cstr + tag(xinit<= -varsglob{1,1},'|xinit|<g^2');
  forWC(vtx,2)=length(cstr);
  Mc3 = us.Cz(:,:,vtx);
  if any(any(Mc3))
    cstr = cstr + tag(tau*(Mc3'*Mc3)<=P{vtx},'|z|<Lyap');
    forWC(vtx,3)=length(cstr);
  end
  Mc4 = us.Dzw(:,:,vtx);
  if any(any(Mc4))
    cstr = cstr + tag(tau*(Mc4'*Mc4)<=tau*gamma2,'|zinit|<g^2');
    forWC(vtx,4)=length(cstr);
  end
end

cstrtmp{1}=cstr;
cstrtmp{2}=forWC;
cstr=cstrtmp;

  