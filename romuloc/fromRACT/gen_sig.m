function [SGM]=gen_sig(n,m,Nsamples,CPLX);
%
% [SGM]=gen_sig(n,m,Nsamples,CPLX);
% generates `Nsamples' rows containing the singular values 
% of a real or complex matrix of dimensions (n, m), m>=n, 
% uniformly distributed in B(1). 
%
% CPLX: flag set to 1 for the complex case, 0 for the real. Default CPLX=1.
% SGM is a matrix (Nsamples, n).
% 
% 
% Uses NAG toolbox, see line 91
%
% Reference:
% G. Calafiore, F. Dabbene, R. Tempo. 
% ``Randomized Algorithms for Probabilistic Robustness with Real and Complex 
% Structured Uncertainty." Report N. CENS-1999-02. Submitted for publication.
%

% $Id: gen_sig.m,v 1.1 2013/12/04 14:56:37 peaucell Exp $

%if exist('c05adf') ~= 2, 
%   error('NAG Toolbox not found. Please check file gen_sig.m at line 91, to correct this problem.');
%end;
if ~exist('CPLX'), CPLX=1; end;
if ~exist('Nsamples'), Nsamples=1; end;
SGM=zeros(Nsamples,n);
d=m-n;
global F

									%%%%%%%%%%%%%%%%%%%%%%%
									%    COMPLEX CASE     %
									%%%%%%%%%%%%%%%%%%%%%%%

if CPLX==1
if min(m,n) > 15,
   warning('Problem may be ill conditioned');
end;
% computation of the constant Kx
Kx=1;
for l=0:n-1
  Kx=Kx*GAMMA(m+l+1)/((l+1)*(GAMMA(l+1))^2*GAMMA(l+d+1));
end;

% construction of the matrix M according to (33)
R=zeros(n,n);
for r=1:n
   for jj=r:n
      R(r,jj)=1/(r+jj+d-1);
      R(jj,r)=R(r,jj);
   end;
end;
[T,L]=eig(R); L=diag(abs(L));
A=diag(1./sqrt(L))*T';
M=A'*A;


for k=1:Nsamples
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %      generation of one vector of sigmas           %
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   % Initialization %
   W=M;
   V=[];
   for iter=1:n;
      if iter==1, K=Kx*gamma(n)/det(M); else, K=1/(n-iter+1); end;
      
      % costruction of the polynomial P of coefficients b
      % (b contains the sum of the anti-diagonals of W)
      b=zeros(1,2*n-1);
      for r=1:n
        for jj=r+1:n
          b(2*n-(r+jj-1))=b(2*n-(r+jj-1))+2*W(r,jj);
        end;
        b(2*n-(2*r-1))=b(2*n-(2*r-1))+W(r,r);
      end;
      P=[K*b,zeros(1,d)];
      
      % generate the r.v. x(iter)
      
      % integrate the polynomial P
      ii=length(P):-1:1;     
      F=[P./ii,0];
      F=F-polyval(F,0);
      F=F/polyval(F,1);
      
      % generate a r.v. according to P, using inversion method
      F(length(F))=-rand(1);
%%      x(iter)=c05adf(0,1,1e-12,'fpoly');
      %% if NAG toolbox not available, substitute the previous line with:
       zz=roots(F);
       zzreal=real(zz(find(abs(imag(zz))<1e-10) ) );
       zz01=zzreal(find( zzreal<1 & zzreal>0 ) );
       x(iter)=zz01(1);
      %% Warning: this reduces the efficiency of the code by one order of magnitude.
      sigma(iter)=sqrt(x(iter));
      
      % update for next step
      if iter<n
         X=[1;cumprod(ones(n-1,1)*x(iter))];
         delta=X'*W*X;
         if iter==1, 
            Zinv=1/delta; dZ=delta; 
         else,
            S=Zinv*V'*M*X;
            Zinv=[Zinv+S*S'/delta, -S/delta; -S'/delta, 1/delta];
            dZ=delta*dZ;
         end;
         V=[V X];
         W=M-M*V*Zinv*V'*M;
      end;
   end;
   % save the data
   SGM(k,:)=sigma;
end;

else   

									%%%%%%%%%%%%%%%%%%%%%%%
									%      REAL CASE      %
									%%%%%%%%%%%%%%%%%%%%%%%
if min(m,n)>6
    warning('This can take a LONG time...');
end;
% generate the vector of beta                           
ii=1:n;                           
beta=(m+n)*(n-ii+1) - n*(n+1) + ii.*(ii-1) + (n-ii);
for k=1:Nsamples;
  while 1
     % generate the vector x
     x=rand(1,n).^(1./(1+beta));
     % compute fbar(x) according to (42)
     fbar=prod(x.^beta);
     % compute the vector sigma according to (39)
     sigma=cumprod(x);
     % compute fx(x)
     sigq=sigma.^2;
     fx=prod(sigma.^d).*prod(x.^(n-ii));
     for ind=1:n-1,
        fx=fx*prod(sigq(ind)-sigq(ind+1:n));
     end;    
     if rand(1)*fbar/fx <= 1,  break;   end;
  end;
  SGM(k,:)=sigma;
end;

end;














