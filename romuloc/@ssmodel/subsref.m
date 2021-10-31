function out = subsref(sys,info)
% SSMODEL/SUBSREF - get some data of a SSMODEL object
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
%    ='T' or 'Ts' : <out> is the sample time of the system 
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
%    ='allmatrices'
%	    : <out> is the 'system' matrix such that
%	      = [ A,Bd,Bw,Bu ; Cd,Ddd , etc , Dyw,Dyu ]
%
%    ='nb'  : <out> is the number of elements in arrays of SSMODEL
%
%   For arrays of SSMODELs the outputs are 3-D arrays, 
%   <sys.A(:,:,i)> is the A matrix of the i-th system.
%   The syntax <sys(i)> outputs the i-th SSMODEL
%   and <sys(i).A> is the same as <sys.A(:,:,i)>.
%  
% SEE ALSO ssmodel
  
%   This file is part of RoMulOC
%   Last Update 6-Jun-2005
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France
  
  out=[];
  switch info(1).type
   case '{}'
   case '()'
    out=sys;
    if length(info(1).subs)>1
      error('cannot handle SSMODEL arrays with more than 1 dimension');
    end
    out.M=sys.M(:,:,info(1).subs{1});
    out.nb=length(info(1).subs{1});
   case '.'
    switch lower(info(1).subs)
     case 'name'
      out=sys.name;
     case {'t','ts'}
      out=sys.T;
     case 'a'
      out=sys.M(sys.r{1},sys.c{1},:);
     case 'bd'
      out=sys.M(sys.r{1},sys.c{2},:);
     case 'bw'
      out=sys.M(sys.r{1},sys.c{3},:);
     case {'bu','b'}
      out=sys.M(sys.r{1},sys.c{4},:);
     case 'cd'
      out=sys.M(sys.r{2},sys.c{1},:);
     case 'ddd'
      out=sys.M(sys.r{2},sys.c{2},:);
     case 'ddw'
      out=sys.M(sys.r{2},sys.c{3},:);
     case {'dwu','ddu'}
      out=sys.M(sys.r{2},sys.c{4},:);
     case 'cz'
      out=sys.M(sys.r{3},sys.c{1},:);
     case 'dzd'
      out=sys.M(sys.r{3},sys.c{2},:);
     case 'dzw'
      out=sys.M(sys.r{3},sys.c{3},:);
     case 'dzu'
      out=sys.M(sys.r{3},sys.c{4},:);
     case {'cy','c'}
      out=sys.M(sys.r{4},sys.c{1},:);
     case 'dyd'
      out=sys.M(sys.r{4},sys.c{2},:);
     case 'dyw'
      out=sys.M(sys.r{4},sys.c{3},:);
     case {'dyu','d'}
      out=sys.M(sys.r{4},sys.c{4},:);
     case 'n'
      out=max(length(sys.c{1}),length(sys.r{1}));
     case 'md'
      out=length(sys.c{2});
     case 'mw'
      out=length(sys.c{3});
     case 'mu'
      out=length(sys.c{4});
     case 'pd'
      out=length(sys.r{2});
     case 'pz'
      out=length(sys.r{3});
     case 'py'
      out=length(sys.r{4});
     case 'nb'
      out=sys.nb;
     case 'allmatrices'
      out=sys.M([sys.r{1},sys.r{2},sys.r{3},sys.r{4}],...
		[sys.c{1},sys.c{2},sys.c{3},sys.c{4}],:);
     case 'vr' % Outputs vector r
      out=sys.r;
     case 'vc'
      out=sys.c;
     case 'vm'
      out=sys.M;
     case 'mn'
      out=sys.Mn;      
     otherwise      
      error('not admissible subref')
      help ssmodel/get
    end
   otherwise
    error('not admissible subref')
    help ssmodel/get
  end;

  if numel(info)>1
    out=subsref(out,info(2:end));
  end      

    
