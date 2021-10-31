function quiz = dstability(sys, reg)
% DSTABILITY - Build robust pole location control problem
%
% quiz = dstability(sys,reg)
%
% <sys> : a SSMODEL or USSMODEL object defining the system
%         for which pole location is requested
% <reg> : a REGION object describing the pole location region
% <quiz>: a CTRPB object that contains the specified problem
%         it may then be appended to add other performance objectives
%         (SEE ctrpb/plus)
%         and a method should be spcified (SEE ctrpb).
%         Finnally to solve the problem SEE ctrpb/solvesdp.
%
% SEE ALSO region, stability, hinfty, h2, i2p, ctrpb/plus, ctrpb/solvesdp

%   This file is part of RoMulOC
%   Last Update 5-Dec-2013
%   author : Dimitri Peaucelle, Maud Sevin, Philippe Speisser
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France
  
quiz = ctrpb(sys, reg, 'dstability');

