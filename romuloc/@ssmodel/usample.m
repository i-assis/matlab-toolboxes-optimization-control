function out = usample(in,sample_nb,type)
% SSMODEL/USAMPLE - internal - see ussmodel/usample

%   This file is part of RoMulOC
%   Last Update 13-Nov-2013
%   author : Dimitri Peaucelle, Alberto Bortott
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France


if nargin<2
  sample_nb=1;
end
if nargin<3
  type='pol';
end

out=ssmodel(in.name);
out.r=in.r;
out.c=in.c;
out.T=in.T;
out.nb=sample_nb;

switch type
  case 'pol'
    nb=in.nb;
    nbrows=size(in.M,1);
    nbcols=size(in.M,2);
    for jj=1:sample_nb
      limits=sort(rand(nb-1,1),1);
      zeta=[limits;1]-[0;limits];
      zeta=kron(zeta,eye(nbcols));
      out.M(:,:,jj)=reshape(in.M,nbrows,[],1)*zeta;
    end
  case 'par'
    N=in.nb-1;
    nbrows=size(in.M,1);
    nbcols=size(in.M,2);
    zeta=zeros(N+1,1);
    for jj=1:sample_nb
      zeta(1,1:N)=2*rand(N,1)-1;
      zeta(N+1,1)=1;
      zetak=kron(zeta,eye(nbcols));
      out.M(:,:,jj)=reshape(in.M,nbrows,[],1)*zetak;
    end
  case 'int'
    vtxsize=[size(in.M,1),size(in.M,2)];
    for jj=1:sample_nb
      zeta=rand(vtxsize);
      out.M(:,:,jj)=in.M(:,:,1).*zeta+in.M(:,:,2).*(ones(vtxsize)-zeta);
    end
  otherwise
    error('undefined or not coded case yet')
end
    