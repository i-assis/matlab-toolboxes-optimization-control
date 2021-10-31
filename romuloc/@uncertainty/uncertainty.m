function delta = uncertainty(varargin)
% UNCERTAINTY - initialize a descriptor for structured uncertainty
%
% delta = uncertainty  : creates an empty uncertainty object
% uncertainty('clear') : clears all uncertainty objects in workspace
%
% Elementary uncertainties should be declared using:
%
% udiss  : general dissipative uncertainty
% unb    : norm-bounded uncertainty
% upos   : positive-real uncertainty
% ubase  : probabilistic (borrowed from RACT toolbox)
% upoly  : general polytopic uncertainty
% uparal : parallelotopic uncertainty
% uinter : interval uncertainty
%
% Note that udiss, unb, upos can have following options:
% - real or complex values
% - deterministic (det.) 
%   meaning properties should be guaranteed whatever their value
% - uniformly distributed 
%   meaning properties should hold in a probabilistic manner
% - lti, tv of nl
%   indicating whether these are LTI operators, Time-Varying operators
%   or Non-Linear operators 
% upoly, uparal and uinter can only be LTI 
% and can be either deterministic or uniformly distributed
%
% These can be combined into block-diagonal uncertain operators
% with uncertainty/diag 

%   This file is part of RoMulOC
%   Last Update 29-Oct-2013
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

persistent NBcreatedUNCERTAINTIES
if isempty(NBcreatedUNCERTAINTIES)
  NBcreatedUNCERTAINTIES=0;
end;
mlock

if nargin==1
  if isa(varargin{1},'uncertainty');
    delta=varargin{1};
  else
    switch lower(varargin{1})
      case 'clearclasses' % this one is used if 'uncertainty' is modified
        munlock(which('uncertainty'));
        clear classes
      case 'clear' % this one clears all uncertainties in workspace
        NBcreatedUNCERTAINTIES=0;
        W = evalin('caller','whos');
        for i = 1:size(W,1)
          if strcmp(W(i).class,'uncertainty')
            evalin('caller', ['clear ' W(i).name ';']);
          end
        end
      case 'modified: get new uindex'
        NBcreatedUNCERTAINTIES=NBcreatedUNCERTAINTIES+1;
        delta=NBcreatedUNCERTAINTIES;
      otherwise
        error('Wrong usage of UNCERTAINTY')
    end
  end
