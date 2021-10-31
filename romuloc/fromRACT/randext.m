function aSample = randext(varargin)
% randext - extended simple random generator (returns only one sample)
% Uses the same parameters as UBASE constuctor, and 'name' field can be
% omitted.
%
%  Example:
%
%  % a 3-d complex vector, uniformly distibuted in p-inf norm:
%  x = randext('complex_vector_uniform', 'nominal', [1, j, 1+j], ...
%              'range', [0.1, 0.5, 0.2], 'p_norm', inf, 'rho', 1)
%
%  % get coefficients of a monic discrete stable polynomial of degree 10
%  x = randext('real_stable_discrete_poly_uniform', 'degree', 10)
%
%  SEE ALSO: UBASE

% $Id: randext.m,v 1.1 2013/12/04 14:56:37 peaucell Exp $

% name parameter used
if mod(nargin, 2) == 0
  A = ubase('temporary-special',varargin{2:end});
else
  % otherwise function can be used without
  A = ubase('temporary-special', varargin{:});
end
aSample = ubasesample(A, 1);
