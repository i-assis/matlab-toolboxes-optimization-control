function sys = sfeedback(S1,S2,name)
% SFEEDBACK - build the closed loop with a state-feedback
%    
% syscl = sfeedback(sysol,cont,name);
%              _______ 
%       zd1 <-|       |<- wd1
%        z1 <-| sysol |<- w1
% <----- y1 <-|_______|<- u1 --O<- u
%               ______         ^
%        wd2 ->|      |-> zd2  |
%         w2 ->| cont |-> z2   |
%      x1=u2 ->|______|-> y2 --' 
%
% gives the augmented system with concatenated 
% performance and exogenous outputs/inputs
%                      _____
% zd=[ zd1' zd2' ]' <-|     |<- wd=[ wd1' wd2' ]'
% z =[ z1'  z2'  ]' <-| out |<- w =[ w1'  w2'  ]'     
% y =  y1           <-|_____|<- u
%	               
% Negative feedback is assumed 
% (use -cont in the arguments for positive feedback)  
%
% Either <sysol> or <cont> can be matrices.
% If <sysol> and <cont> are arrays, 'sfeedback' is performed element-wise. 
% If only one is an array, 'sfeedback' is performed for all its elements.
%
% <name> is an optionnal string to give a name to the resulting system   
%  
% SEE ALSO ssmodel, certain, shape  
  
%   This file is part of RoMulOC
%   Last Update 7-Feb-2007
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France
  
  %%% check inputs
  if nargin<2
    error('usage: syscl = feedback(sysol,cont);');
  elseif nargin==2
    name='';
  end;

  if isa(S2,'ussmodel')
    S1 = ussmodel(S1,[]);
    out = sfeedback(S1,S2,name);
  elseif isnumeric(S2)
    S2=ssmodel(S2);
    S2.T=S1.T;
    S2.name = 'CONTROLLER';
  elseif ~isa(S2,'ssmodel')
    error('First convert the 2nd input arg. to SSMODEL')
  else
    if isnumeric(S1)
      S1=ssmodel(in1);
      S1.T=S2.T;
    end
    if S1.T~=S2.T
      error('both inputs must have same sample time');
    end  
%    if any(S1.c{3}) & any(S2.c{3})
%      error('input ssmodels cannot have simultaneously <w> performance inputs');
%    end  
%    if any(S1.r{3}) & any(S2.r{3})
%      error('input ssmodels cannot have simultaneously <z> performance outputs');
%    end    
    if length(S1.r{1})~=length(S2.c{4}) | length(S1.c{4})~=length(S2.r{4})
      error('input/output dimensions do not fit')
    end  
    if S1.nb>1 & S2.nb>1
      if S1.nb-S2.nb
	error('Inputs are arrays with incompatible dimensions');
      end
    end
end
    % now the computation begins
    
    sys=ssmodel;
    sys.T=S1.T;
    sys.name=name;

    lr1=size(S1.M,1);
    lc1=size(S1.M,2);
    for ii=1:3
      sys.r{ii}=[S1.r{ii},lr1+S2.r{ii}];
      sys.c{ii}=[S1.c{ii},lc1+S2.c{ii}];
    end
    sys.r{4}=S1.r{4};
    sys.c{4}=S1.c{4};
    
    modnb = max(S1.nb,S2.nb);  
    sys.nb=modnb;  
    for jj=1:modnb
      i1 = min(jj,S1.nb);
      i2 = min(jj,S2.nb);      
      
      sys.M(1:lr1,S1.c{1},jj)=...
	S1.M(:,S1.c{1},i1)-S1.M(:,S1.c{4},i1)*S2.M(S2.r{4},S2.c{4},i2);
      sys.M(1:lr1,[S1.c{2},S1.c{3},S1.c{4}],jj)=...
	  S1.M(:,[S1.c{2},S1.c{3},S1.c{4}],i1);
      sys.M(1:lr1,lr1+[S2.c{1},S2.c{2},S2.c{3}],jj)=...
	  -S1.M(:,S1.c{4},i1)*S2.M(S2.r{4},[S2.c{1},S2.c{2},S2.c{3}],i2);
      sys.M(lr1+[S2.r{1},S2.r{2},S2.r{3}],S1.c{1},jj)=...
	  S2.M([S2.r{1},S2.r{2},S2.r{3}],S2.c{4},i2);
      sys.M(lr1+[S2.r{1},S2.r{2},S2.r{3}],lr1+[S2.c{1},S2.c{2},S2.c{3}],jj)=...
	  S2.M([S2.r{1},S2.r{2},S2.r{3}],[S2.c{1},S2.c{2},S2.c{3}],i2);
      
    end
