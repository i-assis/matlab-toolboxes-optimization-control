function  A=gen_mat_sym(n,p,Nsamples,CPLX);
%
% function   A=gen_mat_sym(n,p,Nsamples,CPLX);
%
% generates Nsamples (n,m) dimensional matrices uniformly distributed 
% in the l_p-induced norm-ball (p=1,2,Inf).
% A is a 3-dim matrix such that size(A,3)=Nsamples.	
%
% CPLX=1 : complex matrices
% CPLX=0 : real matrices
%
% Reference:
% G. Calafiore, F. Dabbene, R. Tempo. 
% ``Randomized Algorithms for Probabilistic Robustness with Real and Complex 
% Structured Uncertainty." Report N. CENS-1999-02. Submitted for publication.

% $Id: gen_mat_sym.m,v 1.1 2013/12/04 14:56:37 peaucell Exp $

m=n;
if ~exist('CPLX'), CPLX=1; end;
if ~exist('p'), p=2; end
if ~exist('Nsamples'), Nsamples=1; end;
A=zeros(n,m,Nsamples);
switch p
   % 2-induced (max-singular-value) norm
case 2,
   % calls gen_sig to generate the singular values
   [SGM]=gen_sig(n,m,Nsamples,CPLX);
   % calls gen_haar to generate random unitary matrices
   U=gen_haar(n,Nsamples,CPLX);
   sgn=diag(sign(randn(n,1)));
   % builds matrix A from SVD factors
   for k=1:Nsamples
      A(:,:,k)=U(:,:,k)*sgn*diag(SGM(k,:))*U(:,:,k)';
   end;
end;
 
   