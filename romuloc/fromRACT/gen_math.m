function  A=gen_math(n,m,p,Nsamples,CPLX);
%
% function   A=gen_math(n,m,p,Nsamples,CPLX);
%
% generate Nsamples (n,m) dimensional matrices uniformly distributed 
% in the Hilbert-Schmidt ell_p norm-ball.
% A is a 3-dim matrix such that size(A,3)=Nsamples.	
%
% CPLX=1 : complex matrices
% CPLX=0 : real matrices
%
% Reference:
% G. Calafiore, F. Dabbene, R. Tempo. 
% ``Radial and Uniform Distributions in Vector and Matrix Spaces for 
% Probabilistic Robustness.'' In Recent Advances in Control, (Eds. D. Miller and L. Qiu), 
% Springer-Verlag, New York, 1999.

% $Id: gen_math.m,v 1.1 2013/12/04 14:56:37 peaucell Exp $

if ~exist('CPLX'), CPLX=1; end;
if ~exist('Nsamples'), Nsamples=1; end;
A=zeros(n,m,Nsamples);
for k=1:Nsamples
   X=gen_vec(n*m,p,1,CPLX);
   A(:,:,k)=reshape(X,n,m);
end;


   