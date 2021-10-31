function out = testi2p(sys,gamma,nb_samples,T)
% SSMODEL/TESTI2P - tests if SSMODEL has I2P performance below given level
%
% out = testi2p(sys,gamma)
%
% If <sys> is an array of SSMODEL the test <out> is the vector of the size
% of the array with yes (1) / no (0) answers.
% 
% out = testi2p(sys)
%
% Outputs the peaks for each system of the array.
%
% In case the system has a disturbance input of size greater than 1, a
% random linear combination of the inputs is applied.
%
% out = testi2p(sys,gamma,nb_samples)
% out = testi2p(sys,[],nb_samples)
%
% The outputs are after testing several random impulses
%
% out = testi2p(sys,gamma,nb_samples,T)
% out = testi2p(sys,[],nb_samples,T)
%
% The outputs are with simulations from t=0 to t=T
%
% SEE ALSO ssmodel/impulse

%   This file is part of RoMulOC
%   Last Update 19-May-2016
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

if nargin<4
    T=[];
end
if nargin<3
    nb_samples=1;
end
if nargin<2
    gamma=[];
end

out=zeros(sys.nb,1);
[sys,~,zi,~,~,wi,~,~]=ss(sys);
sys=sys(zi,wi);
for ii=1:size(sys,3)
    if size(sys,2)==1  
        imp=1;
    else
       imp=randn(size(sys,2),nb_samples);
       imp=imp./repmat(sqrt(sum(imp.^2)),size(sys,2),1);
    end    
    Y=impulse(sys(:,:,ii)*imp,T);
    out(ii)=max(max(sqrt(sum(Y.^2,2))));
end
if ~isempty(gamma)
    out=(out<gamma);
end





