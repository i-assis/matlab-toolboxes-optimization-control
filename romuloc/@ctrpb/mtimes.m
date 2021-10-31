function c = mtimes(a, b)
% MTIMES - Declare weighted multi-objective optimization 
%
% c = a * b
%
% <a> is double, <c>, <b> are CTRPB objects or
% <b> is double, <c>, <a> are CTRPB objects
%
% The scalar input arguments are the weights used in objective declaration
%
% Example: Declare a state-feedback design 
%          that optimizes 2*g2 + 3*gi where 'g2' and 'gi' are
%          respectively the H2 and H-infinity performances
%          with unique Lyapunov function for all perormances and uncertainties
%	 
% quiz = ctrpb('state-feedback', 'Lyap unique') + 2*h2(usys) + 3*hinfty(usys)
%
% SEE ALSO ctrpb

%   This file is part of RoMulOC
%   Last Update 23-Aug-2013
%   authors : Philippe Spiesser, Dimitri Peaucelle 
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

if isnumeric(a) & isa(b, 'ctrpb')
  n=a;
  c=b;
elseif isnumeric(b) & isa(a, 'ctrpb')
  n=b;
  c=a;
else
  error('wrong usage of times');
end
if ~isempty(c.tmp)
  for ii=1:size(c.tmp,1)
    c.tmp{ii,4}=n*c.tmp{ii,4};
  end
end
if ~isempty(c.objt)
  for ii=1:size(c.objt,1)
    c.objt(ii,2)=n*c.objt(ii,2);
  end
end  
if ~isempty(c.feast)
  for ii=1:size(c.feast,1)
    c.feast(ii,2)=n*c.feast(ii,2);
  end
end  

%
% if any(c.type)
%   error('Not allowed operation: empty CTRPB object');
% elseif size(c.vars,1)
%   error('Not allowed operation: not specified performance');
% elseif ~c.tmp{4}
%   error('Not allowed operation: computed performance');
% else
%   c.tmp{4}=n*c.tmp{4};
% end
