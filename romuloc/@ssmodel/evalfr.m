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
%  [freqsys,domega] = evalfr(sys,[ome_min,ome_max],name);
%
% In case <omega> is 1-by-2 array [ome_min ome_max] then the
% frequency is converted into an interval uncertainty <domega> and the
% model build is with additional exogeneous signals wd/zd added following
% the existing ones.
%
% <name> is an optionnal string to give a name to the resulting system   
%
% SEE ALSO ssmodel, ssmodel/certain, ssmodel/feedback

%   This file is part of RoMulOC
%   Last Update 3-fev-2012
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France
  
  omega=uncertainty;
  %%% check inputs
  if nargin<2
    error('usage: freqsys = evalfr(sys,omega);');
  elseif ~isa(sys,'ssmodel')
    error('1st argument must be a SSMODEL object');
  end;
  if isnumeric(s)
    md=size(s);    
    if max(md)==1 % case evaluation is done for one frequency
      if isreal(s)
        if sys.T
          s=e^(j*s);
        else
          s=j*s;
        end
      end
      %%% test well posedness of closed-loop
      am=(s*repmat(eye(length(sys.c{1})),[1 1 sys.nb])-sys.M(sys.r{1},sys.c{1},:));
      %%% define closed-loop system
      for ii=1:sys.nb
        if ~min(abs(eigs(am(:,:,ii))))
          error('the closed loop system is not well-posed');
        else
          am(:,:,ii)=inv(am(:,:,ii));
        end
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
      for ii=1:sys.nb
        xx(:,:,ii)=am(:,:,ii)*sys.M(sys.r{1},otherc,ii); 
        syscer.M(:,:,ii)=sys.M(otherr,otherc,ii)+...
                sys.M(otherr,sys.c{1},ii)*xx(:,:,ii);
      end
    elseif max(md)==2
      if sys.nb>1
        error('sorry not implemented for arrays of systems');
      end
      if sys.T
        error('sorry not implemented for discrete-time systems')
      end
      if ~isreal(s)
        error('wrong usage of <evalfr>');
      end
      s=s(1:2);
      s=1./s;
      if all(s<Inf)
        omegatmp = udiss(2*min(s)*max(s),-min(s)-max(s),2,sprintf('1/omega in [%g , %g]',min(s),max(s)));
      else
        omegatmp = udiss(2*min(s(1:2)),-1,0,sprintf('1/omega in [%g , Inf]',min(s)));
      end
      omega=uncertainty;
      for ii=1:length(sys.r{1})
        omega=diag(omega,omegatmp);
      end
      syscer=ssmodel;
      syscer.T=sys.T;
      syscer.nb=sys.nb;
      if nargin>2
        syscer.name=name;
      else
        syscer.name = '';
      end    
      syscer.r{2}=(1:(length(sys.r{2})+length(sys.r{1})));
      syscer.c{2}=(1:(length(sys.c{2})+length(sys.c{1})));
      lastr=length(syscer.r{2});lastc=length(syscer.c{2});
      for ii=[3 4]
        syscer.r{ii}=lastr+(1:length(sys.r{ii}));
        if ~isempty(syscer.r{ii})
          lastr=max(syscer.r{ii});
        end
        syscer.c{ii}=lastc+(1:length(sys.c{ii}));
        if ~isempty(syscer.c{ii})
          lastc=max(syscer.c{ii});
        end
      end
%      sys.M(:,sys.c{1})=-j*sys.M(:,sys.c{1});
      syscer.M=sys.M([sys.r{2},sys.r{1},sys.r{3},sys.r{4}],...
                      [sys.c{2},sys.c{1},sys.c{3},sys.c{4}]);
      syscer.M(:,(1+length(sys.c{2}):(length(sys.c{2})+length(sys.c{1}))))=...
        -j*syscer.M(:,(1+length(sys.c{2}):(length(sys.c{2})+length(sys.c{1}))));
    else
      error('wrong usage of evalfr');
    end
  else
    error('wrong usage of evalfr');
  end    
end