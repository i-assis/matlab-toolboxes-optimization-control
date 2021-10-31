function [varargout] = romuloc(choice)
% ROMULOC - Demo examples for RoMulOC
%   
%  romuloc    : Introduction to RoMulOC and demonstration
%  romuloc(1) : analysis of an LFT-type uncertain system 
%  romuloc(2) : analysis of an interval-type uncertain system
%  romuloc(3) : state feedback design for an LFT uncertain system
%  romuloc(4) : state feedback design for a polytopic uncertain model
%

%   This file is part of RoMulOC
%   Last Update 5-Mar-2013
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

warning off
if nargin==0
  clc;
  fprintf('Welcome to the Robust MultiObjective Control toolbox\n\n');
  fprintf('For detailed information please\n');
  fprintf(' - refer to the users guide in the DOC directory\n');
  fprintf(' - contact the author D. Peaucelle at peaucelle@laas.fr\n\n');
  fprintf('\n%%%% -- press key --'),pause;
  clc;fprintf('\r  \n')
  fprintf('LICENCE AGREEMENT\n') 
  fprintf('RoMulOC and YALMIP (that you should have installed)\n')
  fprintf('are currently free of charge and openly distributed,\n');
  fprintf('but note that they are distributed in the hope that\n');
  fprintf('it will be useful, but WITHOUT ANY WARRANTY;\n')
  fprintf('without even the implied warranty of MERCHANTABILITY\n');
  fprintf('or FITNESS FOR A PARTICULAR PURPOSE\n')
  fprintf('(if your satellite crash or you fail your PhD\n');
  fprintf('due to a bug in RoMulOC or YALMIP, your loss!).\n\n')
  fprintf('RoMulOC and YALMIP may not be re-distributed as \n')
  fprintf('a part of a commercial product\n\n')
  fprintf('RoMulOC and YALMIP must be referenced when used in a published work\n')
  fprintf('see the users guide for references\n\n')
  fprintf('\n%%%% -- press key --'),pause;
  clc;
  fprintf('\r  \n')
  fprintf('Launch a RoMulOC demonstration example\n\n')
  fprintf('choose one among the two analysis problems with\n')
  fprintf('LFT uncertain (1) or affine polytopic (2) system models.\n');
  fprintf('or\n');
  fprintf('choose one among the two state feedback problems with\n')
  fprintf('LFT uncertain (3) or affine polytopic (4) system models.\n');
  fprintf('(type (0) to quit)\n')
  choice = input('Your choice : ');      
  if isempty(choice)
    choice=0;
  end
end
switch choice
 case 1
  romulocdemo1;
 case 2
  romulocdemo2;
 case 3
  romulocdemo3;
 case 4
  romulocdemo4;
end

fprintf('-- END --\n\n')
