function OIOout = oio(n1,n2,n3)
% OIO - create a matrix such as [ O I O ] with given dimensions
%   
%  OIOout = oio(n1,n2,n3)
%  
%  the created matrix is sparse such as
%  [ zeros(n2,n1) , eye(n2) , zeros(n2,n3) ]
  
%   This file is part of RoMulOC 
%   Last Update 31-Jan-2005
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

OIOout=sparse( 1:n2 , ...
	       n1+(1:n2) , ...
	       ones(1,n2) , ...
	       n2 , ...
	       n1+n2+n3 );
