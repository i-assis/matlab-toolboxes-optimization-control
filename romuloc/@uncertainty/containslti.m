function out = containslti( in )
%CONTAINSLTI - Tests if uncertainty contains LTI blocks
%
% SEE ALSO uncertainty, containsprobabilistic, alllti

if ~isempty(in.nature)
  out=any(in.nature<20);
else
  out=1;
end
