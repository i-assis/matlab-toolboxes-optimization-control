function out = sfeedback(in1,in2,name)
% USSMODEL/SFEEDBACK - Same as ssmodel/sfeedback  
% but handles simultaneously the uncertainties
%   
% SEE ALSO ussmodel, certain, shape, feedback
      
%   This file is part of RoMulOC
%   Last Update 26-apr-2005
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

  if nargin<2
    error('must have at least two input agr.');
  end
  
  if isnumeric(in1)
    in1=ssmodel(in1);
    in1.Ts=in2.ssmodel.T;
    in1=ussmodel(in1,[]);
  elseif isnumeric(in2)
    in2=ssmodel(in2);
    in2.T=in1.ssmodel.T;
    in2.name = 'CONTROLLER';
    in2=ussmodel(in2,[]);
  end
    
  switch in1.type
   case 'certain'
    switch in2.type
     case 'LFT'
      out = sfeedback(in1.ssmodel,in2.ssmodel);
      out = ussmodel(out,in2.uncertainty);
     otherwise % poly, paral, or inter
      out = sfeedback(in1.ssmodel,in2.ssmodel);
      out = ussmodel(out,in2.uncertainty,in2.type,'OK');    
    end
   case 'LFT'
    switch in2.type
     case {'certain','LFT'}
      out = sfeedback(in1.ssmodel,in2.ssmodel);
      out = ussmodel(out,diag(in1.uncertainty,in2.uncertainty));
     otherwise % poly, paral, or inter
      error('Inputs cannot be USSMODELs of different types')    
    end
   otherwise % poly, paral, or inter
    switch in2.type
     case 'certain'
      out = sfeedback(in1.ssmodel,in2.ssmodel);
      out = ussmodel(out,in1.uncertainty,in1.type,'OK');       
     case 'LFT'
      error('Inputs cannot be USSMODELs of different types')    
     otherwise % poly, paral, or inter
      error(['Sorry but we did not implement this case where both inputs' ...
	     ' are polytopic, paralellotopic or interval USSMODELs']);
    end    
  end
  
  if nargin>2
    out.ssmodel.name=name;
  else
    out.ssmodel.name='';
  end
