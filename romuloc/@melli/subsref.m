function out = subsref(eli,S)
% MELLI/SUBSREF - overloaded
%   
% if eli is a MELLI object
% elli.X , elli.Y , elli.Z
% are the matrices used to define the set
% elli.real=1 if real valued set
%          =0 if complex valued
% 
% SEE ALSO MELLI
  
%   This file is part of RoMulOC
%   Last Update 31-Jan-2005
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France
  
  out=[];
  switch S(1).type
   case '.'
    switch lower(S(1).subs)
     case 'x'
      out=eli.X;
     case 'y'
      out=eli.Y;
     case 'z'
      out=eli.Z;
     case 'real'
      out=eli.real;
     otherwise
      help mepli/subsref
    end
   otherwise
    help melip/subsref
  end
