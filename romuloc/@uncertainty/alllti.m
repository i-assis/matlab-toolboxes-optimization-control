function out = alllti( in )
%ALLLTI - Tests if all uncertainty blocks are probabilistic or LTI
%
% SEE ALSO uncertainty, uncertainty/allprobabilistic


if ~isempty(in.nature)
  out=all(in.nature<20);
else
  out=1;
end
