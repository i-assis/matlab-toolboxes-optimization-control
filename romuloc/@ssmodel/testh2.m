function out = testh2(sys,gamma)
% SSMODEL/TESTH2 - tests if SSMODEL has H2 norm below given level
%
% out = testh2(sys,gamma)
%
% If <sys> is an array of SSMODEL the test <out> is the vector of the size
% of the array with yes (1) / no (0) answers.
% 
% out = testh2(sys)
%
% Same as <norm(sys,2)> 
%
% SEE ALSO ssmodel/norm

%   This file is part of RoMulOC
%   Last Update 19-Oct-2012
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

% at this stage I did not code the simple case of testing the Hinfty norm,
% it's computed using the control toolbox and compared to gamma... (can be
% made faster)

out = norm(sys,2);
if nargin==2
  out=(out<gamma);
end