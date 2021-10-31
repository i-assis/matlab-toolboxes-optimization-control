function CorUV = validateubase(UV)
% Internal use only

%   This file is part of RoMulOC
%   Last Update 7-Mar-2013
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

% File replaces RACT toolbox <ubase/validate>


if ~isa(UV.DistrType, 'char'); error('DistrType field must be string value.'); end;
CorUV.DistrType = UV.DistrType;

if ~isa(UV.Name, 'char'); error('Name field must be string value.'); end;
CorUV.Name = UV.Name;

% impossible to catch !?AT?! because of direct call from ubase where Params defined
if ~isfield(UV, 'Params'); error('Params field doesn''t exist.'); end;

switch UV.DistrType
  case 'real_scalar_uniform'
    [bfn, CorUV.Params] = copyfields(UV.Params, 'nominal', 'range');
    if bfn ~= 0;  error(['Parameter ''' bfn ''' doesn''t exist.']); end;
    if UV.Params.range < 0; 
%      warning('Negative range! Just keep in mind.');  see also 'abs' in 'display'
      % CorUV.Params.range = 0; % compatability with X = X0 + x_perc*(rand - 0.5)*X0 notation, where X0 < 0
    end;

  case 'complex_scalar_uniform'
    [bfn, CorUV.Params] = copyfields(UV.Params, 'nominal', 'radius');
    if bfn ~= 0;  error(['Parameter ''' bfn ''' doesn''t exist.']); end;
    if UV.Params.radius < 0; 
      %warning('RACT:validate:NegativeRadius', 'Negative radius: setting to 0.'); 
      warning('Negative radius: setting to 0.'); 
      CorUV.Params.radius = 0;
    end;

  case 'real_scalar_gaussian'
    [bfn, CorUV.Params] = copyfields(UV.Params, 'mean', 'std');
    if bfn ~= 0;  error(['Parameter ''' bfn ''' doesn''t exist.']); end;
    if UV.Params.std < 0; 
      %warning('RACT:validate:NegativeStd', 'Negative std: setting to 0.'); 
      warning('Negative std: setting to 0.'); 
      CorUV.Params.std = 0;
    end;

  case {'real_vector_uniform', 'complex_vector_uniform'}
    [bfn, CorUV.Params] = copyfields(UV.Params, 'nominal', 'p_norm', 'rho');
    if bfn ~= 0;  error(['Parameter ''' bfn ''' doesn''t exist.']); end;
    if UV.Params.rho < 0; 
      %warning('RACT:validate:NegativeRho', 'Negative rho: setting to 1.'); 
      warning('Negative rho: setting to 1.'); 
      CorUV.Params.rho = 1;
    end;
    if UV.Params.p_norm < 1; 
      %warning('RACT:validate:BadNorm', 'p_norm is less than 1: setting to Inf.'); 
      warning('p_norm is less than 1: setting to Inf.'); 
      CorUV.Params.p_norm = Inf;
    end;
%   not used in generation now TODO?
%     if isinf(CorUV.Params.p_norm) % define range for interval norm (nominal +- range)
%       if ~isfield(UV.Params, 'range'); error('P_norm = Inf, but range vector is undefined.'); end;
%       if size(UV.Params.range) ~= size(UV.Params.nominal) 
%         error('RACT:validate:InputSize', 'Range vector has another dimension, than nominal one.'); 
%       end;
%       CorUV.Params.range = UV.Params.range;
%       if any(UV.Params.range < 0);
%         warning('RACT:validate:NegativeRange', 'Range vector have negative elements: setting to 0.'); 
%         CorUV.Params.range(UV.Params.range < 0) = 0;
%       end;
%     end
    CorUV.Params.dim = size(CorUV.Params.nominal, 1); % column vector notation

  case 'real_stable_discrete_poly_uniform'
    [bfn, CorUV.Params] = copyfields(UV.Params, 'degree');
    if bfn ~= 0;  error(['Parameter ''' bfn ''' doesn''t exist.']); end;
    CorUV.Params.dim = UV.Params.degree + 1;

  case 'real_vector_gaussian'
    [bfn, CorUV.Params] = copyfields(UV.Params, 'mean', 'covar', 'rho');
    if bfn ~= 0;  error(['Parameter ''' bfn ''' doesn''t exist.']); end;
    if min(real(eig(full(CorUV.Params.covar)))) < 0
       error(['RACT:validate:InputType', 'Covariance matrix should be positive semidefinite.']); 
    end
    CorUV.Params = setfield(CorUV.Params, 'cx', sqrtm(CorUV.Params.covar)); % set an auxilar internal matrix 'cx'
    %warning('RACT:validate:NotImplemented', 'Sorry, real vector gaussian distribution is not implemented yet.');
%    warning('Sorry, real vector gaussian distribution is not implemented yet.');
    CorUV.Params.dim = size(UV.Params.mean, 1);

  case {'real_matrix_uniform', 'complex_matrix_uniform'}
    [bfn, CorUV.Params] = copyfields(UV.Params, 'nominal', 'p_norm', 'rho');
    if bfn ~= 0;  error(['Parameter ''' bfn ''' doesn''t exist.']); end;
    if UV.Params.rho < 0; 
      %warning('RACT:validate:NegativeRho', 'Negative rho: setting to 1.'); 
      warning('Negative rho: setting to 1.'); 
      CorUV.Params.rho = 1;
    end;
    if UV.Params.p_norm < 1; 
      %warning('RACT:validate:BadNorm', 'p_norm is less than 1: setting to Inf.'); 
      warning('p_norm is less than 1: setting to Inf.'); 
      CorUV.Params.p_norm = Inf;
    end;
    [CorUV.Params.rows, CorUV.Params.cols] = size(CorUV.Params.nominal);

  case 'real_matrix_uniform_elem'
    [bfn, CorUV.Params] = copyfields(UV.Params, 'nominal', 'rho');
    if bfn ~= 0; 
      error(['RACT:validate:WrongParamName', ['Parameter ''' bfn ''' doesn''t exist.']]) 
    end;
    if UV.Params.rho < 0; 
      %warning('RACT:validate:NegativeRho', 'Negative rho: setting to 1.'); 
      warning('Negative rho: setting to 1.'); 
      CorUV.Params.rho = 1;
    end;
     if ~isfield(UV.Params, 'range'); error('P_norm = Inf, but range matrix is undefined.'); end;
     if size(UV.Params.range) ~= size(UV.Params.nominal) 
       error(['RACT:validate:InputSize', 'Range matrix has different dimensions, than nominal one.']); 
     end;
     CorUV.Params.range = UV.Params.range;
     if any(UV.Params.range < 0);
       %warning('RACT:validate:NegativeRange', 'Range vector have negative elements: setting to 0.'); 
       warning('Range vector have negative elements: setting to 0.'); 
       CorUV.Params.range(UV.Params.range < 0) = 0;
     end;
    [CorUV.Params.rows, CorUV.Params.cols] = size(CorUV.Params.nominal);

  otherwise
    error(['RACT:validate:UnknownDistribution', ['Unknown value for DistrType parameter: ' UV.DistrType]]);
end
%default , uncertainties are scalar
if ~isfield(CorUV.Params,'rows')
  CorUV.Params.rows=1;
end
if ~isfield(CorUV.Params,'cols')
  CorUV.Params.cols=1;
end

end

% auxilary function to check if all the fields listed in 'varargin' exist
% and copy them to destination (new, corrected Param structure for uncertain
% variable object)
function [bad_field_name, Params] = copyfields(UV, varargin)
bad_field_name = 0;
Params = [];
for k=1:nargin-1
  if ~isfield(UV, varargin{k})
    bad_field_name = varargin{k};
    break;
  else
    Params = setfield(Params, varargin{k}, getfield(UV, varargin{k}));
%    Params.(varargin{k}) = UV.(varargin{k}); % dynamic field - Matlab 7 only?
  end
end
% auxilary function to check if all the fields listed in 'varargin' exist - obsolete
% in UV structure. If not, return name of field
%function bad_field_name = checkfields(UV, varargin)
%bad_field_name = 0;
%for k=2:nargin
%  if ~isfield(UV, varargin{k})
%    bad_field_name = varargin{k};
%    break;
%  end
%end
end
