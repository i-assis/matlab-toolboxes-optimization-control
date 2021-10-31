function out = teststability(A,R)
% SSMODEL/TESTSTABILITY - tests if SSMODEL has poles in specified region
%
% out = teststability(sys,reg)
%
% If <sys> is an array of SSMODEL the test <out> is the vector of the size
% of the array with yes (1) / no (0) answers.
% 
% SEE ALSO region/teststability

%   This file is part of RoMulOC
%   Last Update 18-Oct-2012
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

A=A.M(A.r{1},A.c{1},:);
out = teststability(A,R);