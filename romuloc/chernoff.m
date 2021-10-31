function nb_sample=chernoff(epsilon,delta);
% CHERNOFF - Additive Chernoff bound 
%
% nb = chernoff( epsilon, delta )
%
% The function is used for randomized analysis methods (SEE ctrpb)
%
% <nb> is the number of samples to be drawn in order to get an
% <epsilon>-close estimate of reliability 
% with violation probability of <delta>. 
%
% In other words, if <P> is the true
% probability of a performance to be satisfied and <P_est> is the
% probability estimate computed on <nb> independent and identically
% distributed samples, then: Prob{ |P-P_est|>epsilon } < delta
%
% SEE ALSO ctrpb, ctrpb/solvesdp, wcsamplenb

%   This file is part of RoMulOC
%   Last Update 24-Oct-2012
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France 

nb_sample=ceil(inv(2*epsilon^2)*log(2/delta));