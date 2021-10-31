function PlusProjM = plusprojm(M, mineig, maxeig)
%PLUSPROJM projection on restricted cone of real positive definite
%   M is a symmetric matrix 
%   mineig and maxeig define limits in form 
%   mineig*eye(n) <= M_projected <= maxeig*eye(n)
% TODO can be done easier way?... and less error-checking 

% $Id: plusprojm.m,v 1.1 2013/12/04 14:56:37 peaucell Exp $

% default parameters
switch nargin
  case 1 % M
    mineig = 0;
    maxeig = inf;
  case 2 % (M, mineig)
    maxeig = inf;
end

sym_tol = 1e-8; % tolerance for symmetry check, average elementwise
if norm(M - M.', 'fro')/numel(size(M)) > sym_tol
  error(['RACT:plusprojm:NonSymmetic', 'The input matrix is not real symmetric!']);
end

[U, T] = schur(M); % use 'full' for sparse matrices
% there are better algorithm for sparse via eigs(M, xxx, 'la') ?
% addidional (fictive?! = ever-passing, because of previous) test
if norm(T - T.', 'fro')/numel(size(T)) > sym_tol % upper triangle, not diagonal (?!)
  error(['RACT:plusprojm:NonDiagonal', 'Non-diagonal T in Schur decomposition.']);
end

t = diag(T);
t(t < mineig) = mineig;
t(t > maxeig) = maxeig;

PlusProjM = U*diag(t)*U.';