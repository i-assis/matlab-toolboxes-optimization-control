function out = rand(in,dilat,type)
% SSMODEL/RAND - Random combinantion of values in array of SSMODEL
%	
%  sys = rand(sysin)
%
%  Generates a uniform distribution over the simplex based on which it
%  takes a linear combination of components of the array of SSMODEL

%   This file is part of RoMulOC
%   Last Update 20-Oct-2012
%   author : Dimitri Peaucelle, Alberto Bortott
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France


if nargin<2
    dilat=1;
end
if nargin<3
  type='pol';
end

out=ssmodel(in.name);
out.nb=1;
out.r=in.r;
out.c=in.c;
out.T=in.T;

switch type
  case 'pol'
    nb=in.nb;
    nbrows=size(in.M,1);
    nbcols=size(in.M,2);
    limits=sort(rand(nb-1,1),1);
    zeta=[limits;1]-[0;limits];
    zeta=kron(zeta,eye(nbcols));
    out.M=reshape(in.M,nbrows,[],1)*zeta;
  case 'par'
    N=in.nb-1;
    nbrows=size(in.M,1);
    nbcols=size(in.M,2);
    zeta=rand(N,1);
    zeta(end+1)=1;
    zeta=kron(zeta,eye(nbcols));
    out.M=reshape(in.M,nbrows,[],1)*zeta;
  case 'int'
    vtxsize=[size(in.M,1),size(in.M,2)];
    zeta=rand(vtxsize);
    out.M=in.M(:,:,1).*zeta+in.M(:,:,2).*(ones(vtxsize)-zeta);
end