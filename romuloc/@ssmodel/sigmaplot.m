function H = sigmaplot(sys,varargin)
% SSMODEL/SIGMAPLOT - Singular value plot for controlled output response to disturbance input 
%   
% sigmaplot(sys)
%
%    Singular value plot of with respect to controlled output <z> 
%    and disturbance channel in <w>.
%
%    Function calls the Control System Toolbox 'sigmaplot'.
%	
% sigmaplot(sys,options)
%
%    See options in lti/sigmaplot
%
% SEE ALSO ssmodel, ssmodel/norm, ssmodel/pole, ssmodel/impulse
  
%   This file is part of RoMulOC
%   Last Update 1-Jun-2011
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France
  
[sys,zdi,zi,yi,wdi,wi,ui,name]=ss(sys);
sys = sys(zi,wi);    

if nargout==0
  sigmaplot(sys,varargin{:});
else
  H=sigmaplot(sys,varargin{:});
end
  
    
    