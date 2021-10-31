function out = allprobabilistic( in )
%ALLPROBABILISTIC - Tests if all uncertainty blocks are probabilistic 
%
% SEE ALSO uncertainty, uncertainty/containsprobabilistic

if ~isempty(in.distribution)
  out=all(in.distribution>1);
else
  out=0;
end
