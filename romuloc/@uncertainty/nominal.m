function out = nominal(in)
% UNCERTAINTY/NOMINAL - Outputs the nominal value of an uncertainty
%   
% val_nom = nominal(uset)
%
% <uset> is a UNCERTAINTY object
% <value> is a matrix (DOUBLE) that is defined as the nominal value of the
% uncertainty
%
% SEE ALSO uncertainty, unb, upos, udiss, uinter, uparal, upoly
  
%   This file is part of RoMulOC
%   Last Update 23-May-2013
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

out=[];
for ii=1:size(in.struc,2)
  out=blkdiag(out,in.nominal{in.struc(2,ii)});
end