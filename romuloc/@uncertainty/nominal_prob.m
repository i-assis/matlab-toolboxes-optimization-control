function out = nominal_prob(in)
% UNCERTAINTY/NOMINAL_PROB - Outputs the nominal value of an uncertainty
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
% If the object combines different types of uncertainties, sampling does
% not work the same. Here are the different case.
tobesampled=find((in.distribution>1).*(~in.sampled));
for ii=tobesampled % operate ony on those uncertainties that where identified to be sampled
  in.sampled(ii)=1;
	in.usample{ii}=in.nominal{ii};
end
if all(in.sampled)
  out=[];
  for ii=1:size(in.struc,2)
    out=blkdiag3d(out,in.usample{in.struc(2,ii)});
  end
else
  out=in;
end







