function quiz = h2(sys,perf)
% H2 - Build robust H2 control problem
%
% quiz = h2(sys, perf)
%
% <sys> : a SSMODEL or USSMODEL object defining the system
%         for which H2 performance is requested
% <per> : an H2 cost to be tested
%         if perf=0 (default) minimization is required.
% <quiz>: a CTRPB object that contains the specified problem
%         it may then be appended to add other performance objectives
%         (SEE ctrpb/plus)
%         and a method should be spcified (SEE ctrpb).
%         Finnally to solve the problem SEE ctrpb/solvesdp.
%
% SEE ALSO stability, dstability, hinfty, i2p, ctrpb/plus, ctrpb/solvesdp

%   This file is part of RoMulOC
%   Last Update 5-Dec-2013
%   author : Dimitri Peaucelle, Maud Sevin, Philippe Speisser
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

if nargin == 1
  quiz = ctrpb(sys, 0, 'h2');
else
  quiz = ctrpb(sys, perf,'h2');
end
