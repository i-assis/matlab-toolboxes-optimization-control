function Dout = diag(varargin)
% DIAG - build a diagonal structured uncertainty
%
%  delta = diag(D1,D2,...)
%
%  where Di are uncertainty objects (any type)
%  may be repeated in any order
%
% SEE ALSO udiss, unb, upos, uinter, upoly

%   This file is part of RoMulOC
%   Last Update 25-Oct-2013
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

Dout=uncertainty;

if nargin<1
  help uncertainty/diag
else
  % not to combine transposed and not transposed blocks, the first
  % block is taken as a reference.
  Dout.transpose=varargin{1}.transpose;
end

for ii=1:nargin
  % for each uncertainty
  Din=varargin{ii};
  if Din.transpose~=Dout.transpose
    error('Attempt to combine transposed and not transposed blocks');
  end
  for jj=1:Din.nbb
    % for each independent block of Din
    Din.rows{jj}=Din.rows{jj}+Dout.size(1);
    Din.cols{jj}=Din.cols{jj}+Dout.size(2);
    uindex=Din.uindex(jj);
    if isempty(Dout.struc)
      Doutpos=[];
    else
      Doutpos=find(Dout.struc(1,:)==uindex);
    end;
    if Doutpos
      % if that block allready exists
      uloc=Dout.struc(2,Doutpos(1));
      Dout.rows{uloc}=[Dout.rows{uloc},Din.rows{jj}];
      Dout.cols{uloc}=[Dout.cols{uloc},Din.cols{jj}];
    else
      % it is a new block
      uloc=Dout.nbb+1;
      Dout.nbb=uloc;
      Dout.uindex(uloc)=uindex;
      Dout.names{uloc}=Din.names{jj};
      Dout.constr{uloc}=Din.constr{jj};
      Dout.constrcode(uloc)=Din.constrcode(jj);
      Dout.complex(uloc)=Din.complex(jj);
      Dout.distribution(uloc)=Din.distribution(jj);
      Dout.nature(uloc)=Din.nature(jj);
      Dout.rows{uloc}=Din.rows{jj};
      Dout.cols{uloc}=Din.cols{jj};
      Dout.X{uloc}=Din.X{jj};
      Dout.Y{uloc}=Din.Y{jj};
      Dout.Z{uloc}=Din.Z{jj};
      Dout.vtx{uloc}=Din.vtx{jj};
      Dout.nominal{uloc}=Din.nominal{jj};
      Dout.usample{uloc}=Din.usample{jj};
      Dout.sampled(uloc)=Din.sampled(jj);
      %Dout.ubase{uloc}=Din.ubase{jj};
    end
    Din.struc(2,Din.struc(1,:)==uindex)=uloc;
  end;
  if Din.nbb
    Dout.struc=[Dout.struc,Din.struc];
    Dout.size=Dout.size+Din.size;
  end
end;
