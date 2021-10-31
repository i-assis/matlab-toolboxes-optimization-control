function out = get(sys,info)
% SSMODEL/GET - get some data of a SSMODEL object
%  
% out = get(sys,info)   or    out = sys.info
%
%   <sys> is a SSMODEL object
%   <info> describes the desired data  
%  
%    =[] (default) : displays the help of SSMODEL/GET
%
%    ='name' : <out> is the name of the ssmodel 
%      
%    ='T' : <out> is the sample time of the system 
%                   or 0 if continuous time system  
%    ='n'   : <out> is the size of the state vector
%    ='md'  : <out> is the size of the exogenous input w
%    ='mw'  : <out> is the size of the perturbation input v
%    ='mu'  : <out> is the size of the command input u
%    ='pd'  : <out> is the size of the exogenous output z
%    ='pz'  : <out> is the size of the control output g
%    ='py'  : <out> is the size of the measure output y
%
%    ='nb'  : <out> is the number of ssmodel object in tha array
%
%    ='A'   : <out> is the A matrix
%    ='Bd'  : <out> is the Bd matrix
%    ...
%    ='Dyu' : <out> is the Dyu matrix
%
%   For arrays of SSMODELs the outputs are 3-D arrays, 
%   <sys.A(:,:,i)> is the A matrix of the i-th system.
%   The syntax <sys(i)> outputs the i-th SSMODEL
%   and <sys(i).A> is the same as <sys.A(:,:,i)>.
%  
% SEE ALSO ssmodel
  
%   This file is part of RoMulOC
%   Last Update 31-Jan-2005
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France
  
  out=[];
  if nargin<1
    error('not enough arguments');
  elseif ~isa(sys,'ssmodel')
    error('1st argument must be a SSMODEL object');
  elseif nargin<2
    info='no info';
  elseif ~ischar(info)
    error('2nd argument must be a string');
  end;
  S.type='.';
  S.subs=info;
  out=subsref(sys,S);
  
    
