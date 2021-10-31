function out = rand(in,dilat)
% UNCERTAINTY/RAND - Random value in uncertainty set
%   
% Function is obsolete, use <usample> instead

% rdel = rand(delta)
%
% Random value with uniform distribution. Uses RACT toolbox
% (http://sourceforge.net/projects/ract) provided that it is installed.
%
% For each block of <delta> a random value is generated.
% Uniform distribution is guaranteed for interval, parallelotopic,
% norm-bounded and bounded dissipative blocks. For polytopic blocks the
% value is the uniformly generated linear combination of vertices. For
% unbounded dissipative uncertainties (such as positive-real) the unbounded
% set is approximated by a bounded one with large radius.
%
% If RACT is not installed (old version of UNCERTAINTY/RAND) the random
% value is generated with a scaled usage of Matlab built-in RANDN function.
% There is no guarantee about uniform distribution.
%	
% SEE ALSO isin
  
%   This file is part of RoMulOC
%   Last Update 8-Mar-2013
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

out=usample(in);
% 
% if nargin<2
%     dilat=1;
% end
% tmp={};
% israndext=which('randext');
% israndext=~isempty(israndext);
% if israndext
%   dilat=1;
% end
% for ii=1:in.nbb
%     switch in.constr{ii}(1:3)
%         case 'pol'
% %           vtx=in.vtx{ii}
% %           while size(vtx,3)>1
% %             vtx=vtx(:,:,randperm(size(vtx,3));
% %             a=rand;
% %             newpt=a*vtx(:,:,1)+(1-a)*vtx(:,:,2);
% %             vtx=vtx(:,:,3:end);
% %             vtx(:,:,end+1)=newpt;
% %           end
% %           tmp{ii}=reshape(vtx,size(vtx,1),[]);
%             N=size(in.vtx{ii},3);
%             limits=sort(rand(N-1,1),1);
%             zeta=[limits;1]-[0;limits];
%             zeta=kron(zeta,eye(size(in.vtx{ii},2)));
%             tmp{ii}=reshape(in.vtx{ii},size(in.vtx{ii},1),[],1)*zeta;
%         case 'par'
%             N=size(in.vtx{ii},3)-1;
%             if israndext
%               zeta=rand(1,N);
%             else
%               zeta=rand(1,N).^(1/dilat);
%             end
%             zeta(end+1)=1;
%             zeta=kron(zeta,eye(size(in.vtx{ii},2)));
%             tmp{ii}=reshape(in.vtx{ii},size(in.vtx{ii},1),[],1)*zeta';      
%         case 'int'
%             vtxsize=[size(in.vtx{ii},1),size(in.vtx{ii},2)];
%             if israndext
%               zeta=rand(vtxsize);
%             else
%               zeta=rand(vtxsize).^(1/dilat);
%             end
%             tmp{ii}=in.vtx{ii}(:,:,1).*zeta+in.vtx{ii}(:,:,2).*(ones(vtxsize)-zeta);
%         otherwise
%             tmp{ii}=rand(melli(in.X{ii},in.Y{ii},in.Z{ii},~in.complex(ii)),dilat);
%     end
% end
% out=[];
% for ii=1:size(in.struc,2)
%     out=blkdiag(out,tmp{in.struc(2,ii)});
% end