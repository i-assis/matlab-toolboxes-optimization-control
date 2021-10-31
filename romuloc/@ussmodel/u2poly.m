function uso = u2poly(usi)
% U2POLY - Convert parallelotopic and interval systems to polytopic
%   
%   usyspoly = u2poly ( usys )
% 
% The resulting system has the same dimension and contains
% exactly the same data, except that parallelotopic or 
% interval modeling has been converted to poytopic.
% 
% SEE ALSO upoly, uparal and uinter
  
%   This file is part of RoMulOC
%   Last Update 7-Feb-2007
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

  switch usi.type(1:3)
      case 'int'   
          sys = u2poly(usi.ssmodel,'interva');
          if ~isempty(sys)
              uso = upoly(sys);
          else
              uso=[];
          end
      case 'par'
          sys = u2poly(usi.ssmodel,'paralle');
          if ~isempty(sys)
              uso = upoly(sys);
          else
              uso=[];
          end
      case 'pol'
          uso = usi;
      case 'LFT'
          uso = ussmodel(usi.ssmodel,u2poly(usi.uncertainty));
      otherwise
          error('Appropriate only for interval and parallelotopic USSMODEL objects');
  end;
