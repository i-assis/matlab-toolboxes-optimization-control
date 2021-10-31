function out = subsref(usys,info)
% USSMODEL/SUBSREF - overloaded
%   
% Subs-references such as <usys.n> , <usys.A> or <usys(1)> 
% preform the same as SSMODEL/SUBSREF
% Moreover <usys.ssmodel> outputs the SSMODEL object.
%
% Subs-references such as <usys{i}> can be used for LFT models
% It performs the same as UNCERTAINTY/SUBREF
% Outputs the uncertainty composed only of the block index by <i>
%
% For LFT models <usys.uncertainty> 
% outputs the whole UNCERTAINTY object.
%
% <usys.type> output the type of USSMODEL object 
% among 'LFT', 'polytopic', 'parallelotopic' and 'interval'.
%  
% same as SSMODEL/GET and as UNCERTAINTY/SUBSREF
  
%   This file is part of RoMulOC
%   Last Update 31-Jan-2005
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

  out=[];
  switch info(1).type
   case '{}'
    out=subsref(usys.uncertainty,info);
   case '.'
    if isequal(info(1).subs,'uncertainty')
      out=usys.uncertainty;
    elseif isequal(info(1).subs,'ssmodel')
      out=usys.ssmodel;
    elseif isequal(info(1).subs,'type')
      out=usys.type;
    else
      out=subsref(usys.ssmodel,info);
    end
   otherwise
    out=subsref(usys.ssmodel,info);
  end

