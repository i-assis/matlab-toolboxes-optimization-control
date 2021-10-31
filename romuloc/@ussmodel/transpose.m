function uso = transpose(usi)
% USSMODEL/TRANSPOSE - transpose the USSMODEL object
%   
% syst=transpose(sys)  -or-  syst=sys.'
%
% Builds the transposed model wdith
% SSMODEL/TRANSPOSE for the LTI part of the model
% UNCERTAINTY/TRANSPOSE for the uncertainty in case of LFT models  
%  
% SEE ALSO ssmodel  
  
%   This file is part of RoMulOC
%   Last Update 31-Jan-2005
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

  uso=ussmodel;
  uso.ssmodel=usi.ssmodel.';
  uso.uncertainty=usi.uncertainty.';
  uso.type=usi.type;
