function delta = udiss(varargin)
% UDISS - Creates a {X,Y,Z}-dissipative uncertainty
%
%  delta = udiss(X,Y,Z)
%     
%  The obtained uncertainty is constrained by the 
%  quadratic matrix inequality s.t. 
%     [ I delta' ][ X  Y ][   I   ]
%                 [ Y' Z ][ delta ] <= 0
%
%  delta = udiss(el)
% 
%  Alternative definition where <el> is a MELLI object
%
%  udiss(el,name)
%
%  Allows to add a tag where <name> is a string.
%
%  udiss(el,nom_val)
%
%  Allows to specify nominal value where <nom_val> is rows x cols matrix.
%  Default <nom_val=center(el)>.
%
%  udiss(el,'complex')
%
%  Specifies that uncertainty is complex valued.
%  Default 'real' is assumed.
%
%  udiss(el,'uniform')
%
%  Forces a uniform probabilistic distribution
%  in that case properties are expected probabilistically.
%  Such distributions apply only to bounded sets (Z>0).
%  If not enforced, uncertainty is 'deterministic'
%  i.e. properties should be guaranteed whatever value in the set.
%
%  udiss(el,'tv')
%  or udiss(el,'nl')
%
%  Indicates time-varying or non-linear nature of the operator.
%  The constraint is then an IQC on input/outputs signals of the operator.
%  If not enforced, uncertainty is 'lti'.
%
%  All options can be combined as in the following
%  el = melli(-eye(2),zeros(2,1), 1)
%  unc = udiss(el, [1 0], 'a name', 'uniform', 'complex', 'tv')
%
% SEE ALSO unb, upos, uinter, upoly, uparal

%  X must be negative semi-definite, X<=0 (include delta=0)
%%% removed specification on 22-jan-2012 I do not rmember why was it needed 

%   This file is part of RoMulOC
%   Last Update 24-Oct-2013
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

data=struct;
X=[];Y=[];Z=[];eli=[];
nominal=[];

for ii=1:length(varargin)
  if isnumeric(varargin{ii})
    if isempty(X)
      X=varargin{ii};
    elseif isempty(Y)
      Y=varargin{ii};
    elseif isempty(Z)
      Z=varargin{ii};
    elseif isempty(nominal)
      nominal=varargin{ii};
    end
  elseif isa(varargin{ii},'melli')
    if isempty(eli) && isempty(X)
      eli=varargin{ii};
      X=eli.X;Y=eli.Y;Z=eli.Z;
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
%       case 'gaussian'
%         if ~isfield(data,'distribution')
%           data.distribution=3;
%         end
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
if isempty(eli)
  if any([isempty(X),isempty(Y),isempty(Z)])
    error('Not enought input arguments');
  else
    eli=melli(X,Y,Z);
  end
end
data.size=[size(eli.Z,1),size(eli.X,1)];
data.constr{1}=sprintf('{X,Y,Z}-dissipative');
data.constrcode(1)=20;
if ~isfield(data,'complex')
  data.complex=0;
end
if ~isfield(data,'distribution')
  data.distribution=1;
end
if ~isfield(data,'nature')
  data.nature=10;
end
data.rows{1}=(1:size(eli.Z,1))';
data.cols{1}=(1:size(eli.X,1))';
data.X{1}=eli.X;
data.Y{1}=eli.Y;
data.Z{1}=eli.Z;
if isempty(nominal)
  data.nominal{1}=center(eli);
elseif isin(eli,nominal)
  data.nominal{1}=nominal;
else
  error('Specified <nom_val> is not in the set');
end
data.usample={[]};
data.sampled=0;
delta=uncertainty('new',data);

  
