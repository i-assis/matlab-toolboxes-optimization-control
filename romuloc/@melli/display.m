function display(eli)
% MELLI/DISPLAY - overloaded
%   
      
%   This file is part of RoMulOC
%   Last Update 31-Jan-2005
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France
  
  if all([isreal(eli.X) isreal(eli.Y) isreal(eli.Z)])
    fprintf('{X,Y,Z}-ellipsoid of real valued %i x %i matrices\n',...
	    size(eli.Z,1),size(eli.X,1));
  else
    fprintf('{X,Y,Z}-ellipsoid of complex valued %i x %i matrices\n',...
	    size(eli.Z,1),size(eli.X,1));
  end
