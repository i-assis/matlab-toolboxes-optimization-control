function varargout = size(eli,dim)
% SIZE - size of melli object
%
% SEE ALSO melli
  
%   This file is part of RoMulOC
%   Last Update 23-Nov-2012
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France
  
switch nargin
  case 1
    switch nargout
      case 0
        display(eli);
      case 1
        varargout{1}=[size(eli.Z,1),size(eli.X,1)];
      case 2
        varargout{1}=size(eli.Z,1);
        varargout{2}=size(eli.X,1);
    end
  case 2
    switch dim
      case 1
        varargout{1}=size(eli.Z,1);
      case 2
        varargout{1}=size(eli.X,1);
    end
end

