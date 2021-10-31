function out = plus(in1,in2,name)
% SSMODEL/PLUS - Add two systems
%   
% out = plus( in1 , in2 , name ); 	
%             _____           
%       zd1<-|     |<- wd1    
%       z1 <-| in1 |<- w1     
%    -- y1 <-|_____|<- u1=u --
%    |        _____          |
% y<-+  zd2<-|     |<- wd2   |<--u
%    |  z2 <-| in2 |<- w2    |
%    -- y2 <-|_____|<- u2=u --
%
% gives the system with concatenated 
% performance and exogenous outputs/inputs
%                      _____
% zd=[ zd2' zd1' ]' <-|     |<- wd=[ wd2' wd1' ]'
% z =[ z2'  z1'  ]' <-| out |<- w =[ w2'  w1'  ]'
% y =  y1+y2        <-|_____|<- u = u1 = u2
%	               
% Either <in1> or <in2> can be matrices.
% If <in1> and <in2> are arrays, 'plus' is performed element-wise. 
% If only one is an array, 'plus' is performed for all its elements.
%
% <name> is an optionnal string to give a name to the resulting system   
%  
% SEE ALSO certain, feedback, ssmodel, mtimes   
      
%   This file is part of RoMulOC
%   Last Update 16-May-2011
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France
  
  % tets all input arg.
  
  if nargin<2
    error('must have at least two input agr.');
  elseif nargin==2
    name='';
  end
  
  if isa(in2,'ussmodel')
    in1=ussmodel(in1,[]);
    out = plus(in1,in2);
  elseif isnumeric(in2)
    in2=ssmodel(in2,'control');
    in2.T=in1.T;
    out = plus(in1,in2);
  elseif isa(in2,'lti')
    in2=ssmodel(in2,'control');
    out = plus(in1,in2);
  elseif ~isa(in2,'ssmodel')
    error('First convert the 2nd input arg. to SSMODEL')
  else
    if isnumeric(in1)
      in1=ssmodel(in1,'control');
      in1.T=in2.T;
    elseif isa(in1,'lti')
      in1=ssmodel(in1,'control');
    end
    if in1.nb>1 & in2.nb>1
      if in1.nb-in2.nb
    	error('Inputs are arrays with incompatible dimensions');
      end
    end
    if in1.T ~= in2.T
      error('The two input arg. must have same sample time');
    end
    if length(in1.c{4})~=length(in2.c{4})
      error('input signal dimensions do not fit');
    end    
    if length(in1.r{4})~=length(in2.r{4})
      error('output signal dimensions do not fit');
    end    
        
    % now the computation begins
    
    out = ssmodel;
    
    if nargin > 2
      out.name = name;
    else
      out.name = '';
    end
    
    out.T=in1.T;
    
    modnb = max(in1.nb,in2.nb);  
    out.nb=modnb;  
  
    r1  = in1.r{4};
    lr1 = length(r1);
    c1  = in1.c{4};
    lc1 = length(c1);
    r2  = in2.r{4};
    lr2 = length(r2);
    c2  = in2.c{4};
    lc2 = length(c2);
    
    tr1  = [in1.r{1} in1.r{2} in1.r{3}];
    ltr1 = length(tr1);
    tr2  = [in2.r{1} in2.r{2} in2.r{3}];
    ltr2 = length(tr2);
    tc1  = [in1.c{1} in1.c{2} in1.c{3}];
    ltc1 = length(tc1);
    tc2  = [in2.c{1} in2.c{2} in2.c{3}];
    ltc2 = length(tc2);
    
    m1r  = 1:ltr2;
    m1c  = 1:ltc2;
    m2r  = (1+ltr2):(ltr1+ltr2);
    m2c  = (1+ltc2):(ltc1+ltc2);
    m3r  = (1+ltr1+ltr2):(ltr1+ltr2+lr1);
    m3c  = (1+ltc1+ltc2):(ltc1+ltc2+lc2);
    
    for ii=1:modnb
      i1 = min(ii,in1.nb);
      i2 = min(ii,in2.nb);
      
      out.M(m1r,m1c,ii) = in2.M(tr2,tc2,i2);
      out.M(m1r,m3c,ii) = in2.M(tr2,c2,i2);
      
      out.M(m2r,m2c,ii) = in1.M(tr1,tc1,i1);
      out.M(m2r,m3c,ii) = in1.M(tr1,c1,i1);
      
      out.M(m3r,m1c,ii) = in2.M(r2,tc2,i2);
      out.M(m3r,m2c,ii) = in1.M(r1,tc1,i1);
      out.M(m3r,m3c,ii) = in1.M(r1,c1,i1)+in2.M(r2,c2,i2);
    end
    
    lastr2=0;lastr1=ltr2;
    lastc2=0;lastc1=ltc2;
    for ii=[1 2 3]
      out.r{ii} = [ (1+lastr2):(lastr2+length(in2.r{ii})) , (1+lastr1):(lastr1+length(in1.r{ii})) ];
      lastr2 = lastr2+length(in2.r{ii});
      lastr1 = lastr1+length(in1.r{ii});
      out.c{ii} = [ (1+lastc2):(lastc2+length(in2.c{ii})) , (1+lastc1):(lastc1+length(in1.c{ii})) ];
      lastc2 = lastc2+length(in2.c{ii});
      lastc1 = lastc1+length(in1.c{ii});
    end
    out.r{4} = (1+lastr1):(lastr1+lr1);
    out.c{4} = (1+lastc1):(lastc1+lc2);
    
  end
  
  
