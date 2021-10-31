function [syscer,omega] = evalfr(sys,s,name)
% SSMODEL/EVALFR  Evaluate frequency response at a single/interval frequency.
%  
%  freqsys = evalfr(sys,omega,name);
%
% Evaluates the transfer function of the continuous- or discrete-time
% SSMODEL <sys> at the complex number s = <j*omega> or z = <e^(j*omega)>. 
% The output <freqsys> is itself a SSMODEL object
% with no dynamics and complex static transfer gains given by:
%                                    
%   freqsys.Dzu = sys.Dzu + sys.Cz * (x * I - sys.A)^-1 * sys.Bu
%   freqsys.Dyu = sys.Dyu + sys.Cy * (x * I - sys.A)^-1 * sys.Bu
%     ...
%     
% In case <omega> is 1-by-two array [omega_min omega_max] then the
% frequency is converted into an interval uncertainty and the resulting
% system is an ussmodel. If <sys> is an LFT ussmodel the frequency is added
% as an additional uncertainty on the existing ones.
%
% <name> is an optionnal string to give a name to the resulting system   
%
% SEE ALSO ssmodel, ssmodel/certain, ssmodel/feedback

%   This file is part of RoMulOC
%   Last Update 22-jan-2012
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France
  
  %%% check inputs
  if nargin<2
    error('usage: syscer = evalfr(sys,deltavalue);');
  elseif ~isa(sys,'ssmodel')
    error('1st argument must be a SSMODEL object');
  end;
  if isnumeric(s)
    if all(all(s>10000))
     error('ww = inf!!!!');
    else
      md=size(s);    
      if (max(md)~=1)
        error('the 2nd input argument has wrong number of rows must be a scalar');
      end;
      
    end
  else
    error('2nd argument must be a scalar');
  end;
  
  %%% test well posedness of closed-loop
  am=(s*speye(length(sys.c{1}))-sys.M(sys.r{1},sys.c{1}));
  %%% define closed-loop system
  if ~min(abs(eigs(am)))
    error('the closed loop system is not well-posed');
  else
    am=inv(am);
  end
  syscer=ssmodel;
  syscer.T=sys.T;
  syscer.nb=sys.nb;
  
  if nargin>2
    syscer.name=name;
  else
    syscer.name = '';
  end    
  lastr=0;lastc=0;
  for ii=[2 3 4]
    syscer.r{ii}=lastr+(1:length(sys.r{ii}));
    if ~isempty(syscer.r{ii})
      lastr=max(syscer.r{ii});
    end
    syscer.c{ii}=lastc+(1:length(sys.c{ii}));
    if ~isempty(syscer.c{ii})
      lastc=max(syscer.c{ii});
    end
  end
  

  otherr=[sys.r{2} sys.r{3} sys.r{4}];
  otherc=[sys.c{2} sys.c{3} sys.c{4}];
  
  xx=am*sys.M(sys.r{1},otherc);
  
  syscer.M=sys.M(otherr,otherc)+...
	   sys.M(otherr,sys.c{1})*xx;
