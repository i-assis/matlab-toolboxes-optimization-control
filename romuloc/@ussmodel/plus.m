function out = plus(in1,in2,name)
% USSMODEL/PLUS - Same as ssmodel/plus  
% but handles simultaneously the uncertainties   
%  
% SEE ALSO certain, feedback, ussmodel   
        
%   This file is part of RoMulOC
%   Last Update 19-May-2011
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

  if nargin<2
    error('must have at least two input agr.');
  elseif nargin==2
    name='';
  end
  
  if isnumeric(in1)
    in1=ssmodel(in1);
    in1.Ts=in2.ssmodel.Ts;
    in1=ussmodel(in1,[]);
  elseif isa(in1,'ssmodel') & ~isa(in1,'ussmodel')
    in1=ussmodel(in1,[]);
  end 
  if isnumeric(in2)
    in2=ssmodel(in2);
    in2.Ts=in1.ssmodel.Ts;
    in2=ussmodel(in2,[]);
  elseif isa(in2,'lti')
    in2=ssmodel(in2);
    in2=ussmodel(in2,[]);
  elseif isa(in2,'ssmodel') & ~isa(in2,'ussmodel')
    in2=ussmodel(in2,[]);
  end
  
  switch in1.type
   case {'certain'}
    switch in2.type
     case 'LFT'
      out = plus(in1.ssmodel,in2.ssmodel,name);
      out = ussmodel(out,in2.uncertainty);
     otherwise % poly, paral, or inter
      out = plus(in1.ssmodel,in2.ssmodel,name);
      out = ussmodel(out,in2.uncertainty,in2.type,'OK');    
    end
   case 'LFT'
    switch in2.type
     case {'certain','LFT'}
      out = plus(in1.ssmodel,in2.ssmodel,name);
      out = ussmodel(out,diag(in1.uncertainty,in2.uncertainty));
     otherwise % poly, paral, or inter
      error('Inputs cannot be USSMODELs of different types')    
    end
   otherwise % poly, paral, or inter
    switch in2.type
     case 'certain'
      out = plus(in1.ssmodel,in2.ssmodel,name);
      out = ussmodel(out,in1.uncertainty,in1.type,'OK');       
     case 'LFT'
      error('Inputs cannot be USSMODELs of different types')    
     otherwise % poly, paral, or inter
      error(['Sorry but we did not implement this case where both inputs' ...
	     ' are polytopic, paralellotopic or interval USSMODELs']);
    end
  end
  
