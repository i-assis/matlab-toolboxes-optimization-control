function out = allltv( in )
%ALLLTV - Tests if all uncertainty blocks are probabilistic or LTI or LTV
%
% SEE ALSO uncertainty, uncertainty/alllti

if ~isempty(in.nature)
  out=all(in.nature<30);
else
  out=1;
end
