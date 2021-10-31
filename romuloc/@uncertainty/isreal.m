function ok = isreal(delta,ii)
% UNCERTAINTY/ISREAL - Tells if an uncertain block is real valued 
%   
% ok = isreal(delta,i)
%
% <delta> is an uncertainty object
% <i> is the index of the block to test 
% ok=1 if i-th block is real-valued
% ok=0 if it is complex valued
  
%   This file is part of RoMulOC
%   Last Update 18-Oct-2005
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

  ok = ~delta.complex(i);
