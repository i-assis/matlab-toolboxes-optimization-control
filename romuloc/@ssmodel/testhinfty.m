function out = testhinfty(sys,gamma)
% SSMODEL/TESTHINFTY - tests if SSMODEL has Hinfty norm below given level
%
% out = testhinfty(sys,gamma)
%
% If <sys> is an array of SSMODEL the test <out> is the vector of the size
% of the array with yes (1) / no (0) answers.
% 
% out = testhinfty(sys)
%
% Same as <norm(sys,Inf)> 
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

if nargin<2
    gamma=[];
end
if isempty(gamma)
    out = norm(sys,Inf,1e-4);
else
   out = norm(sys,Inf,1e-4);
   out=(out<gamma);
end