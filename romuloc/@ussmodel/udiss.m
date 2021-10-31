function usys = udiss(varargin)
% UNCERTAINTY/UDISS - Generate dissipative set including uncertainty
%
% usys = udiss(ussmodel)        delta = udiss(uncertainty)
%
% Tansforms the uncertainty or the uncertainty in an ussmodel into a
% {X,Y,Z}-disspitave uncertainty

%   This file is part of RoMulOC
%   Last Update 24-May-2011
%   author : Dimitri Peaucelle, Alberto Bortott
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France 


if ~isa(varargin{1},'ussmodel')
    error('wrong input argument, it must be or an USSMODEL or un UNCERTAINTY')
end

sys=varargin{1}.ssmodel;
uncert=varargin{1}.uncertainty;

if varargin{1}.type(1:3) == 'LFT'
    uncert=u2diss(uncert);
    usys=ussmodel(sys,uncert);
else
    error('the model must be LFT to be converted into {x,Y,Z}-dissipative uncertainties')
end
