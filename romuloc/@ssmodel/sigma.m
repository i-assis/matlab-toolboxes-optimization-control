function n = sigma(sys,freq)
% SSMODEL/SIGMA - sigma plot of SSMODEL object
%   
% sigma(sys,freq);
%
%    Function calls the Control System Toolbox 'sigma'.
% 
% SEE ALSO ssmodel, ssmodel/impulse, ssmodel/norm
  
%   This file is part of RoMulOC
%   Last Update 7-Oct-2012
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France
  
  [syss,zdi,zi,yi,wdi,wi,ui,name]=ss(sys);
  if nargin<2
    sigma(syss(zi,wi));
  else
    sigma(syss(zi,wi),freq);
  end
    
