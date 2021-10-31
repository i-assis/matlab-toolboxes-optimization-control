function ok = isin(eli,M)
% MELLI/ISIN - test if matrix belongs to {X,Y,Z}-ellipsoid
%   
% isin(elli,M)
%  = 1 if matrix is in the MELLI set
%  = 0 otherwise
      
%   This file is part of RoMulOC
%   Last Update 31-Jan-2005
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France
  
  if size(M,1)~=size(eli.Z,1)
    ok=0;
  elseif size(M,2)~=size(eli.X,1)
    ok=0;
  elseif max(eig(eli.X+eli.Y*M+M'*eli.Y'+M'*eli.Z*M))>0
    ok=0;
  else
    ok=1;
  end
    
