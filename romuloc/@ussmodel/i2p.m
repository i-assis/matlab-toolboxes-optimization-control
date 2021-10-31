function quiz = i2p(usys,perf)
% I2P - Build robust impulse-to-peak control problem
%
% quiz = i2p(sys, perf)
%
% <sys> : a SSMODEL or USSMODEL object defining the system
%         for which H-infinity performance is requested
% <per> : an impulse-to-peak cost to be tested
%         if perf=0 (default) minimization is required.
% <quiz>: a CTRPB object that contains the specified problem
%         it may then be appended to add other performance objectives
%         (SEE ctrpb/plus)
%         and a method should be spcified (SEE ctrpb).
%         Finnally to solve the problem SEE ctrpb/solvesdp.
%
% SEE ALSO stability, dstability, h2, hinfty, ctrpb/plus, ctrpb/solvesdp

%   This file is part of RoMulOC
%   Last Update 5-Dec-2013
%   author : Dimitri Peaucelle, Maud Sevin, Philippe Speisser
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

if nargin == 1
  quiz = ctrpb(usys, 0, 'i2p');
else
  quiz = ctrpb(usys, perf,'i2p');
end

