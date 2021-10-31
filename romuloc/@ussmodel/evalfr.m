function out = evalfr(in1,s,name)
% USSMODEL/EVALFR - Same as ssmodel/evalfr  
% but handles simultaneously the uncertainties
%
% SEE ALSO ussmodel, ssmodel/certain, ssmodel/feedback
  
%   This file is part of RoMulOC
%   Last Update 22-January-2012
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
  
    
  type1=in1.type;
  type1=type1(1:3);
  
  
  switch type1
   
     case 'LFT'
      [out,dome] = evalfr(in1.ssmodel,s,name);
      delta=diag(in1.uncertainty,dome);
      out = ussmodel(out,delta);
     
     otherwise % poly
      error('Sorry not applicable to polytopic systems')
     end
   