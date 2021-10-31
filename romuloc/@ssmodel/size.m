function varargout = size(sys,dim)
% SIZE - size of ssmodel
%
% Equivalent formulations : 
% s = size(sys)
% s = [ sys.py , sys.mu , sys.nb ]
% [ py , mu , nb ] = size(sys) 
% py = size(sys,1)  
% mu = size(sys,2)
% nb = size(sys,3)
%
% Get all signal dimensions :
% s = size(sys,'all')
% s = [ sys.n, sys.pd, sys.pz, sys.py, sys.md, sys.mw, sys.mu]
%
  
%   This file is part of RoMulOC
%   Last Update 31-Jan-2005
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France
  
  switch nargin
   case 1  
    switch nargout
     case 0
      if sys.nb>1
	fprintf('Array of %i systems\n',sys.nb);
	fprintf('Each model has:\n');
      elseif any(any(any(sys.M)))	
	fprintf('SSMODEL with:\n');
      else
	fprintf('empty SSMODEL\n')
      end
      if any(sys.r{1}) | any(sys.c{1})
	fprintf(' %i states\n',max(length(sys.r{1}),length(sys.c{1})));
      end
      if any(sys.r{2}) | any(sys.c{2})
	fprintf(' %i/%i exogenous outputs/inputs\n',length(sys.r{2}),length(sys.c{2}));
      end
      if any(sys.r{3}) | any(sys.c{3})
	fprintf(' %i performance outputs / %i disturbance inputs\n',length(sys.r{3}),length(sys.c{3}));
      end
      if any(sys.r{4}) | any(sys.c{4})
	fprintf(' %i measure outputs / %i control inputs\n',length(sys.r{4}),length(sys.c{4}));
      end
     case 1     
      if sys.nb>1
	varargout{1}=[length(sys.r{4}) length(sys.c{4}) sys.nb];
      else
	varargout{1}=[length(sys.r{4}) length(sys.c{4})];
      end	
     case 2
      varargout{1}=length(sys.r{4});    
      varargout{2}=length(sys.c{4});   
     case 3
      varargout{1}=length(sys.r{4});    
      varargout{2}=length(sys.c{4});
      varargout{3}=sys.nb;
    end
   case 2
    switch lower(dim)
     case 1
      varargout{1}=length(sys.r{4});   
     case 2 
      varargout{1}=length(sys.c{4});   
     case 3 
      varargout{1}=sys.nb;
     case 'all'
      varargout{1}=[max(length(sys.r{1}),length(sys.c{1})) , ...
		    length(sys.r{2}) , ...
		    length(sys.r{3}) , ...
		    length(sys.r{4}) , ...
		    length(sys.c{2}) , ...
		    length(sys.c{3}) , ...
		    length(sys.c{4}) ];
    end
    for ii=2:nargout
      varargout{ii}=[];
    end
  end
