function out = usample(in,sample_nb)
% USSMODEL/USAMPLE - Many random values of a USSMODEL
%
%  sys = usample(usys,nb)
%
% <nb> is the number of samples to be generated
% <sys> is an array of ssmodel objects that stacks the samples
%
% If <usys> is of interval or parallelotopic type, then the random values
% are distributed uniformly.
% If <usys> is of polytopic type, then the distribution is uniform over the
% simplex that describes the polytope.
% If <usys> is of LFT type, then only the probabilistic uncertainties are
% sampled. If there are no probabilistic uncertainties, then the
% deterministic LTI blocs are sampled as if uniformly distributed. If there
% are no LTI blocs, the TV blocs are sampled as if uniformly distributed.
% If there are no linear blocs, the NL blocs are sampled as if uniformly distributed.
%
% SEE ALSO isin

%   This file is part of RoMulOC
%   Last Update 13-Nov-2012
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

switch lower(in.type(1:3))
  case 'lft'
    if nargin<2
      sample_nb=in.ssmodel.nb;
    end
    out = certain(in,usample(in.uncertainty,sample_nb));
  otherwise
    if nargin<2
      sample_nb=1;
    end
    out = usample(in.ssmodel,sample_nb,lower(in.type(1:3)));
end