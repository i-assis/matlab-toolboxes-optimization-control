function usyslft = poly2lft(usys)
% POLY2LFT Converts a polytopic model to an LFT model
%
% syslft = poly2lft(usys) 
%
% converts the uncertain polytopic model <usys>
% into an LFT model with polytopic uncertainties
%              
% SEE ALSO: ssmodel, ussmodel, certain, udata, u2diss
       
%   This file is part of RoMulOC
%   Last Update 15-Nov-2012
%   author : Dimitri Peaucelle, Guilherme Chevarria 
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France 

if usys.type(1:3) ~= 'pol'
    error('Input argument should be polytopic USSMODEL')
end

usys=usys.ssmodel;

M=usys.allmatrices;

M11=mean(M,3);

Md=M-repmat(M11,[1 1 size(M,3)]);
d=any(abs(Md-repmat(Md(:,:,1),[1 1 size(Md,3)]))>1e-5,3);
[i,j]=find(double(d));

l12=eye(size(M,1));
l21=eye(size(M,2));

M12=l12(:,unique(i));
M21=l21(unique(j),:);

di=Md(unique(i),unique(j),:);

ixr=1:usys.n;
iz=ixr(end)+1:ixr(end)+usys.pz;
iy=iz(end)+1:iz(end)+usys.py;
izd=iy(end)+1:iy(end)+size(di,2);

ixc=1:usys.n;
iw=ixc(end)+1:ixc(end)+usys.mw;
iu=iw(end)+1:iw(end)+usys.mu;
iwd=iu(end)+1:iu(end)+size(di,1);

Mn=[M11 M12;M21 zeros(size(M21,1),size(M12,2))];

s=ssmodel(Mn,ixr,izd,iz,iy,ixc,iwd,iw,iu);

usyslft=ussmodel(s,upoly(di));