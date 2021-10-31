function out = upoly(vtx,varargin)
% UPOLY - Create polytopic uncertain operator or model
%
%# Polytopic uncertainty operator
%
%  delta = upoly(vertices)
%
%  <vertices> is an array containing the matrix vertices.
%  An ( md x pd x N ) array defines an
% ( md x pd ) uncertainty with N vertices
%  An ( md x pd x N1 x ... x Nr ) array defines an
% ( md x pd ) uncertainty wdith prod(Ni) vertices
%  The output <delta> is uncertain in the convex hull of the vertices
%
%  upoly(vals,name)
%
%  Allows to add a tag where <name> is a string.
%
%  upoly(vals,nom_val)
%
%  Allows to specify nominal value <nom_val>.
%  Default <nom_val=mean(vals,3)>
%
%  upoly(vals,'convhull')
%
%  Performs an LINPROG optimization in order to remove vertices 
%  that are linear convex combination of the others. 
%  Could take some time if number of samples is large (and can fail).
%  Nb of decision variables is nb_vertices^2.
%
%  Note that polytopic models are assumed deterministic.
%
%  All options can be combined as in the following
%  vtx(:,:,1)=[1 0];
%  vtx(:,:,2)=[0 1];
%  vtx(:,:,3)=[1 1];
%  unc = upoly(vtx, [0.5 0.5], 'a name')
%
% SEE ALSO udiss, unb, upos, uinter, uparal
%
%# Affine polytopic uncertain models:
%
%  usys = upoly(sys)
%
%  <sys> is an array of SSMODEL objects
%  that defines the vertices of the polytope
%  Output <usys> is a USSMODEL, uncerain inside the convex hull of the
%  vertices (same definition as above but applied to all system matrices).
%
% SEE ALSO ussmodel, uinter, uparal

%   This file is part of RoMulOC
%   Last Update 15-Oct-2015
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

if nargin<1
  error('Needs more input arguments');
end
pdata=struct;
nominal=[];
convhullremoval=0;

for ii=1:(nargin-1)
    if isnumeric(varargin{ii})
        if isempty(nominal)
            nominal=varargin{ii};
        else
            warning('%i-th argument of UPOLY ignored',ii);
        end
    elseif ischar(varargin{ii})
        if isequal(varargin{ii},'convhull')
            convhullremoval=1;
        elseif ~isfield(pdata,'names')
            pdata.names{1}=varargin{ii};
        else
            warning('%i-th argument of UPOLY ignored',ii);
        end
    end
end

if isnumeric(vtx)
  % Defining polytoic uncertainty
  sizevtx=size(vtx);
  if ~all(sizevtx)
    out=uncertainty;
  else
%     if length(sizevtx)<3
%       error('For polytopic uncert. op. : 1st input arg. must be at least a 3-D array');
%     end
    nbvertices=prod(sizevtx(3:end));
    reshapesize=ones(1, length(sizevtx));
    reshapesize(1)=sizevtx(1);
    reshapesize(2)=sizevtx(2);
    reshapesize(3)=nbvertices;
    vtx=reshape(vtx,reshapesize);
    % remove interior vertices
    if convhullremoval
        vtx=matconvhull(vtx);
        nbvertices=size(vtx,3);
    end
    rows=size(vtx,1);
    cols=size(vtx,2);
    pdata.size=[rows,cols];
    pdata.constr{1}=sprintf('polytope %i vertices',nbvertices);
    pdata.constrcode(1)=10;
    if isreal(vtx)
      pdata.complex=0;
    else
      pdata.complex=1;
    end
    if ~isfield(pdata,'distribution')
      pdata.distribution=1;
    end
    if ~isfield(pdata,'nature')
      pdata.nature=10;
    end    
    pdata.rows{1}=(1:rows)';
    pdata.cols{1}=(1:cols)';
    pdata.vtx{1} = vtx;
    if isempty(nominal)
      pdata.nominal{1}=mean(vtx,3);
    else
      try
        Aeq=reshape(vtx,size(nominal,1)*size(nominal,2),size(vtx,3));
        Aeq(end+1,:)=ones(1,size(vtx,3));
        beq=reshape(nominal,size(nominal,1)*size(nominal,2),1);
        beq(end+1,:)=1;
        LB=zeros(size(vtx,3),1);
        UB=ones(size(vtx,3),1);
        [~,~,exitflag]=linprog([],[],[],Aeq,beq,LB,UB,[],optimset('Display','off'));
        if exitflag>0
          pdata.nominal{1}=nominal;
        else
          error('Specified <nom_val> is not in the set');
        end
      catch ME_uparal
        error('Specified <nom_val> is not in the set');
      end
    end    
    pdata.usample={[]};
    pdata.sampled=0;
    out=uncertainty('new',pdata);
  end
elseif isa(vtx,'ssmodel')
    %   if vtx.md | vtx.pd
    %     error(['polytopic USSMODEL is forbiden for SSMODELs with wd/zd' ...
    %       ' exogenous signals']);
    %   end
    
    % remove interior vertices
    if convhullremoval
        [M,ixr,izd,iz,iy,ixc,iwd,iw,iu,Ts,name]=data(vtx);
        M=matconvhull(M);
        vtx=ssmodel(M,ixr,izd,iz,iy,ixc,iwd,iw,iu,Ts,name);
    end
    
    type = sprintf('polytope %i vertices',vtx.nb);
    sys = vtx;
    if nargin==2
        sys.name=varargin{1};
    end
    delta = uncertainty;
    out = ussmodel(sys,delta,type,'OK');
else
    error('1st input argument must be either a matrix or a ssmodel');
end

