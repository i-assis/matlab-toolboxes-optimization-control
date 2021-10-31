function str = displayubase(in)
% Internal use only

%   This file is part of RoMulOC
%   Last Update 7-Mar-2013
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

% File replaces RACT toolbox <ubase/validate>


str = ['proba. '];
switch in.DistrType
  case {'real_scalar_uniform'
      'complex_scalar_uniform'
      'real_vector_uniform'
      'complex_vector_uniform'
      'real_matrix_uniform'
      'complex_matrix_uniform'}
    str = [str 'uniform distrib.'];
  case {'real_scalar_gaussian'
      'real_vector_gaussian'}
    str = [str 'gaussian distrib.'];
  case 'real_stable_discrete_poly_uniform'
    str = [str 'monic stable discrete polynomail of degree ' num2str(in.Params.degree) '.'];
  case 'real_matrix_uniform_elem'
    str = [str 'elements uniform distrib.'];
  otherwise
    error(['Unknown value for DistrType parameter: ' in.DistrType]);
end
