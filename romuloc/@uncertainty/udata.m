function varargout = udata(delta,idx)
% UNCERTAINTY/UDATA - Get data on uncertainty objects
%
%  udata(delta,i) gives data on the independent block index by <i>
%  if <delta> is composed of a single block, <i> is optionnal.
%
%  if the block is
%
%  * polytopic           : [vtx,name] = udata(delta,i)
%  outputs the 3-D array wdith all vertices <vtx>
%
%  * interval            : [valmin,valmax,name] = udata(delta,i)
%  outputs the two extremal values and the name
%
%  * parallelotopic      : [cntr,ax,name] = udata(delta,i)
%  outputs the central value <cntr>, the 3-D array of axes <ax> and the name
%
%  * norm-bounded        : [rho,name] = udata(delta,i)
%  outputs the extremal norm <rho> and the name
%
%  * positive-real       : [name] = udata(delta,i)
%  outputs the name
%
%  * {X,Y,Z}-dissipative : [eli,name]=udata(delta,i)
%                       or [X,Y,Z,name]=udata(delta,i)
%  outputs the MELLI object defining the set and the name
%
%  * ubase : UStruct=udata(delta,i)
%  outupts a structure describing the uncertainty
%
% SEE ALSO uncertainty, uncertainty/subsref

%   This file is part of RoMulOC
%   Last Update 30-Oct-2013
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

if delta.nbb==1 && nargin==1
  idx=delta.struc(1,1);
elseif nargin~=2
  error('usage is udata(delta,i)');
end;
if ~isnumeric(idx)
  error('2nd input argument must be an integer');
elseif max(size(idx))>1
  error('2nd input argument must be an integer');
elseif round(idx)~=idx
  error('2nd input argument must be an integer');
elseif idx<=0
  error('2nd input argument must be strictly positive');
end;
blkpos=find(delta.struc(1,:)==idx);
if isempty(blkpos)
  disp('block does not exist in the uncertainty');
  varargout{1}=[];
else
  blkpos=delta.struc(2,blkpos(1));
  switch delta.constr{blkpos}(1:7)
    case '{X,Y,Z}'
      if nargout<=2
        varargout{1}=melli(delta.X{blkpos},delta.Y{blkpos},delta.Z{blkpos});
        varargout{2}=delta.names{blkpos};
      else
        varargout{1}=delta.X{blkpos};
        varargout{2}=delta.Y{blkpos};
        varargout{3}=delta.Z{blkpos};
        varargout{4}=delta.names{blkpos};
      end
    case 'interva'
      varargout{1}=delta.vtx{blkpos}(:,:,1);
      varargout{2}=delta.vtx{blkpos}(:,:,2);
      varargout{3}=delta.names{blkpos};
    case 'norm-bo'
      varargout{1}=sqrt(-delta.X{blkpos}(1,1));
      varargout{2}=delta.names{blkpos};
    case 'polytop'
      varargout{1}=delta.vtx{blkpos};
      varargout{2}=delta.names{blkpos};
    case 'paralle'
      varargout{1}=delta.vtx{blkpos}(:,:,end);
      varargout{2}=delta.vtx{blkpos}(:,:,1:(end-1));
      varargout{3}=delta.names{blkpos};
    case 'positiv'
      varargout{1}=delta.names{blkpos};
    case 'proba. '
      varargout{1}=delta.ubase{blkpos};
  end;
end;
