function out = uparal(cntr,ax,varargin)
% UPARAL - Create parallelotopic uncertain operator
%
%  delta = uparal(cntr,axes)
%
%  <cntr> is a 2-D array that defines the center of the parallelotope
%  <axes> is a r-D array with 2 first dimensions that fit those of <cntr>
%  For 3-D <axes>, <delta> is constrained to the set:
%  cntr + sum_i del_i*axes(:,:,i)   s.t.   |del_i|<=1
%  For r>3 the sum operates over all dimensions.
%
%  uparal(cntr,axes,name)
%
%  Allows to add a tag where <name> is a string.
%
%  uparal(cntr,axes,nom_val)
%
%  Allows to specify nominal value <nom_val>.
%  Default <nom_val=cntr>.
%
%  uparal(cntr,axes,'uniform')
%
%  Forces a uniform probabilistic distribution,
%  in that case, properties are expected probabilistically.
%  If not enforced, uncertainty is 'deterministic'
%  i.e. properties should be guaranteed whatever value in the set.
%
%  All options can be combined as in the following
%  unc = uparal(eye(2),[0 0.5;0 0], [1 0.25;0 1], 'a name', 'uniform')
%
% SEE ALSO udiss, unb, upos, uinter, upoly, ssmodel/uparal
% (ssmodel/uparal is for parallelotopic uncertain models)

%   This file is part of RoMulOC
%   Last Update 30-Oct-2013
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

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

if ~isnumeric(cntr)
  error('1rt input arg. should be a matrix')
else
  % Defining a parallelotopic uncertainty
  [rows,cols]=size(cntr);
  if ~all([rows,cols])
    out=uncertainty;
  else
    sizeax=size(ax);
    nbaxes=prod(sizeax(3:end));
    reshapesize=ones(1, length(sizeax));
    reshapesize(1)=sizeax(1);
    reshapesize(2)=sizeax(2);
    reshapesize(3)=nbaxes;
    ax=reshape(ax,reshapesize);
    if any([rows,cols]-[size(ax,1),size(ax,2)])
      error(['2nd input argument must have same 2 first dimensions' ...
        ' as 1st input argument']);
    end;
    % build the relevant vertices
    data.size=[rows,cols];
    data.constr{1}=sprintf('parallelotope %i param',nbaxes);
    data.constrcode(1)=11;
    if isreal(cntr) && isreal(ax)
      data.complex=0;
    else
      data.complex=1;
    end
    if ~isfield(data,'distribution')
      data.distribution=1;
    end
    if ~isfield(data,'nature')
      data.nature=10;
    end
    data.rows{1}=(1:rows)';
    data.cols{1}=(1:cols)';
    vtx=ax;
    vtx(:,:,end+1)=cntr;
    data.vtx{1} = vtx;
    if isempty(nominal)
      data.nominal{1}=cntr;
    else
      try
        Aeq=reshape(ax,size(nominal,1)*size(nominal,2),size(ax,3));
        beq=reshape(nominal-cntr,size(nominal,1)*size(nominal,2),1);
        UB=ones(size(ax,3),1);
        LB=-UB;
        [~,~,exitflag]=linprog([],[],[],Aeq,beq,LB,UB,[],optimset('Display','off'));
        if exitflag>0
          data.nominal{1}=nominal;
        else
          error('Specified <nom_val> is not in the set');
        end
      catch ME_uparal
        error('Specified <nom_val> is not in the set');
      end
    end
    data.usample={[]};
    data.sampled=0;
    out=uncertainty('new',data);
  end
end


