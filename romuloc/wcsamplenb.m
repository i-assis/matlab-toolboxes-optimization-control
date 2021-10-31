function nb_sample=wcsamplenb(epsilon,delta);
% WCSAMPLENB - Number of samples for empirical performance level
%
% nb = wcsamplenb( epsilon, delta )
%
% The function is used for randomized analysis methods (SEE ctrpb)
%
% <nb> is the number of samples to be drawn in order to get an
% <epsilon>-close estimate of reliability of a worst case performance
% with violation probability of <delta>.
%
% In other words, if <wc_est> is the worst case estimate of a performance
% computed on <nb> independent and identically distributed samples 
% and <P> is the probability of an other sample to violate <wc_est>, then:
% Prob{ P < epsilon } < delta
% 
% SEE ALSO ctrpb, chernoff, ctrpb/solvesdp

%   This file is part of RoMulOC
%   Last Update 24-Oct-2012
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France 

nb_sample = ceil(log(1/delta)/log(1/(1-epsilon)));