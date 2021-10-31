function out = usample(in,sample_nb)
% UNCERTAINTY/USAMPLE - Many random values in uncertainty set
%
% rdel = usample(delta,nb)
%
% <nb> is the number of samples to be generated
% <rdel> is a 3D matrix, the third dimension stacks the samples
%
% For some types of uncertainties it uses function taken from RACT toolbox
% (http://sourceforge.net/projects/ract). It needs not to be installed.
%
% Sampling applies only to the probabilistic uncertainty blocks. If there
% are no probabilistic uncertainties, then the  deterministic LTI blocks are
% sampled as if uniformly distributed. If there are no LTI blocks, the TV
% blocks are sampled as if uniformly distributed. If there are no linear
% blocks, the NL blocs are sampled as if uniformly distributed.
%
% Default, uniform distribution is applied. For polytopic blocks the
% sampling is the uniformly generated linear combination of vertices (not
% guaranteed to be a uniform distribution of the actual uncertainty set).
% For unbounded dissipative uncertainties (such as positive-real) the unbounded
% set is approximated by a bounded one with large radius.
%
% SEE ALSO uncertainty, isin

%   This file is part of RoMulOC
%   Last Update 10-Nov-2013
%   author : Dimitri Peaucelle, Alberto Bortott
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

issampled=find(in.sampled);
if ~isempty(issampled)
  sample_nb_prev=size(in.usample{issampled(1)},3);
  if nargin<2
    sample_nb=sample_nb_prev;
  elseif sample_nb~=sample_nb_prev;
    error('number of samples (inherited) should be %i',sample_nb_prev); 
  else
    % everything is OK
  end
elseif nargin<2
  sample_nb=1;
end

% If the object combines different types of uncertainties, sampling does
% not work the same. Here are the different case.
tobesampled=find((in.distribution>1).*(~in.sampled));
if ~isempty(tobesampled)
  % SAMPLECASE=1 if there exist uncertainties defined as probabilistic
  % (uniform or gaussian) that are not sampled yet.
else
  tobesampled=find((in.nature==10).*(~in.sampled));
  if ~isempty(tobesampled)
    % SAMPLECASE=2 if there are no probabilistic uncertainties but there
    % are LTI uncertainties that are not sampled yet
  else
    tobesampled=find((in.nature==20).*(~in.sampled));
    if ~isempty(tobesampled)
      % SAMPLECASE=3 if there are no LTI uncertainties but there
      % are TV uncertainties that are not sampled yet
    else
      tobesampled=find((in.nature==30).*(~in.sampled));
      if ~isempty(tobesampled)
        % SAMPLECASE=4 if there are no LTI nor TV uncertainties but there
        % are NL uncertainties that are not sampled yet
      end
    end
  end
end

for ii=tobesampled % operate ony on those uncertainties that where identified to be sampled
  in.sampled(ii)=1;
  switch in.constr{ii}(1:3)
    case 'pol'
      N=size(in.vtx{ii},3);
      % preallocate output
      tmp_loc=zeros(size(in.vtx{ii},1),size(in.vtx{ii},2),sample_nb);
      for jj=1:sample_nb
        limits=sort(rand(N-1,1),1);
        zeta=[limits;1]-[0;limits];
        zeta=kron(zeta,eye(size(in.vtx{ii},2)));
        tmp_loc(:,:,jj)=reshape(in.vtx{ii},size(in.vtx{ii},1),[],1)*zeta;
      end
      in.usample{ii}=tmp_loc;
    case 'par'
      N=size(in.vtx{ii},3)-1;
      tmp_loc=zeros(size(in.vtx{ii},1),size(in.vtx{ii},2),sample_nb);
      zeta(1,N+1)=1;
      for jj=1:sample_nb % can probably be made faster avoiding doing the loop
        zeta(1,1:N)=rand(1,N);
        zeta=kron(zeta,eye(size(in.vtx{ii},2)));
        tmp_loc(:,:,jj)=reshape(in.vtx{ii},size(in.vtx{ii},1),[],1)*zeta';
      end
      in.usample{ii}=tmp_loc;
    case 'int'
      vtxsize=[size(in.vtx{ii},1),size(in.vtx{ii},2)];
      tmp_loc=zeros(size(in.vtx{ii},1),size(in.vtx{ii},2),sample_nb);
      vtx1=in.vtx{ii}(:,:,1);
      vtx2=in.vtx{ii}(:,:,2);
      for jj=1:sample_nb % can probably be made faster avoiding doing the loop
        zeta=rand(vtxsize);
        tmp_loc(:,:,jj)=vtx1.*zeta+vtx2.*(ones(vtxsize)-zeta);
      end
      in.usample{ii}=tmp_loc;
    case 'pro'
      data.transpose = in.transpose; 
      data.size = [size(in.rows{ii},1),size(in.cols{ii},1)];
      data.names{1} = in.names{ii};
      data.constr{1} = in.constr{ii};
      data.complex = in.complex(ii);
      data.rows{1}=(1:data.size(1))';
      data.cols{1}=(1:data.size(2))';
      data.X{1}=[];
      data.Y{1}=[];
      data.Z{1}=[];
      data.vtx{1}={};
      data.ubase{1}=in.ubase{ii};
      uloc=uncertainty('existing',data,in.uindex(ii));
      in.usample{ii}=ubasesample(uloc,sample_nb);
      in.usample{ii}=reshape(in.usample{ii},data.size(1),data.size(2),[]);
      in.sampled(ii)=1;
    otherwise
      in.usample{ii}=usample(melli(in.X{ii},in.Y{ii},in.Z{ii},~in.complex(ii)),sample_nb);
  end
end
if all(in.sampled)
  out=[];
  for ii=1:size(in.struc,2)
    out=blkdiag3d(out,in.usample{in.struc(2,ii)});
  end
else
  out=in;
end







