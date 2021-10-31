function syso = ctranspose(sysi)
% SSMODEL/CTRANSPOSE - conjugate transpose the SSMODEL object
%   
% syst=ctranspose(sys)  -or-  syst=sys'
%
%    same as SS/TRANSPOSE
%    converts the system [A,B;C,D]
%    into [A',C';B',D']
% 
% SEE ALSO ssmodel, ssmodel/transpose  
  
%   This file is part of RoMulOC
%   Last Update 26-Aug-2013
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France
  
  syso=ssmodel;
  for ii=1:4
    syso.r{ii,1}=sysi.c{ii,1};
    syso.c{ii,1}=sysi.r{ii,1};
  end
  syso.M=conj(permute(sysi.M,[2 1 3]));
  syso.T=sysi.T;
  syso.nb=sysi.nb;
  if ~isempty(sysi.name)
    syso.name=[sysi.name ' C-TRANSPOSED'];
  end