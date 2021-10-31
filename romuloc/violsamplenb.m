function nb_sample=violsamplenb(epsilon,delta,nbvar,nbrem);
% VIOLSAMPLENB - Number of samples for scenario with violated constraints design approach
%
% nb = violsamplenb( epsilon, delta, nbvar, nbrem)
%
% The function is used for randomized scenario with violated cosntraints design methods (SEE ctrpb)
%
% <nb> is the number of samples to be drawn in order to get an
% <epsilon>-close estimate of reliability of a worst case performance
% with violation probability of <delta> in the case that the design problem
% involves <nbvar> decision variables.
%
% In other words, if <wc_est> is the worst case estimate of a performance
% computed on <nb> independent and identically distributed samples 
% and <P> is the probability of an other sample to violate <wc_est>, then:
% Prob{ P < epsilon } < delta
% 
% SEE ALSO ctrpb, chernoff, wcsamplenb, scensamplenb, ctrpb/solvesdp

%   This file is part of RoMulOC
%   Last Update 13-Oct-2015
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France 

%% compute the bound numerically
  Nta=ceil(2/epsilon*(log(1/delta)+2*(nbvar+nbrem)));
  N=fminbnd(@(Ni) bound(Ni,nbvar,nbrem,epsilon,delta),.5*Nta,Nta);
  nb_sample=ceil(N);

%% function to solve the numeric problem
 function F=bound(Ni,nbvar,nbrem,epsilon,delta)

F=nchoosek(nbvar+nbrem,nbrem)*binocdf(nbvar+nbrem,Ni,epsilon)-delta;

function y=binocdf(x,n,p);

% BINOCDF binomial cumulative distribution function
%
% Y=BINOCDF(X,N,P) returns the binomial cumulative distribution
% function with parameters N and P at the values in X.
%
% See also BINOPDF and STATS (Matlab statistics toolbox)

% compute the cumulative probability for all values up to the maximum
c = cumsum(binopdf(0:max(x(:)),n,p));
y = c(x+1);

% fix rounding errors
y(y<0) = 0;
y(y>1) = 1;

function y = binopdf(x,n,p)

% BINOPDF binomial probability density function
%
% Y = BINOPDF(X,N,P) returns the binomial probability density
% function with parameters N and P at the values in X.
%
% See also BINOCDF and STATS (Matlab statistics toolbox)

if prod(size(p))>1
  error('probability should be a scalar');
elseif p<0 || p>1
  error('probability should be between 0 and 1');
end

if min(x(:))<0 | max(x(:))>n
  error('X should be in the range 0:N')
end

nk  = gammaln(n + 1) - gammaln(x + 1) - gammaln(n - x + 1);
lny = nk + x.*log( p) + (n - x).*log(1 - p);
y   = exp(lny);

% fix rounding errors
y(y<0) = 0;
y(y>1) = 1;



 
 