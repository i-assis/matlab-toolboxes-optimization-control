function delta = unb(rows,cols,varargin)
% UNB - Creates a matrix valued norm-bounded uncertainty
%
%  delta = unb(rows,cols,rho)
%  or delta = unb(rows,cols)
%
%  The obatined uncertainty is a ( rows x cols ) operator
%  and is constrained by:
%      ||delta||_2 <= rho
%  Default <rho=1>
%  Default <delta> is real, deterministic, LTI
%
%  unb(rows,cols,rho,name)
%
%  Allows to add a tag where <name> is a string.
%
%  unb(rows,cols,rho,nom_val)
%
%  Allows to specify nominal value where <nom_val> is rows x cols matrix.
%  Default <nom_val=0>.
%
%  unb(rows,cols,rho,'complex')
%
%  Specifies that uncertainty is complex valued.
%  Default 'real' is assumed.
%
%  unb(rows,cols,rho,'uniform')
%
%  Forces a uniform probabilistic distribution
%  in that case properties are expected probabilistically.
%  If not enforced, uncertainty is 'deterministic'
%  i.e. properties should be guaranteed whatever value in the set.
%
%  unb(rows,cols,rho,'tv')
%  or unb(rows,cols,rho,'nl')
%
%  Indicates time-varying or non-linear nature of the operator.
%  The norm ||delta||_2 is the induced L2 norm.
%  If not enforced, uncertainty is 'lti' and ||delta||_2=||delta||_infty.
%
%  All options can be combined as in the following
%  unc = unb(2, 1, 2.3, [1;0], 'a name', 'uniform', 'real', 'lti')
%
% SEE ALSO udiss, upos, uinter, upoly, uparal

%   This file is part of RoMulOC
%   Last Update 24-Oct-2013
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

data=struct;
rho=[];
nominal=[];
if nargin<2
  error('usage is delta = unb(rows,cols,... other arg ...)');
else
  for ii=1:length(varargin)
    if isnumeric(varargin{ii})
      if isempty(rho)
        rho=varargin{ii};
      elseif isempty(nominal)
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
        case 'deterministic'
          if ~isfield(data,'distribution')
            data.distribution=1;
          end
        case 'uniform'
          if ~isfield(data,'distribution')
            data.distribution=2;
          end
%         case 'gaussian'
%           if ~isfield(data,'distribution')
%             data.distribution=3;
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
if isempty(rho)
  rho=1;
end
data.size=[rows,cols];
data.constr{1}=sprintf('norm-bounded by %0.4g',abs(rho));
data.constrcode(1)=21;
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
data.cols{1}=(1:cols)';
data.X{1}=-rho^2*eye(cols);
data.Y{1}=zeros(cols,rows);
data.Z{1}=eye(rows);
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
