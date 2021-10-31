function out = containsprobabilistic( in )
%CONTAINSPROBABILISTIC - Tests if uncertainty contains probabilistic blocks
%
% SEE ALSO uncertainty

out=any(in.distribution>1);

end

