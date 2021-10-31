function quiz = hinfty(sys,perf)
% HINFTY - Build robust H-infinity control problem
%
% quiz = hinfty(sys, perf)
%
% <sys> : a SSMODEL or USSMODEL object defining the system
%         for which H-infinity performance is requested
% <per> : an H-infinity cost to be tested
%         if perf=0 (default) minimization is required.
% <quiz>: a CTRPB object that contains the specified problem
%         it may then be appended to add other performance objectives
%         (SEE ctrpb/plus)
%         and a method should be spcified (SEE ctrpb).
%         Finnally to solve the problem SEE ctrpb/solvesdp.
%
% SEE ALSO stability, dstability, h2, i2p, ctrpb/plus, ctrpb/solvesdp

%   This file is part of RoMulOC
%   Last Update 5-Dec-2013
%   author : Dimitri Peaucelle, Maud Sevin, Philippe Speisser
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

if nargin == 1
  quiz = ctrpb(sys, 0, 'hinfty');
else
  quiz = ctrpb(sys, perf,'hinfty');
end