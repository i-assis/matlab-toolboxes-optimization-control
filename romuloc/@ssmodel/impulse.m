function [Y,T,X] = impulse(varargin)
% SSMODEL/IMPULSE - Plot controlled output response to impulse disturbance input 
%   
% impulse(sys)
%
%    Plots the controlled output <z> response to independent impulse
%    signals applied to each disturbance channel in <w>.
%
%    Function calls the Control System Toolbox 'impulse'.
%	
% [Y,T,X]=impulse(sys,T)
%
%    Works as the 'lti/impulse' function except for syntax   
%
% Ymax = impulse(sys,T)
%   
%    that outputs the peak on norm(z) for of the system for independent impulse
%    signals applied to each disturbance channel in <w>. 
%
% SEE ALSO ssmodel, ssmodel/norm, ssmodel/pole
  
%   This file is part of RoMulOC
%   Last Update 18-May-2016
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France
  
  for ii=1:nargin
    if isa(varargin{ii},'ssmodel');
      [sys,~,zi,~,~,wi,~,~]=ss(varargin{ii});
      varargin{ii} = sys(zi,wi);    
    end
  end
    
  if nargout==0
    impulse(varargin{:});
  else
    [Y,T,X]=impulse(varargin{:});
  end
  
  if nargout==1
    sizY=size(Y);
    if length(sizY)==2
      Y = max(max(abs(Y)));
    elseif length(sizY)==3
      Y = max(max(sqrt(sum(Y.^2,2))));
    else
      error('cannot handle impulse for multiple systems');
    end
  end
    
    