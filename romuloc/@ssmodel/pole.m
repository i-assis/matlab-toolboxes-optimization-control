function p = pole(sys,dis)
% SSMODEL/POLE - compute the poles of the SSMODEL object
%   
% p = pole(sys);
%     
%    p is a vector containing the poles of the system
%    the function displays if the system is stable or not  
%    use p = pole(sys,0) to remove the display.
%
% SEE ALSO ssmodel, ssmodel/norm
  
%   This file is part of RoMulOC
%   Last Update 7-Feb-2007
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France
  

  if nargin<2
    dis=1;
  end;

  %  syss=ss(sys);
  %  p= pole(syss);

  A=sys.M(sys.r{1},sys.c{1},:);
  for ii=1:sys.nb
    p(:,:,ii)=eig(A(:,:,ii));
  end
        
  if dis
    
    if sys.T
      ptmp=max(abs(p),[],1);
      ptmp=(ptmp<1);  
    else
      ptmp=max(real(p),[],1);
      ptmp=(ptmp<0);
    end
    
    if all(ptmp)
      if sys.nb>1
	  disp('All systems in array are stable');
      else
	disp('System is stable');
      end
    elseif any(ptmp) & sys.nb>1
      disp('Some systems in array are unstable');
    else
      if sys.nb>1
	disp('All systems in array are unstable');
      else
	disp('System is unstable');
      end
    end
    
  end;
    
