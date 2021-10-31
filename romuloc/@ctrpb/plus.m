function c = plus(a, b)
% PLUS - add control problems
%
% c = a + b
%
% <c>, <a>, <b> are CTRPB objects
% 
% Addition is used 
%  - to specify the type of control problem (analysis or control design ;
%  type of Lyapunov matrix ; etc.) in such a case one of the two input
%  arguments contains this data (SEE ctrpb).
%  - to add a performance objective to a multi-objective problem 
%  (SEE stability, dstability, hinfty, h2, i2p)
%
% Example: Declare a state-feedback design 
%          that optimizes H2 performance under Hinfty constraints (<2) 
%          with unique Lyapunov function for all perormances and uncertainties
% 
% quiz = ctrpb('state-feedback', 'Lyap unique') + h2(usys) + hinfty(usys, 2)
%	
% Weighted multi-objective optimization is possible as well (ctrb/mtimes)
%
% Example: Declare a state-feedback design 
%          that optimizes 2*g2 + 3*gi where 'g2' and 'gi' are
%          respectively the H2 and H-infinity performances
%          with unique Lyapunov function for all perormances and uncertainties
%	 
% quiz = ctrpb('state-feedback', 'Lyap unique') + 2*h2(usys) + 3*hinfty(usys)
%
% SEE ALSO stability, dstability, hinfty, h2, i2p, ctrpb/mtimes, ctrpb/solvesdp


%   This file is part of RoMulOC
%   Last Update 30-Oct-2013
%   authors : Philippe Spiesser, Dimitri Peaucelle 
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France
  
ta = any(a.type);
pa = size(a.name, 1);
tb = any(b.type);
pb = size(b.name, 1);

if any(a.type(1:2)-b.type(1:2)) && ~ta
  c = a;
  for i = pa+1:1:pa+pb
    c.tmp{i,1}=b.tmp{i-pa,1};
    c.tmp{i,2}=b.tmp{i-pa,2};
    c.tmp{i,3}=b.tmp{i-pa,3};
    c.tmp{i,4}=b.tmp{i-pa,4};
    c.name{i,1}=b.name{i-pa,1};
    c.name{i,2}=b.name{i-pa,2};
  end
else
  if ta && ~tb
    c=a;pc=pa;undef=b;pu=pb;
  elseif tb && ~ta
    c=b;pc=pb;undef=a;pu=pa;
  else
    error('Not yet implemented');
  end
  for i = 1:pu
    % compilation
    c = performances(c, undef.tmp{i,1}, undef.tmp{i,2}, undef.tmp{i,3});
    c.tmp{pc+i,1}=undef.tmp{i,1};
    c.tmp{pc+i,2}=undef.tmp{i,2};
    c.tmp{pc+i,3}=undef.tmp{i,3};
    c.tmp{pc+i,4}=undef.tmp{i,4};
    if ~isempty(c.objt) % could be empty for randomized analysis methods
      c.objt(pc+i,2)=undef.tmp{i,4}*c.objt(pc+i,2);
      c.feast(pc+i,2)=undef.tmp{i,4}*c.feast(pc+i,2);
    end
  end
end
