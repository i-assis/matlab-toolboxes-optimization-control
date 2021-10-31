function out = uparal(cntr,ax,varargin)
% UPARAL - Create parallelotopic model
%
%  usys = uparal(cntr,axes)
%
%  <cntr> is an SSMODEL
%  <axes> is an array of SSMODEL objects that defines the axes of the
%  parallelotope. <axes> should have same dimensions as <cntr>. 
%  Hint for initializing <axes>: axes=ssmodel(0,cntr)
%
%  Output <usys> is a USSMODEL, uncertain inside the parallelotope
%
% SEE ALSO ussmodel, ssmodel/uinter, ssmodel/upoly, uparal
% (uparal is for parallelotopic uncertainty operators)

%   This file is part of RoMulOC
%   Last Update 30-Oct-2013
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

%%% Attention! For interval ussmodels would be preferable to transfert this
%%% part of the function to the directory @ssmodel.

if nargin<2
  error('Needs more input arguments');
end
data=struct;
nominal=[];

for ii=1:(nargin-2)
  if isnumeric(varargin{ii})
    if isempty(nominal)
      nominal=varargin{ii};
    else
      warning('%i-th argument of UPARAL ignored',ii);
    end
  else
    switch varargin{ii}
      case 'deterministic'
        if ~isfield(data,'distribution')
          data.distribution=1;
        end
      case 'uniform'
        if ~isfield(data,'distribution')
          data.distribution=2;
        end
      otherwise
        if ~isfield(data,'names')
          data.names{1}=varargin{ii};
        else
          warning('%i-th argument of UPARAL ignored',ii);
        end
    end
  end
end
if ~isfield(data,'distribution')
  data.distribution=1;
end


% Defining a parallelotopic ussmodel
if cntr.nb>1
  error(['For parallelotopic USSMODEL: 1st input arg. must not be an' ...
    ' array of SSMODEL']);
end
%   if cntr.md | cntr.pd
%     error(['parallelotopic USSMODEL is forbiden for SSMODELs with wd/zd' ...
%       ' exogenous signals']);
%   end
if ~isa(ax,'ssmodel')
  error('For parallelotopic USSMODEL: 2nd input arg. must be an SSMODEL');
end
if any(size(cntr,'all')-size(ax,'all'))
  error('two first input arg. must have all identical dimensions');
end
type = sprintf('parallelotope %i param.',ax.nb);
sys=ax;
sys.nb=sys.nb+1;
allsysr=[sys.r{1},sys.r{2},sys.r{3},sys.r{4}];
allsysc=[sys.c{1},sys.c{2},sys.c{3},sys.c{4}];
allcntrr=[cntr.r{1},cntr.r{2},cntr.r{3},cntr.r{4}];
allcntrc=[cntr.c{1},cntr.c{2},cntr.c{3},cntr.c{4}];
sys.M(allsysr,allsysc,sys.nb)=cntr.M(allcntrr,allcntrc);
if isfield(data,'names')
  sys.name=data.names{1};
end
if isfield(data,'distribution')
  if data.distribution==2
    delta=unb(0,0,'uniform');
    type=[type,' uniform. dist.'];
  else
    delta = uncertainty;
  end
end
out = ussmodel(sys,delta,type,'OK');


