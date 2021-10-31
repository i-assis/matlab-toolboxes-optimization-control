function [nbvars,nbrows] = size(quiz)
% SIZE - get number of variables and rows in CTRPB object - OVERLOADED
%
% [nbvars,nbrows] = size(quiz)
%
% SEE ALSO ctrpb

%   This file is part of RoMulOC
%   Last Update 20-Nov-2012
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

nbvars=length(getvariables(quiz));
info=lmiinfo(quiz);
nbrows=sum(info.sdp(:,1));