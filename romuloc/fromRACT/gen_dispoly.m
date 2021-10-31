function samples = gen_dispoly(n, N);
% GEN_DISPOLY generates discrete monic polynomials of degree n uniformly

% $Id: gen_dispoly.m,v 1.1 2013/12/04 14:56:36 peaucell Exp $

%(c) copyright Lenka-penka :))


% verification
if nargin < 2
  error(['RACT:gen_dispoly:InputSize', 'Not enough arguments.']);
end

if n < 1
  error(['RACT:gen_dispoly:InputSize', 'Degree should be greater than 1.']);
end

a = zeros(n,n);

% preparation of pdf's and cdf's
pdf=zeros(n,n);
cdf=zeros(n+1,n+1);
pdf(1,:) = [zeros(1, n-1), 1];
for deg=2:n
   pre_pdf=conv(pdf(deg-1,:),[1 (-1)^deg]);
   pdf(deg,:)=pre_pdf(:,2:size(pre_pdf,2));
   %use_pdf=pdf(deg, (n+1-deg):size(pdf,2));
   cdf(deg,:)=polyint(pdf(deg,:));
   cdf(deg,size(cdf,2))=cdf(deg,size(cdf,2))-polyval(cdf(deg,:), -1);
       if polyval(cdf(deg,:),-1) > polyval(cdf(deg,:), 1)
           cdf(deg,:)=(-1).*cdf(deg,:);
       end 
end

% preallocate space
samples = zeros(n+1, N);
% creating samples
for countN=1:N
    a(1,1)=-1+2*rand;
    for deg=2:n
      % drop a point in a cdf value set and create an equation to find x
       equat=cdf(deg,:);
       equat(size(equat,2))=equat(size(equat,2))-polyval(cdf(deg,:),1)*rand;
       r=roots(equat);
       a(deg,deg)=real(r((abs(r)<1)&(abs(imag(r))<1e-8)));
    
       % computing all recent a(i) for this deg
       for i=1:(deg-1)
           a(i,deg)=a(i,deg-1)+a(deg,deg)*a(deg-i,deg-1);
       end
    end
    samples(:,countN)=[1; a(:,n)];
 %  real_root=[real_root, sum(imag(roots([1; a(:,n)].'))==0)];
 %  plot(real(roots(sample(countN,:))),imag(roots(sample(countN,:))),'.b');
 %  plot(a(1,2),a(2,2),'.b');
%   plot3(a(3,3),a(1,3),a(2,3),'.k');
end
