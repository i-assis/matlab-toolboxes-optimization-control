function out = display(R)
% DISPLAY - Display REGION object
%   
  
%   This file is part of RoMulOC
%   Last Update 31-Jan-2005
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France
  
  out=[];
  nbu=length(R.type);  
  if nbu==0
    out=[out,'''Empty REGION object'',10'];
  end
  if nbu>1
    out=[out,'''Union of following regions'',10,''-----'',10'];
  end
  for ii=1:nbu
    nbi=length(R.type{ii});
    if nbi>1
      out=[out,'''Intersection of followding elementary regions:'',10'];
    end
    for jj=1:nbi
      out=[out,'''',sprintf('%s',R.type{ii}{jj}),''',10'];      
    end
    if nbu>1
      out=[out,'''-----'',10'];
    end
  end
  
  if ~nargout    
    out=['[',out,']'];  
    eval(['fprintf(''%s'',',out,')']);
  end