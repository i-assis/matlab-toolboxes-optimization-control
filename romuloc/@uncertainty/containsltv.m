function out = containsltv( in )
%CONTAINSLTV - Tests if uncertainty contains LTI or LTV blocks
%
% SEE ALSO uncertainty, containslti, allltv

if ~isempty(in.nature)
  out=any(in.nature<20);
else
  out=1;
end
