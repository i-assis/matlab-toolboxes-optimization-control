function cstr = M21C01T01P01(us,R,varsglob,varsloc)
% M21C01T01P01 - Polytopic model - Analysis - Quadratic stability - (D-)Stability test
  
%   This file is part of RoMulOC
%   Last Update 7-Nov-2014
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

%%% Variable to be used for computing WC uncertainties
forWC=zeros(us.nb,1);
%%%

P = varsglob{2,1};
  
cstr=lmi;

for vtx=1:us.nb
  MP = [speye(us.n);us.A(:,:,vtx)];
  if size(R,1)==2
    lyap = MP'*[R(1,1)*P,R(1,2)*P;R(2,1)*P,R(2,2)*P]*MP;
  else
    lyap = MP'*kron(R,P)*MP;
  end
  cstr = cstr + tag(lyap<=-varsglob{1,1},'Var Lyap <0');
  forWC(vtx,1)=length(cstr);
end

cstrtmp{1}=cstr;
cstrtmp{2}=forWC;
cstr=cstrtmp;
