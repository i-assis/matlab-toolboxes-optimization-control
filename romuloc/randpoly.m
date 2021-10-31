function usys=randpoly(T,n,mw,pz,vtxnb,density,disttounstab,perturb)
% RANDPOLY - generate random polynomial ussmodel
%
% usys=randpoly(T,n,mw,pz,vtxnb,density,disttounstab,perturb)
%
% T : 0 for continuous time systems, -1 or sample time for discrete
% n : order of system
% mw : number of performance inputs
% pz : number of performance outputs
% vtxnb : number of vertices
% density : matrices are sparse with that density distribution
% disttounstab : distance to unstability indicator (positive scalar)
% perturb : size of perturbation to generate vertices around central value
%
% Generated systems have stable vertices.
% For half of the vertices the code tends to force a pole
% to be at distance <disttounstab> from unstability.
%
% usys : USSMODEL object from ROMULOC toolbox

opt=optimset('Display','off','TolX',0.0001,'TolFun',0.0001);
M=[];
centralnotok=1;
centraldisttounstab=1.3*disttounstab;
while centralnotok
  MA=sprandn(n,n,density);
  [ii,jj,ss]=find(MA);
  keep=1:length(ii);
  MS=sprandn(sparse(ii(keep),jj(keep),ss(keep),n,n));
  if T
    x=fminsearch(@(x) -x*(abs(eigs(MA+x*MS,1,'LM'))<1-centraldisttounstab & (x<perturb) & (0<x) ),0,opt);
  else
    x=fminsearch(@(x) -x*(eigs(MA+x*MS,1,'LR')<-centraldisttounstab & (x<perturb) & (x>0) ),0,opt);
  end
  MA=MA+x*MS;
  if T
    mvap=abs(eigs(MA,1,'LM'));
    if mvap>0.1 && mvap<=1-centraldisttounstab
      centralnotok=0;
    end
  else
    mvap=real(eigs(MA,1,'LR'));
    if mvap<=-centraldisttounstab
      centralnotok=0;
    end
  end
end
MB=sprandn(n,mw,density/2);
MC=sprandn(pz,n,density/2);
MS=[MA,MB;MC,zeros(pz,mw)];
[ii,jj,ss]=find(MS);
for vtx=1:vtxnb
  keep=randi(length(ii),[2,1]);
  MSi=sprandn(sparse(ii(keep),jj(keep),ss(keep),n+pz,n+mw));
  if T
    x=fminsearch(@(x) -x*(abs(eigs(MA+x*MSi(1:n,1:n),1,'LM'))<1-disttounstab & (x<perturb) & (0<x) ),0,opt);
  else
    x=fminsearch(@(x) -x*(eigs(MA+x*MSi(1:n,1:n),1,'LR')<-disttounstab & (x<perturb) & (x>0) ),0,opt);
  end
  M(:,:,vtx)=full(MS+x*MSi);
end

usys=ssmodel(M,1:n,[],(n+1):(n+pz),[],1:n,[],(n+1):(n+mw),[],T);
usys=upoly(usys);


