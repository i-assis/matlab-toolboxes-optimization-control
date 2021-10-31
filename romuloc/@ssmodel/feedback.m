function sys = feedback(S1,S2,name)
% SSMODEL/FEEDBACK - build the closed loop with a controller
%    
% syscl = feedback(sysol,cont,name);
%              _______ 
%       zd1 <-|       |<- wd1
%        z1 <-| sysol |<- w1
% <----- y1 <-|_______|<- u1 --O<- u
%   |           ______         ^
%   |    wd2 ->|      |-> zd2  |
%   |     w2 ->| cont |-> z2   |
%   '- y1=u2 ->|______|-> y2 --' 
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
% <cont> can be an LTI object.
% If <sysol> and <cont> are arrays, 'feedback' is performed element-wise. 
% If only one is an array, 'feedback' is performed for all its elements.
%
% <name> is an optionnal string to give a name to the resulting system   
%  
% SEE ALSO ssmodel, certain, shape  
  
%   This file is part of RoMulOC
%   Last Update 20-Feb-2009
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France
  
  %%% check inputs
  if nargin<2
    error('usage: syscl = feedback(sysol,cont);');
  elseif nargin==2
    name ='';
  end;

  if isa(S2,'ussmodel')
    S1 = ussmodel(S1,[]);
    out = feedback(S1,S2,name);
  elseif isnumeric(S2)
    S2=ssmodel(S2);
    S2.T=S1.T;
    S2.name = 'CONTROLLER';
  elseif ~isa(S2,'ssmodel')
    S2=ssmodel(S2);
    S2.T=S1.T;
    S2.name = 'CONTROLLER';
  else
    if isnumeric(S1)
      S1=ssmodel(in1);
      S1.T=S2.T;
    end
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
    if length(S1.r{4})~=length(S2.c{4}) | length(S1.c{4})~=length(S2.r{4})
      error('input/output dimensions do not fit')
    end  
    if S1.nb>1 & S2.nb>1
      if S1.nb-S2.nb
	error('Inputs are arrays with incompatible dimensions');
      end
    end  
    % now the computation begins
    
    sys=ssmodel;
    sys.T=S1.T;
    sys.name=name;

    modnb = max(S1.nb,S2.nb);  
    sys.nb=modnb;  
    
    M1xx=S1.M([S1.r{1} S1.r{2} S1.r{3}],[S1.c{1} S1.c{2} S1.c{3}],:);
    M2xx=S2.M([S2.r{1} S2.r{2} S2.r{3}],[S2.c{1} S2.c{2} S2.c{3}],:);
    M1xu=S1.M([S1.r{1} S1.r{2} S1.r{3}],S1.c{4},:);
    M2xu=S2.M([S2.r{1} S2.r{2} S2.r{3}],S2.c{4},:);
    M1yx=S1.M(S1.r{4},[S1.c{1} S1.c{2} S1.c{3}],:);
    M2yx=S2.M(S2.r{4},[S2.c{1} S2.c{2} S2.c{3}],:);
    M1yu=S1.M(S1.r{4},S1.c{4},:);
    M2yu=S2.M(S2.r{4},S2.c{4},:);
    
    nr1=0; nr2=0;
    mr1=length(S1.r{1})+length(S1.r{2})+length(S1.r{3});
    nc1=0; nc2=0;
    mc1=length(S1.c{1})+length(S1.c{2})+length(S1.c{3});
    for ii=1:3
      sys.r{ii}=[nr1+(1:length(S1.r{ii})), mr1+nr2+(1:length(S2.r{ii}))];
      nr1=nr1+length(S1.r{ii}); nr2=nr2+length(S2.r{ii}); 
      sys.c{ii}=[nc1+(1:length(S1.c{ii})), mc1+nc2+(1:length(S2.c{ii}))];
      nc1=nc1+length(S1.c{ii}); nc2=nc2+length(S2.c{ii}); 
    end
    sys.r{4}=nr1+nr2+(1:length(S1.r{4}));
    sys.c{4}=nc1+nc2+(1:length(S1.c{4}));
    
    for jj=1:modnb
      i1 = min(jj,S1.nb);
      i2 = min(jj,S2.nb);
  
      DT=eye(length(S2.r{4}))+M2yu(:,:,i2)*M1yu(:,:,i1);
      if min(abs(eig(DT)))<eps
	error('This closed-loop is not well-posed');
      end
      DT=inv(DT);
      
      if nr1
	sys.M(1:nr1,1:nc1,jj)...
	    =M1xx(:,:,i1)-M1xu(:,:,i1)*DT*M2yu(:,:,i2)*M1yx(:,:,i1);
	sys.M(1:nr1,nc1+(1:nc2),jj)...
	    =-M1xu(:,:,i1)*DT*M2yx(:,:,i2);
	sys.M(1:nr1,sys.c{4},jj)...
	    =M1xu(:,:,i1)*DT;
      end
      if nr2
	sys.M(nr1+(1:nr2),1:nc1,jj)...
	    =M2xu(:,:,i2)*(eye(length(S1.r{4}))-M1yu(:,:,i1)*DT*M2yu(:,:,i2))*M1yx(:,:,i1);
	sys.M(nr1+(1:nr2),nc1+(1:nc2),jj)...
	    =M2xx(:,:,i2)-M2xu(:,:,i2)*M1yu(:,:,i1)*DT*M2yx(:,:,i2);
	sys.M(nr1+(1:nr2),sys.c{4},jj)...
	    =M2xu(:,:,i2)*M1yu(:,:,i1)*DT;
      end
      if sys.r{4}
	sys.M(sys.r{4},1:nc1,jj)...
	    =M1yx(:,:,i1)-M1yu(:,:,i1)*DT*M2yu(:,:,i2)*M1yx(:,:,i1);
	sys.M(sys.r{4},nc1+(1:nc2),jj)...
	    =-M1yu(:,:,i1)*DT*M2yx(:,:,i2);
	sys.M(sys.r{4},sys.c{4},jj)...
	    =M1yu(:,:,i1)*DT;
      end
      
    end
