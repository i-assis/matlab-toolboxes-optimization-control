function n = norm(sys,type)
% USSMODEL/NORM - compute the nominal H2 or Hinfty norm of the USSMODEL object
%   
% n = norm(sys,type);
%     
%    type =2 or =Inf to get the H2 of Hinfty norm of the system
%    the function displays if the system is stable or not  
% 
% SEE ALSO SSMODEL
  
%   This file is part of RoMulOC
%   Last Update 31-Jan-2005
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

  if nargin<2
    type=2;
  end
  sys = nominal(sys);
  fprintf('Nominal ');
  n=norm(sys,type);
