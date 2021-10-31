function p = pole(sys,dis)
% USSMODEL/POLE - compute the poles of the USSMODEL object
%   
% p = pole(sys);
%     
%    p is a vector containing the poles of the nominal value of the system
%    the function displays if the system is stable or not  
%    use p = pole(sys,0) to remove the display.
%
% SEE ALSO ussmodel, ssmodel/pole, ssmodel/nominal, ssmodel/norm
  
%   This file is part of RoMulOC
%   Last Update 6-Dec-2013
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France
  

  if nargin<2
    dis=1;
  end;

  p=pole(nominal(sys),dis);
    
end
    
