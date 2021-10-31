function [xi,iswc,syswc] = extractwc(quiz,usys)
% CTRPB/EXTRACTWC - Extract worst case uncertainty basd on LMI duality
%   
% Since November 2012 this function is for internal use only
%
% SEE ctrpb/solvesdp

% [xi,iswc,syswc] = extractwc(quiz,usys)
%
%   INPUT
%     quiz : a CTRPB object (SEE ctrpb) that has been solved
%     usys : polytopic USSMODEL for which the quiz was build
%
%   OUTPUT
%     xi : guess worst case linear combination of vertices
%     iswc : true if worst case is indeed found
%     syswc : guess of worst case system in polytope
%
%   Compuation is done with QUADPROG
%
%   SEE ALSO ctrpb, solvesdp, sdpsettings

%   This file is part of RoMulOC
%   Last Update 12-Nov-2013
%   author : Dimitri Peaucelle, Yoshio Ebihara
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

iswc=0;

forWC = quiz.forWC;
idxnz = any(forWC,1);
forWC = forWC(:,idxnz);

Dualvars =[];
for ii=1:size(forWC,1)
  Dualvartmp=[];
  for jj=1:size(forWC,2)
    Dualvartmp=[Dualvartmp;reshape(dual(quiz.lmi(forWC(ii,jj))),[],1)];
  end
    Dualvars(:,end+1)=Dualvartmp;
end

H = sum(Dualvars,2);

[xi,fval] = quadprog(H'*H*eye(size(forWC,1)),...
              -Dualvars'*H,...
              [],...
              [],...
              ones(1,size(forWC,1)),...
              1,...
              0,...
              1,...
              1/size(forWC,1)*ones(size(forWC,1),1),...
              optimset('Display','off'));

if abs(fval+norm(Dualvars,2)^2/2)<1e-4
  iswc=1;
end
            
if nargin==2
  usys=upoly(usys);
  syswc = certain(usys.ssmodel,xi,[usys.name,'- maybe WCase'],'pol');
else
  syswc = [];
end