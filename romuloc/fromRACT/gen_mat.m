function  A=gen_mat(n,m,p,Nsamples,CPLX);
%
% function   A=gen_mat(n,m,p,Nsamples,CPLX);
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

% $Id: gen_mat.m,v 1.1 2013/12/04 14:56:37 peaucell Exp $

if ~exist('CPLX'), CPLX=1; end;
if ~exist('p'), p=2; end
if ~exist('Nsamples'), Nsamples=1; end;
A=zeros(n,m,Nsamples);
switch p
   % 2-induced (max-singular-value) norm
case 2,
%% !?AT?! begin patch part 1
  if m>=n
%% !?AT?! end patch part 1
   % calls gen_sig to generate the singular values
   [SGM]=gen_sig(n,m,Nsamples,CPLX);
   % calls gen_haar to generate random unitary matrices
   U=gen_haar(n,Nsamples,CPLX);
   V=gen_haar(m,Nsamples,CPLX);
   % builds matrix A from SVD factors
   for k=1:Nsamples
      A(:,:,k)=U(:,:,k)*diag(SGM(k,:))*V(1:n,:,k);
   end;
%% !?AT?! begin patch part 2
  else 
   % calls gen_sig to generate the singular values
   [SGM]=gen_sig(m,n,Nsamples,CPLX);
   % calls gen_haar to generate random unitary matrices
   U=gen_haar(m,Nsamples,CPLX);
   V=gen_haar(n,Nsamples,CPLX);
   % builds matrix A from SVD factors
   for k=1:Nsamples
      A(:,:,k)=(U(:,:,k)*diag(SGM(k,:))*V(1:m,:,k)).';
   end;
  end
%% !?AT?! end patch part 2
   % 1-induced norm
case 1,
   for k=1:Nsamples
      A(:,:,k)=gen_vec(n,1,m,CPLX);
   end;
   %infty-induced norm
case inf
   for k=1:Nsamples
      A(:,:,k)=gen_vec(m,1,n,CPLX)';
   end;
end;
 
   