function out = rand(in)
% UNCERTAINTY/CENTER - Center of uncertainty set (if bounded)
%
% c = center(u)
%
% For polytopic uncertainties the center is defined as the sum of vertices
% divided by their number. 
%
% SEE ALSO uncertainty/isin, uncertainty/rand
  
%   This file is part of RoMulOC
%   Last Update 26-Nov-2012
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

tmp={};
for ii=1:in.nbb
    switch in.constr{ii}(1:3)
        case 'pol'
            N=size(in.vtx{ii},3);
            zeta=ones(1,N)/N;
            zeta=kron(zeta,eye(size(in.vtx{ii},2)));
            tmp{ii}=reshape(in.vtx{ii},size(in.vtx{ii},1),[],1)*zeta';
        case 'par'
            N=size(in.vtx{ii},3)-1;
            zeta=zeros(1,N);
            zeta(end+1)=1;
            zeta=kron(zeta,eye(size(in.vtx{ii},2)));
            tmp{ii}=reshape(in.vtx{ii},size(in.vtx{ii},1),[],1)*zeta';      
        case 'int'
            tmp{ii}=0.5*(in.vtx{ii}(:,:,1)+in.vtx{ii}(:,:,2));
        otherwise
            if in.complex(ii)
                warning('Complex block treated as real');
            end
            tmp{ii}=center(melli(in.X{ii},in.Y{ii},in.Z{ii}));
    end
end
out=[];
for ii=1:size(in.struc,2)
    out=blkdiag(out,tmp{in.struc(2,ii)});
end