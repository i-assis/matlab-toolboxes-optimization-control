function varargout = size(delta,siz)
% SIZE - size of uncertainty
% overloaded   

%   This file is part of RoMulOC
%   Last Update 31-Jan-2005
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

  switch nargin
   case 2
    varargout{1}=delta.size(siz);
   case 1
    switch nargout
     case 0
      delta.size
     case 1
      varargout{1}=delta.size;
     case 2
      varargout{1}=delta.size(1);    
      varargout{2}=delta.size(2);
    end
  end
