function out = ctranspose( in )
%USSMODEL/CTRANSPOSE Conjugate transpose of an uncertain system
% 
% SEE ALSO ussmodel

out=ussmodel;
out.type=in.type;
out.ssmodel=in.ssmodel';
switch in.type
  case {'LFT'}
    out.uncertainty=in.uncertainty';
end

end

