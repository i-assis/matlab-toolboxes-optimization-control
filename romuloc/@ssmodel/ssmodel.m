function S=ssmodel(varargin);
% SSMODEL - Define a SSMODEL object 
%
% sysm = ssmodel(M, ixr,izd,iz,iy, ixc,iwd,iw,iu, Ts, name);
%  
%   where <M> is a matrix, defines the following system:
%
%   dx =  A*x +  Bd*wd +  Bw*w +  Bu*u  
%   zd = Cd*x + Ddd*wd + Ddw*w + Ddu*u
%    z = Cz*x + Dzd*wd + Dzw*w + Dzu*u
%    y = Cy*x + Dyd*wd + Dyw*w + Dyu*u
%  
%   such that 
%    A=M(ixr,ixc)  Bd=M(ixr,iwd)  Bw=M(ixr,iw)  Bu=M(ixr,iu)
%   Cd=M(izd,ixc) Ddd=M(izd,iwd) Ddw=M(izd,iw) Ddu=M(izd,iu)	
%   Cz=M( iz,ixc) Dzd=M( iz,iwd) Dzw=M( iz,iw) Dzu=M( iz,iu)	
%   Cy=M( iy,ixc) Dyd=M( iy,iwd) Dyw=M( iy,iw) Dyu=M( iy,iu)	
%	
%   By definition 
%   <wd>, <zd> are exogenous signals (for LFT modelling); 
%    <w>,  <z> are perturbation inputs and controlled outputs (for performance); 
%    <u>,  <y> are command inputs and measure outputs (for control).
%
%   Ts = 0 for continuous-time systems otherwize Ts is the sampling time  
%
%   If <M> is an N1 x N2 x N3 x...x Nr array 
%   then <sysm> is an 1 x prod([N3...Nr]) array of SSMODEL objects.
%
% CONVERSION FROM CONTROL SYSTEM TOOLBOX if <sys> is an LTI (SS, TF or ZPK) object:
% 
% sysm = ssmodel(sys, izd,iz,iy, iwd,iw,iu, name);
%   then differents inputs/outputs are specified by index vectors
%   <izd>, <iz>, <iy> give the rows of <sys> corresponding to <zd>, <z>, <y>  
%   <iwd>, <iw>, <iu> give the columns of <sys> corresponding to <wd>, <w>, <u>  
%
%   If <sys> is an N1 x N2 x...x Nr array of LTI systems 
%   then <sysm> is an 1 x prod(Ni) array of SSMODEL objects.
%
% SHORT CUTS where <sys> is either an LTI object or a matrix:
%	
% sysm = ssmodel(sys) or ssmodel(sys,'control',name)
%   then all inputs are declared for control <u> and
%   all outputs are declared as measures <y>.
%  
% sysm = ssmodel(sys,'filter',name)
%   then all inputs are declared for perturbation <w> and
%   all outputs are declared as controlled outputs <z>.
%
% sysm = ssmodel(sys,'nominal',name)
%   then all inputs are declared for perturbation <wd> and
%   all outputs are declared as controlled outputs <zd>.  
%
% EMPTY SSMODELs:
% 
% sysm = ssmodel(name)  -  outputs an empty SSMODEL
%
% sysm = ssmodel(0,sys,name)
%   where <sys> is an SSMODEL, outputs <sysm>, with same dimensions, 
%   same sample time, but all identically zero matrices. 
%	
% <name> is always an optionnal string.
%
% SEE ALSO uncertainty, ssmodel/feedback, ssmodel/display
%                       ssmodel/get  
    
  
%   This file is part of RoMulOC
%   Last Update 17-Oct-2005
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

  S.T=0;
  S.Mn={'A','Bd','Bw','Bu';...
	'Cd','Ddd','Ddw','Ddu';...
	'Cz','Dzd','Dzw','Dzu';...
	'Cy','Dyd','Dyw','Dyu'};		 
  S.M=zeros(0,0);
  S.c={[],'x','n';...
       [],'wd','md';...
       [],'w','mw';...
       [],'u','mu'};
  S.r={[],'dx','n';...
       [],'zd','pd';...
       [],'z','pz';...
       [],'y','py'};
  S.nb=0;
  S.name='';
  %%% check inputs