else
  if nargin>1
    switch varargin{1}
      case 'new'
        din=varargin{2};
        din.nbb=1;
        NBcreatedUNCERTAINTIES=NBcreatedUNCERTAINTIES+1;
        din.struc=[NBcreatedUNCERTAINTIES;1];
        din.uindex(1)=NBcreatedUNCERTAINTIES;
      case 'existing'
        din=varargin{2};
        din.nbb=1;
        din.struc=[varargin{3};1];
        din.uindex(1)=varargin{3};
      case 'temporary-special'
        din=varargin{2};
        din.nbb=1;
        din.struc=[0,1];
        din.uindex(1)=0;
      otherwise
        error('define uncertainties using UDISS, UNB, UPOS, UPOLY, UPARAL, UINTER');
    end
  else 
    % define empty uncertainty
    din=struct;
  end
  % DEFINE THE OBJECT
  if isfield(din,'nbb')
    % number of different uncertain elements
    delta.nbb = din.nbb;
  else
    delta.nbb = 0;
  end
  if isfield(din,'size')
    % global size of the uncertainty
    delta.size = din.size;
  else
    delta.size = [0,0];
  end
  if isfield(din,'nominal')
    delta.nominal=din.nominal;
  else
    delta.nominal={zeros(delta.size)};
  end
  if isfield(din,'usample')
    delta.usample=din.usample;
  else
    delta.usample={[]};
  end
  if isfield(din,'sampled')
    delta.sampled=din.sampled;
  else
    delta.sampled=[];
  end
  if isfield(din,'transpose')
    % =1 if uncertainty is transposed (=0) otherwise
    % note that the whole uncertainty is
    % transposed, one cannot define diagonal
    % uncertainties where some blocks are
    % transposed and others not.
    % I THINK IT SHOULD BE UNDERTOOD AS CONJUGATE TRANSPOSE !
    delta.transpose = din.transpose;
  else
    delta.transpose = 0;
  end
  if isfield(din,'struc')
    % struc(2,i) indicates local index of uncertain element
    % on i-th position of the diagonal, while struc(1,i)
    % indicates the global index of this uncertain element.
    delta.struc = din.struc;
  else
    delta.struc = zeros(2,0);
  end
  if isfield(din,'uindex')
    % uindex(i) : global index of the i-th uncertain element
    % THE IDEA BELOW SHOULD BE REMOVED, NON NEGATIVE INDEXES-USE TRANSPOSE
    % uindex(i)<0 if the uncertain element is the transpose conjugate
    % of the original uncertain element, (>0) otherwise.
    delta.uindex = din.uindex;
  else
    delta.uindex = [];
  end
  if isfield(din,'names')
    % names{i} : the name of i-th block
    delta.names = din.names;
  else
    delta.names=cell(1,delta.nbb);
  end
  if isfield(din,'constr')
    % constr{i} strings among
    % '{X,Y,Z}-dissipative', 'norm-bounded', 'positive real',
    % 'polytopic', 'parallelotopic', 'interval',
    % and others
    % Starting from now on only used for display
    delta.constr = din.constr;
  else
    delta.constr = {};
  end
  if isfield(din,'constrcode')
    % constrcode(i) code among
    % 10: polytopic, 11: parallelotopic, 12: interval,
    % 20: {X,Y,Z}-dissipative, 21: norm-bounded, 22: positive real,
    % 30: bounded in a p-norm ball (from RACT)
    delta.constrcode = din.constrcode;
  else
    delta.constrcode = [];
  end
  if isfield(din,'complex')
    % complex(i)=1 if the i-th uncertain element is complex valued 
    % and 0 if it is real valued (default)
    delta.complex = din.complex;
  else
    delta.complex = [];
  end
  if isfield(din,'distribution')
    % distribution(i)=1 if the i-th uncertain element is deterministic (default)
    % distribution(i)=2 if the i-th uncertain element is unifomly distributed
    % distribution(i)=3 if the i-th uncertain element has gaussian distribution
    delta.distribution = din.distribution;
  else
    delta.distribution = [];
  end
  if isfield(din,'nature')
    % nature(i)=10 if the i-th uncertain element is LTI (default)
    % nature(i)=20 if the i-th uncertain element is TV (no bound on derivative)
    % nature(i)=30 if the i-th uncertain element is non-linear (no specific type)
    delta.nature = din.nature;
  else
    delta.nature = [];
  end
  if isfield(din,'rows')
    % rows{i}(:,j) : rows in delta corresponding
    % to the j-th time the i-th uncertain element is repeated
    delta.rows = din.rows;
  else
    delta.rows = {[]};
  end
  if isfield(din,'cols')
    % cols{i}(:,j) : cols in delta corresponding
    % to the j-th time the i-th uncertain element is repeated
    delta.cols = din.cols;
  else
    delta.cols = {[]};
  end
  if isfield(din,'X')
    delta.X = din.X;            % X{i} : matrix for dissipative blocks
    delta.Y = din.Y;            % Y{i} : matrix for dissipative blocks
    delta.Z = din.Z;            % Z{i} : matrix for dissipative blocks
  else
    delta.X = {[]};
    delta.Y = {[]};
    delta.Z = {[]};
  end
  if isfield(din,'vtx')
    % vtx{i}(:,:,j) : j-th vertex for polytopic uncertain elements
    % j-th axe for parallelotopic uncertain elements
    % (except if j=end, the centre of parallelotope)
    % j=1:2, extremal values for interval uncertain elements
    delta.vtx = din.vtx;
  else
    delta.vtx = {[]};
  end
  if isfield(din,'ubase')
    % structure defining ubase objects (taken from RACT)
    delta.ubase = din.ubase;
  else
    delta.ubase = {struct};
  end
  
  delta=class(delta,'uncertainty');
end;