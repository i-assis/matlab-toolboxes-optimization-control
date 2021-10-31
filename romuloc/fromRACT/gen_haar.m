function  U=gen_haar(n,Nsamples,CPLX);
%
% function  U=gen_haar(n,Nsamples,CPLX);
%
% generates a Nsamples n-dimensional unitary (orthogonal) matrices
% distribuited according to the Haar distribution.
% U is a 3-dim array: size(U,3)=Nsamples;
%
% CPLX=1 : (complex) unitary matrix
% CPLX=0 : (real) orthogonal matrix
%

% $Id: gen_haar.m,v 1.1 2013/12/04 14:56:36 peaucell Exp $

if ~exist('CPLX'), CPLX=1; end;
if ~exist('Nsamples'), Nsamples=1; end;
U=zeros(n,n,Nsamples);
% complex case

if CPLX==1
   for ii=1:Nsamples
      X=(randn(n)+j*randn(n));
      [Q,R]=qr(X);
      phi=diag(angle(diag(R)));
      U(:,:,ii)=Q*expm(j*phi);
   end;
else
      
% real case
	for ii=1:Nsamples   
   	X=randn(n);
   	[Q,R]=qr(X);
   	U(:,:,ii)=Q*diag(sign(diag(R)));
   end;
end;
U=squeeze(U);
