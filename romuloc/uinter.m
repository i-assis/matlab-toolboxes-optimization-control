function out = uinter(varargin)
% UINTER - Create interval uncertain operator or model
%
%# Interval uncertainty operator
%
%  delta = uinter(valmin,valmax) or delta = uinter(vals)
%
%  <valmin> and <valmax> are arrays of same size.
%  or
%  <vals> is a 3D array such that
%  valmin=vals(:,:,1) and valmax=vals(:,:,2).
%  Output <delta> is uncertain inside the interval.
%  If (i,j) elements of <valmin> and <valmax> are identical,
%  the corresponding element in <delta> is known.
%  In the other case the parameter in uncertain and
%  belongs to the interval.
%
%  uinter(vals,name)
%
%  Allows to add a tag where <name> is a string.
%
%  uinter(vals,nom_val)
%
%  Allows to specify nominal value <nom_val>.
%  Default <nom_val=0.5*(valmin+valmax)>.
%
%  uinter(vals,'uniform')
%
%  Forces a uniform probabilistic distribution,
%  in that case, properties are expected probabilistically.
%  If not enforced, uncertainty is 'deterministic'
%  i.e. properties should be guaranteed whatever value in the set.
%
%  All options can be combined as in the following
%  unc = uinter(-eye(2),eye(2), [1 0;0 -1], 'a name', 'uniform')
%
% SEE ALSO udiss, unb, upos, upoly, uparal
%
%# Affine interval uncertain models:
%
%  usys = uinter(sysmin,sysmax) or usys = uinter(sys)
%
%  <sysmin> and <sysmax> are SSMODEL objects of same dimensions.
%  or
%  <sys> is a array of two SSMODEL.
%  Output <usys> is a USSMODEL, uncerain inside the interval
%  (same definition as above but applied to all system matrices).
%
% SEE ALSO ussmodel, upoly, uparal

%   This file is part of RoMulOC
%   Last Update 24-Oct-2013
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

%%% Attention! For interval ussmodels would be preferable to transfert this
%%% part of the function to the directory @ssmodel.

data=struct;
valmin=[];valmax=[];
nominal=[];

for ii=1:nargin
  if isnumeric(varargin{ii})
    switch size(varargin{ii},3)
      case 1
        if isempty(valmin)
          valmin=varargin{ii};
        elseif isempty(valmax)
          valmax=varargin{ii};
        elseif isempty(nominal)
          nominal=varargin{ii};
        else
          warning(sprintf('%i-th argument of UINTER ignored',ii));
        end
      case 2
        if isempty(valmin)
          valmin=varargin{ii};
          valmax=valmin(:,:,2);
          valmin=valmin(:,:,1);
        else
          warning(sprintf('%i-th argument of UINTER ignored',ii));
        end
      otherwise
        warning(sprintf('%i-th argument of UINTER ignored',ii));
    end
  elseif isa(varargin{ii},'ssmodel')
    systmp=varargin{ii};
    switch systmp.nb
      case 1
        if isempty(valmin)
          valmin=systmp;
        elseif isempty(valmax)
          valmax=systmp;
        else
          warning(sprintf('%i-th argument of UINTER ignored',ii));
        end
      case 2
        if isempty(valmin)
          valmin=systmp(1);
          valmax=systmp(2);
        else
          warning(sprintf('%i-th argument of UINTER ignored',ii));
        end
      otherwise
        warning(sprintf('%i-th argument of UINTER ignored',ii));
    end
  elseif ischar(varargin{ii})
    switch varargin{ii}
      case 'uniform'
        if ~isfield(data,'distribution')
          data.distribution=2;
        end
      case 'deterministic'
        if ~isfield(data,'distribution')
          data.distribution=1;
        end
      otherwise
        if isa(valmin,'ssmodel')
          if ~isfield(data,'name')
            valmin.name=varargin{ii};
          end
        else
          if ~isfield(data,'names')
            data.names{1}=varargin{ii};
          else
            warning(sprintf('%i-th argument of UINTER ignored',ii));
          end
        end
    end
  end
end

if isempty(valmin) | isempty(valmax)
  error('Not enougth input args. defined');
end

if isnumeric(valmin) 
  % Defining interval uncertainty
    [rowsm,colsm]=size(valmin);
  if ~all([rowsm,colsm])
    out=uncertainty;
  else
    [rowsM,colsM]=size(valmax);
    if any([rowsm,colsm]-[rowsM,colsM])
      error('1st and 2nd input arguments must have same dimensions');
    end
    [ipar,jpar]=find(valmin-valmax);
    nbparam=length(ipar);
    data.size=[rowsm,colsm];
    data.constr{1}=sprintf('interval %i param',nbparam);
    data.constrcode(1)=12;
    if isreal(valmin) && isreal(valmax)
      data.complex=0;
    else
      data.complex=1;
    end
    if ~isfield(data,'distribution')
      data.distribution=1;
    end
    if ~isfield(data,'nature')
      data.nature=10;
    end
    data.rows{1}=(1:rowsm)';
    data.cols{1}=(1:colsm)';
    vtx(:,:,1)=valmin;
    vtx(:,:,2)=valmax;
    data.vtx{1} = vtx;
    if isempty(nominal)
      data.nominal{1}=0.5*(valmin+valmax);
    elseif all(all(min(valmin,valmax)<=nominal)) && all(all(max(valmin,valmax)>=nominal))
      data.nominal{1}=nominal;
    else
      error('Specified <nom_val> is not in the set');
    end
    data.usample={[]};
    data.sampled=0;
    out=uncertainty('new',data);
  end
elseif isa(valmin,'ssmodel')
  %defining interval ussmodel
  if ~isa(valmax,'ssmodel')
    error(['For interval USSMODEL : both first input arg. must be SSMODEL']);
  end
  %    if valmin.md | valmax.pd
  %      error(['interval USSMODEL is forbiden for SSMODELs with wd/zd' ...
  %	     ' exogenous signals']);
  %    end
  if any(size(valmin,'all')-size(valmax,'all'))
    error('For interval USSMODEL : both first input arg. must have all identical dimensions');
  end
  [ipar,jpar]=find(valmin.allmatrices-valmax.allmatrices);
  nbparam=length(ipar);
  type = sprintf('interval %i param',nbparam);
  valmin(2)=valmax;
  data = valmin;
  delta = uncertainty;
  out = ussmodel(data,delta,type,'OK');
else
  error('1st input argument must be either a matrix or a ssmodel');
end
