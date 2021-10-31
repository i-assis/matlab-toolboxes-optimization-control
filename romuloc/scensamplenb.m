function nb_sample=scensamplenb(epsilon,delta,nbvar);
% SCENSAMPLENB - Number of samples for scenario design approach
%
% nb = scensamplenb( epsilon, delta, nbvar )
%
% The function is used for randomized scenario design methods (SEE ctrpb)
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
% SEE ALSO ctrpb, chernoff, wcsamplenb, ctrpb/solvesdp

%   This file is part of RoMulOC
%   Last Update 30-Jan-2015
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France 

%nb_sample = ceil((2/epsilon)*log(1/delta)+2*nbvar+(2*nbvar/epsilon)*log(2/epsilon));

%% compute the bound numerically
  Nta=ceil(1.58/epsilon*(log(1/delta)+nbvar));
  N=fminbnd(@(Ni) bound(Ni,nbvar,epsilon,delta),.7*Nta,Nta);
  nb_sample=ceil(N);

%% function to solve the numeric problem
 function F=bound(Ni,nbvar,epsilon,delta)

F=binocdf(nbvar,Ni,epsilon)-delta;

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



 
 