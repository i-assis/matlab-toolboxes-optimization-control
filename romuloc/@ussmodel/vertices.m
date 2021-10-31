function so = vertices(usi)
% VERTICES - generate array of SSMODELS containing all vertices
%   
%   vsys = vertices ( usys )
% 
% SEE ALSO upoly, uparal and uinter
  
%   This file is part of RoMulOC
%   Last Update 31-Jan-2005
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

  so = u2poly(usi);
  so = so.ssmodel;