%  if nargin>3
%    for ii=2:(2*floor((nargin+1)/2)-1)
%      if ~isnumeric(varargin{ii})
%	error(sprintf('%i-th argument must be row vector of integers\n',ii+1));
%      elseif ( 1<size(varargin{ii},1) ...
%	       | round(varargin{ii})-varargin{ii} ...
%	       | min(varargin{ii})<0 )
%	error(sprintf('%i-th argument must be row vector of positive integers\n',ii+1));    
%      end;
%    end;  
%  end;  
  % for all excpected cases do
  switch nargin
   case 0
    % create empty SSMODEL
   case 1
    in1=varargin{1};
    if isa(in1,'ssmodel')
      % do not alter SSMODEL
      S=in1;
      return;
    elseif isa(in1,'lti') 
      % create SSMODEL with only y/u
      in1=ss(in1);
      S.T=in1.ts;
      S.M=[in1.a,in1.b;in1.c,in1.d];
      n = size(in1,'order');
      S.r{1}=1:n;
      S.r{4}=(n+1):(n+size(in1,1));
      S.c{1}=1:n;
      S.c{4}=(n+1):(n+size(in1,2));      
    elseif isnumeric(in1)
      % create static SSMODEL with only y/u
      S.M=full(in1);
      S.r{4}=1:size(in1,1);
      S.c{4}=1:size(in1,2);
    elseif ischar(in1)
      % create empty SSMODEL with name
      S.name=in1;
    else
      error('Wrong usage of ssmodel');
    end;
   case {2,3}
    if isa(varargin{2},'ssmodel')
      if varargin{1}==0
	% create empty SSMODEL with same dimensions
	S=varargin{2};
	S.name='';
	S.M=zeros(size(S.M,1),size(S.M,2),size(S.M,3));
	return;
      else
	error('Wrong usage of ssmodel');
      end
    elseif ischar(varargin{2})
      in1=varargin{1};
      switch lower(varargin{2}(1))
       case 'c'
	% create static SSMODEL with only y/u
	signal=4;
       case 'f'
	% create static SSMODEL with only z/w
	signal=3;
       case 'n'
	% create static SSMODEL with only zd/wd
	signal=2;
       otherwise
	error('Wrong usage of ssmodel');
      end
      if isa(in1,'lti') 
	in1=ss(in1);
	S.T=in1.ts;
	S.M=[in1.a,in1.b;in1.c,in1.d];
	n = size(in1,'order');
	S.r{1}=1:n;
	S.r{signal}=(n+1):(n+size(in1,1));
	S.c{1}=1:n;
	S.c{signal}=(n+1):(n+size(in1,2));      
      elseif isnumeric(in1)
	S.M=full(in1);
	S.r{signal}=1:size(in1,1);
	S.c{signal}=1:size(in1,2);	  
      else
	error('Wrong usage of ssmodel');
      end;
    else
      error('Wrong usage of ssmodel');
    end
    if nargin==3
      % add the specified name
      if ischar(varargin{3})
	S.name=varargin{3};
      else
	error('3rd input arg. expected to be a string');
      end
    else
      S.name='';
    end      
   case {7,8} 
    for ii=2:7
      if varargin{ii}==0
	varargin{ii}=[];
      end
    end
    in1=varargin{1};
    if isa(in1,'lti') 
      in1=ss(in1);
      S.T=in1.ts;
      S.M=[in1.a,in1.b;in1.c,in1.d];
      n = size(in1,'order');
      S.r{1}=1:n;
      S.r{2}=varargin{2}+n;
      S.r{3}=varargin{3}+n;
      S.r{4}=varargin{4}+n;
      S.c{1}=1:n;
      S.c{2}=varargin{5}+n;
      S.c{3}=varargin{6}+n;
      S.c{4}=varargin{7}+n;
    elseif isnumeric(in1)
      S.M=in1;
      S.r{2}=varargin{2};
      S.r{3}=varargin{3};
      S.r{4}=varargin{4};
      S.c{2}=varargin{5};
      S.c{3}=varargin{6};
      S.c{4}=varargin{7};
    else
      error('Wrong usage of ssmodel');
    end;
    if nargin==8
      % add the specified name
      if ischar(varargin{8})
	S.name=varargin{8};
      else
	error('8th input arg. expected to be a string');
      end
    end          
   case {9,10,11}    
    for ii=2:9
      if varargin{ii}==0
	varargin{ii}=[];
      end
    end
    if isnumeric(varargin{1})
      S.M=full(varargin{1});
      S.r{1}=varargin{2};
      S.r{2}=varargin{3};
      S.r{3}=varargin{4};
      S.r{4}=varargin{5};
      S.c{1}=varargin{6};
      S.c{2}=varargin{7};
      S.c{3}=varargin{8};
      S.c{4}=varargin{9};
    else
      error('Wrong usage of ssmodel');
    end;
    if nargin==10
      % add the specified name
      if ischar(varargin{10})
	S.name=varargin{10};
      else
	S.T=varargin{10};
      end
    end 
    if nargin==11
      S.T=varargin{10};
      % add the specified name
      if ischar(varargin{11})
	S.name=varargin{11};
      else
	error('11th input arg. expected to be a string');
      end
    end 
   otherwise
    error('Wrong usage of ssmodel');
  end
    
  % now check the obtained system is OK
  
  if max(S.r{1})>size(S.M,1)
    error('irrelevant data w.r.t. rows of dynamic eq. (nri)');
  elseif max(S.r{2})>size(S.M,1)
    error('irrelevant data w.r.t. to exogenous output (zdi)');
  elseif max(S.r{3})>size(S.M,1)
    error('irrelevant data w.r.t. to performance output (zi)');
  elseif max(S.r{4})>size(S.M,1)
    error('irrelevant data w.r.t. to measured output (yi)');
  elseif max(S.c{1})>size(S.M,2)
    error('irrelevant data w.r.t. to state vector (nci)');
  elseif max(S.c{2})>size(S.M,2)
    error('irrelevant data w.r.t. to exogenous input (wdi)');
  elseif max(S.c{3})>size(S.M,2)
    error('irrelevant data w.r.t. to disturbance input (wi)');
  elseif max(S.c{4})>size(S.M,2)
    error('irrelevant data w.r.t. to control input (ui)');
  end
  
  %  reshape N-D matrices to 3-D
  
  sM  = size(S.M);
  lsM = length(sM);
  if lsM>3
    reshapesize(1)=sM(1);
    reshapesize(2)=sM(2);
    reshapesize(3)=prod(sM(3:lsM));
    S.M=reshape(S.M,reshapesize);
  end
  S.nb=size(S.M,3);
  
  S=class(S,'ssmodel');

  