function cstr = M21C01T21P01(us,R,varsglob,varsloc)
% M21C01T21P01 - Polytopic model - Analysis - PDLF with slack vars - (D-)Stability test
%   
  
%   This file is part of RoMulOC
%   Last Update 7-Nov-2014
%   author : Dimitri Peaucelle, Alberto Bortott
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

%%% Variable to be used for computing WC uncertainties
forWC=zeros(us.nb,1);
%%%

Ga = varsloc{2,1};
P = varsloc{3,1};

% for reduced size SVs
if size(Ga,2)~=us.n
  M=us.A;
  Mtest=repmat(M(:,:,1),[1,1,us.nb])-M;
  rSV=any(any(Mtest,3),2);
  nrSV=~any(any(Mtest,3),2);
  M=[M(:,:,1),-eye(us.n)];
  MG0 = null(M(nrSV,:));
else
  rSV=1:us.n;
  MG0 = eye(2*us.n);
end
cstr=lmi;
  
for vtx=1:us.nb
  MG = [us.A(:,:,vtx),-eye(us.n)];
  MG = MG(rSV,:);
  if size(R,1)==2
    lyap = [R(1,1)*P{vtx},R(1,2)*P{vtx};R(2,1)*P{vtx},R(2,2)*P{vtx}];
  else
    lyap = kron(R,P{vtx});
  end  
  lyap = MG0'*lyap*MG0 + (MG0'*MG')*Ga' + Ga*(MG*MG0) ;
  cstr = cstr + tag(lyap<=-varsglob{1,1},'Var Lyap <0');
  forWC(vtx,1)=length(cstr);
end

cstrtmp{1}=cstr;
cstrtmp{2}=forWC;
cstr=cstrtmp;
