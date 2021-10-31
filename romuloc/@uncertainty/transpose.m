function dout = transpose(din)
% TRANSPOSE - Transpose uncertainty object
% 
% dout = transpose(din)    or    dout = din.'
%
% build (when possible) an uncertainty object such that 
% the set of matrices constrained by specifications in <dout>
% is exactly described by transposed matrices of the set defined by <din>
    
%   This file is part of RoMulOC
%   Last Update 18-Mar-2013
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

  dout=uncertainty;
  dout.transpose = ~din.transpose;
  dout.nbb=din.nbb;
  dout.size=[din.size(2),din.size(1)];
  dout.struc=din.struc;
  dout.uindex=din.uindex;
  dout.names=din.names;
  dout.constr=din.constr;
  dout.complex=din.complex;
  dout.rows=din.cols;
  dout.cols=din.rows;
  
  for ii=1:length(din.uindex)
    dout.vtx{ii}=permute(din.vtx{ii},[2 1 3]);
    if ~isempty(din.X{ii})
      X=din.X{ii};
      Y=din.Y{ii};
      Z=din.Z{ii};
      if min(eig(Z))>eps
	Zt=Y*inv(Z)*Y'-X;
	if min(eig(Zt))>eps
	  dout.X{ii}=inv(Y'*inv(X)*Y-Z);
	  dout.Z{ii}=inv(Zt);
	  dout.Y{ii}=inv(Z)*Y'*dout.Z{ii};
	else
	  error(sprintf('Cannot perform transpose on uncertain block #%i',din.uindex(ii)));
	end
      elseif ~any(any(Z))
	if size(Y,1)==size(Y,2)
	  if min(svd(Y))>eps
	    dout.Z{ii}=Z;
	    dout.Y{ii}=inv(Y);
	    dout.X{ii}=dout.Y{ii}*X*dout.Y{ii}';
	  else
	    error(sprintf('Cannot perform transpose on uncertain block #%i',din.uindex(ii)));
	  end
	else
	  error(sprintf('Cannot perform transpose on uncertain block #%i',din.uindex(ii)));
	end
      else
	error(sprintf('Cannot perform transpose on uncertain block #%i',din.uindex(ii)));
      end
    else
      dout.X{ii}=din.X{ii};
      dout.Y{ii}=din.Y{ii};
      dout.Z{ii}=din.Z{ii};
    end      
  end
  
  
