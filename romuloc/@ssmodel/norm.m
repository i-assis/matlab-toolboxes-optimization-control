function n = norm(sys,type,tol)
% SSMODEL/NORM - compute the H2 or Hinfty norm of the SSMODEL object
%   
% n = norm(sys,type);
%     
%    type =2 or =Inf to get the H2 of Hinfty norm of the system
%    the function displays if the system is stable or not.
%
%    Function calls the Control System Toolbox 'norm'.
% 
% SEE ALSO ssmodel, ssmodel/impulse
  
%   This file is part of RoMulOC
%   Last Update 19-May-2016
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France
  
  if nargin<2
    type=2;
    tol=[];
  elseif nargin<3
    tol=[];
  end
  if nargout==0
    pole(sys);
  end
  [syss,~,zi,~,~,wi,~,~]=ss(sys);
  n=norm(syss(zi,wi),type,tol);
