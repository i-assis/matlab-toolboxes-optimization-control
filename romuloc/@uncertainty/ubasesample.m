function Samples = ubasesample(UVar, nSamples)
% Internal use only

%   This file is part of RoMulOC
%   Last Update 7-Mar-2013
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

% File replaces RACT toolbox <ubase/ubasesample>

% check number of samples
if nargin == 1
  nSamples = 1; 
elseif isempty('nSamples')
  nSamples = 1;
elseif nSamples < 0
  nSamples = 0;
end

UVar=UVar.ubase{1};

% if nSamples is equal to zero, return nominal (or mean value)
% ?AT? math expectation should be return?
if nSamples == 0
  switch UVar.DistrType
    case {'real_scalar_gaussian', 'real_vector_gaussian'}
      Samples = UVar.Params.mean;
    case {'real_scalar_uniform', 'complex_scalar_uniform', 'real_vector_uniform', 'complex_vector_uniform', 'real_matrix_uniform','complex_matrix_uniform','real_matrix_uniform_elem'}
      Samples = UVar.Params.nominal;
    case 'real_stable_discrete_poly_uniform'
      Samples = [1; zeros(UVar.Params.degree, 1)];
    otherwise
      %warning('RACT:ubasesample:UnknownDistribution', ['Unknown UBASE distribution: ' UVar.DistrType]);
      warning(['Unknown UBASE distribution: ' UVar.DistrType]);
      Samples = 0;
  end
  return;
end

% sampling: call appropriate function, depends of distribution
switch UVar.DistrType
  % 1. scalar part
  % return column vector of nSamples elements
  case 'real_scalar_uniform'
    Samples = UVar.Params.nominal + UVar.Params.range*(2*rand(nSamples,1) - 1);
  case 'complex_scalar_uniform'
    tmp = randn(nSamples, 2)*[1; j]; % column of complex variables
    Samples = UVar.Params.nominal + sqrt(rand(nSamples,1)).*UVar.Params.radius.*tmp./abs(tmp);
  case 'real_scalar_gaussian'
    Samples = UVar.Params.mean + UVar.Params.std*randn(nSamples, 1);

  % 2. vector part
  % return matrix [n x nSamples] where n is length of uncertain vector
  % using UNIF_GEN private routines
  case 'real_vector_uniform'
    Samples = repmat(UVar.Params.nominal, 1, nSamples) + UVar.Params.rho*gen_vec(UVar.Params.dim, UVar.Params.p_norm, nSamples, 0);
  case 'complex_vector_uniform'
    Samples = repmat(UVar.Params.nominal, 1, nSamples) + UVar.Params.rho*gen_vec(UVar.Params.dim, UVar.Params.p_norm, nSamples, 1);

  case 'real_vector_gaussian'
    %warning('RACT:ubasesample:NotImplemented', 'Sorry, real gaussian vector generator is not implemented yet. \n Using mean value.');
%    warning('Sorry, real gaussian vector generator is not implemented yet. \n Using mean value.');
%    Samples = repmat(UVar.Params.mean, 1, nSamples);
    Samples = repmat(UVar.Params.mean, 1, nSamples) + UVar.Params.cx*randn(UVar.Params.dim, nSamples, 1);

  % SPECIAL - stable discrete monic polynomial is treated as vector of
  % its coefficients
  case 'real_stable_discrete_poly_uniform'
    Samples = gen_dispoly(UVar.Params.degree, nSamples);
    
%%  case 'real_vector_uniform'
%     n = UVar.Params.dim;
%     switch UVar.Params.p_norm
%       case 1
%         tmp = -log(rand(n+1,1));
%         Samples = UVar.Params.nominal + UVar.Params.rho/sum(tmp)*tmp(1:n,1).*sign(rand(n,1)-0.5);
%       case 2
%         tmp = randn(n,1);
%         Samples = UVar.Params.nominal + UVar.Params.rho*(rand)^(1/n)*tmp/norm(tmp,'fro');
%       case Inf
%         Samples = UVar.Params.nominal + UVar.Params.rho*2*(rand(n,1)-0.5);
%     end
%     
%   %case 'complex_vector_uniform'
%     n = UVar.Params.dim;
%     switch UVar.Params.p_norm
%       case 1
% 
%  %       tmp = -log(rand(n+1,));
%  %       Samples = UVar.Params.nominal + UVar.Params.rho/sum(tmp)*tmp(1, 1:n).*sign(rand(1,n)-0.5);
%       case 2
%  %       tmp = randn(1,n);
%  %       Samples = UVar.Params.nominal + UVar.Params.rho*(rand)^(1/n)*tmp/norm(tmp,'fro');
%       case Inf
%  %       Samples = UVar.Params.nominal + UVar.Params.rho*2*(rand(1,n)-0.5);
%%     end

  % 3. matrix part
  % return array [n x m x nSamples] where n and m are dimensions of uncertain matrix
  % using UNIF_GEN private routines again
  case 'real_matrix_uniform'
    Samples = repmat(UVar.Params.nominal, [1, 1, nSamples]) + UVar.Params.rho*gen_mat(UVar.Params.rows, UVar.Params.cols, UVar.Params.p_norm, nSamples, 0);
  case 'complex_matrix_uniform'
    Samples = repmat(UVar.Params.nominal, [1, 1, nSamples]) + UVar.Params.rho*gen_mat(UVar.Params.rows, UVar.Params.cols, UVar.Params.p_norm, nSamples, 1);
  case 'real_matrix_uniform_elem'
    Samples = repmat(UVar.Params.nominal, [1, 1, nSamples]) + UVar.Params.rho*repmat(UVar.Params.range, [1, 1, nSamples]).*(2*rand(UVar.Params.rows, UVar.Params.cols, nSamples) - 1);

  % return vector of empty "samples"
% TODO exception or error should be thrown? ?AT?
  otherwise
%    warning('RACT:ubasesample:UnknownDistribution', ['Unknown UBASE distribution: ' UVar.DistrType ', suppose scalar.']);
    warning(['Unknown UBASE distribution: ' UVar.DistrType ', suppose scalar.']);
    Samples = zeros(nSamples, 0);
end