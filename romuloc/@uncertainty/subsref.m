function out = subsref(delta,s)
% UNCERTAINTY/SUBSREF - Get a block from uncertainty objects
%   
%  d = delta{i} 
%  outputs the uncertainty composed only of the block index by <i>
%
%  idx = delta.uindex
%  outputs the index of the uncertainty (if one unique block)
%  or a vector containing indices of contained uncertainties
%
% SEE ALSO uncertainty
  
%   This file is part of RoMulOC
%   Last Update 29-Oct-2013
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

if s.type=='()'
  error('Specify a block index as <delta{i}>');
elseif s.type=='.'
  switch s.subs
    case 'uindex'
      out=abs(delta.uindex);
    case 'samplenb'
      sampled=find(delta.sampled);
      if isempty(sampled)
        out=0;
      else
        out=size(delta.usample{sampled(1)},3);
      end
    otherwise
      error('Undefined uncertainty/subsref usage');
  end
else
  if length(s.subs)>1
    error('call for one subscript at a time');
  elseif ~isnumeric(s.subs{1})
    error('subscript must be an integer');
  elseif max(size(s.subs{1}))>1
    error('subscript must be an integer');
  elseif round(s.subs{1})~=s.subs{1}
    error('subscript must be an integer');
  elseif s.subs{1}<=0
    error('subscript must be strictly positive');
  else
    ii=s.subs{1};
  end;
  switch s.type
    case '{}'
      blkpos=find(delta.struc(1,:)==ii);
      if isempty(blkpos)
        error('uncertain block does not exist in object');
      else
        blkpos=delta.struc(2,blkpos(1));
        data.transpose=delta.transpose;
        data.distribution=delta.distribution(blkpos);
        data.nature=delta.nature(blkpos);
        data.size=[size(delta.rows{blkpos},1),size(delta.cols{blkpos},1)];
        data.names{1}=delta.names{blkpos};
        data.constr{1}=delta.constr{blkpos};
        data.complex(1)=delta.complex(blkpos);
        data.rows{1}=(1:data.size(1))';
        data.cols{1}=(1:data.size(2))';
        switch delta.constr{blkpos}(1:7)
          case {'{X,Y,Z}','norm-bo','positiv'}
            data.X{1}=delta.X{blkpos};
            data.Y{1}=delta.Y{blkpos};
            data.Z{1}=delta.Z{blkpos};
            data.vtx{1}={};
          case {'polytop','interva','paralle'}
            data.X{1}=[];
            data.Y{1}=[];
            data.Z{1}=[];
            data.vtx{1}=delta.vtx{blkpos};
        end;
        out=uncertainty('existing',data,ii);
      end;
  end
end
