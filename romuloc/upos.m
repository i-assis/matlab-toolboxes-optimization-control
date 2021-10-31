function delta = upos(rows,varargin)
% UPOS - Creates a positive-real uncertainty
%
%  delta = upos(rows)
%
%  The obtained uncertainty is a ( rows x rows ) matrix
%  and is constrained by:
%    delta+delta' positive definite
%  Default <delta> is real, deterministic, LTI
%
%  upos(rows,'name')
%
%  Allows to add a tag where <name> is a string.
%
%  upos(rows,'complex')
%
%  Specifies that uncertainty is complex valued.
%  Default 'real' is assumed.
%
%  upos(rows,'tv')
%  or upos(rows,'nl')
%
%  Indicates time-varying or non-linear nature of the operator.
%  The specification then means: delta is passive
%  If not enforced, uncertainty is 'lti'.
%
%  All options can be combined as in the following
%  unc = upos(2, eye(2), 'a name', 'real', 'nl')
%
% SEE ALSO udiss, unb, uinter, upoly, uparal

%   This file is part of RoMulOC
%   Last Update 24-Oct-2013
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

data=struct;
nominal=[];

if nargin<1
  error('usage is delta = upos(rows,... other arg ...)');
else
  for ii=1:length(varargin)
    if isnumeric(varargin{ii})
      if isempty(nominal)
        nominal=varargin{ii};
      end
    elseif ischar(varargin{ii})
      switch lower(varargin{ii})
        case 'complex'
          if ~isfield(data,'complex')
            data.complex=1;
          end
        case 'real'
          if ~isfield(data,'complex')
            data.complex=0;
          end
%         case 'deterministic'
%           if ~isfield(data,'distribution')
%             data.distribution=1;
%           end
%         case 'uniform'
%           if ~isfield(data,'distribution')
%             data.distribution=1;
%           end
%         case 'gaussian'
%           if ~isfield(data,'distribution')
%             data.distribution=1;
%           end
        case 'lti'
          if ~isfield(data,'nature')
            data.nature=10;
          end
        case 'tv'
          if ~isfield(data,'nature')
            data.nature=20;
          end
        case 'nl'
          if ~isfield(data,'nature')
            data.nature=30;
          end
        otherwise
          if ~isfield(data,'names')
            data.names{1}=varargin{ii};
          end
      end
    end
  end
end
data.size=[rows,rows];
data.constr{1}=sprintf('positive-real      ');
data.constrcode(1)=22;
if ~isfield(data,'complex')
  data.complex=0;
end
if ~isfield(data,'distribution')
  data.distribution=1;
end
if ~isfield(data,'nature')
  data.nature=10;
end
data.rows{1}=(1:rows)';
data.cols{1}=(1:rows)';
data.X{1}=zeros(rows,rows);
data.Y{1}=-eye(rows);
data.Z{1}=zeros(rows,rows);
if isempty(nominal)
  data.nominal{1}=zeros(data.size);
elseif isin(melli(data.X{1},data.Y{1},data.Z{1}),nominal)
  data.nominal{1}=nominal;
else
  error('Specified <nom_val> is not in the set');
end
data.usample={[]};
data.sampled=0;
delta=uncertainty('new',data);
