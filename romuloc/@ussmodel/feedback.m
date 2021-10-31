function out = feedback(in1,in2,name)
% USSMODEL/FEEDBACK - Same as ssmodel/feedback  
% but handles simultaneously the uncertainties
%   
% SEE ALSO ussmodel, certain, shape
      
%   This file is part of RoMulOC
%   Last Update 20-Feb-2009
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
  elseif ~isa(in1,'ussmodel')
    in1=ussmodel(in1,[]);
  end
  if isnumeric(in2)
    in2=ssmodel(in2);
    in2.Ts=in1.ssmodel.Ts;
    in2=ussmodel(in2,[]);
  elseif ~isa(in2,'ussmodel')
    in2=ssmodel(in2);    
    in2.Ts=in1.ssmodel.Ts;
    in2=ussmodel(in2,[]);
  end
    
  type1=in1.type;
  type1=type1(1:3);
  type2=in2.type;
  type2=type2(1:3); 
  
  switch type1
   case 'cer'
    switch type2
     case 'LFT'
      out = feedback(in1.ssmodel,in2.ssmodel,name);
      out = ussmodel(out,in2.uncertainty);
     case 'par'
      in1tmp = ssmodel(0,in1.ssmodel);
      in1tmp(in2.ssmodel.nb) = in1.ssmodel;
      out = feedback(in1tmp,in2.ssmodel,name);
      out = ussmodel(out,in2.uncertainty,in2.type,'OK');    
     otherwise % paral, or inter
      out = feedback(in1.ssmodel,in2.ssmodel,name);
      out = ussmodel(out,in2.uncertainty,in2.type,'OK');    
    end
   case 'LFT'
    switch type2
     case {'cer','LFT'}
      out = feedback(in1.ssmodel,in2.ssmodel,name);
      out = ussmodel(out,diag(in1.uncertainty,in2.uncertainty));
     otherwise % poly, paral, or inter
      error('Inputs cannot be USSMODELs of different types')    
    end
   case 'par'
    switch type2
     case 'cer'
      in2tmp = ssmodel(0,in2.ssmodel);
      in2tmp(in1.ssmodel.nb) = in2.ssmodel;
      out = feedback(in1.ssmodel,in2tmp,name);
      out = ussmodel(out,in1.uncertainty,in1.type,'OK');    
     case 'LFT'
      error('Inputs cannot be USSMODELs of different types')    
     otherwise % poly, paral, or inter
      error(['Sorry but we did not implement this case where both inputs' ...
	     ' are polytopic, paralellotopic or interval USSMODELs']);
    end
   otherwise % poly or inter
    switch type2
     case 'cer'
      out = feedback(in1.ssmodel,in2.ssmodel,name);
      out = ussmodel(out,in1.uncertainty,in1.type,'OK');       
     case 'LFT'
      error('Inputs cannot be USSMODELs of different types')    
     otherwise % poly, paral, or inter
      error(['Sorry but we did not implement this case where both inputs' ...
	     ' are polytopic, paralellotopic or interval USSMODELs']);
    end    
  end
  
