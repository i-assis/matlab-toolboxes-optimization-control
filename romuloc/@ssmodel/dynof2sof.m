function [syso,ko] = dynof2sof(sysi,ki)
%DYNOF2SOF - Augment model to convert dynamic feedback to static feedback
%
% ssmout = dyof2sof(ssmin,order)
%
% <ssmin> is a SSMODEL object
% <order> is the order of the dynamic output feedback
%
% [ssmout,kout] = dyof2sof(ssmin,kin)
%
% <kin> SSMODEL of a dynamic controller
% <kout> Static gain of the conrresponding SOF problem
%
% SEE ALSO ssmodel  
     
%   This file is part of RoMulOC
%   Last Update 2-Mar-2011
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

ko=[];

if isnumeric(ki)
    nk=ki;
else
    nk=get(ki,'n');
    ko=get(ki,'allmatrices');
end

syso=ssmodel;
syso.T=sysi.T;
syso.nb=sysi.nb;
if ~isempty(sysi.name)
    syso.name=[sysi.name ' AUGMENTED BY DYNOF2SOF'];
end
maxr = max([0, sysi.r{1}, sysi.r{2}, sysi.r{3}, sysi.r{4} ]);
maxc = max([0, sysi.c{1}, sysi.c{2}, sysi.c{3}, sysi.c{4} ]);
syso.M = sysi.M;
syso.M(maxr+nk,maxc+nk,1)=0;
syso.r{1}=[maxr+(1:nk),sysi.r{1}];
syso.c{1}=[maxc+(1:nk),sysi.c{1}];
syso.M(maxr+(1:nk),maxc+nk+(1:nk),:)=repmat(eye(nk),[1 1 sysi.nb]);
syso.c{4}=[maxc+nk+(1:nk),sysi.c{4}];
syso.M(maxr+nk+(1:nk),maxc+(1:nk),:)=repmat(eye(nk),[1 1 sysi.nb]);
syso.r{4}=[maxr+nk+(1:nk),sysi.r{4}];
