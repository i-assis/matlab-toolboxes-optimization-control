function out = vtxofupoly(in)
% UNCERTAINTY/VTXOFUPOLY - Builds all vertices of uncertainty composed of
% several polytopic blocks
%   
% vtx = vtxofupoly(del)

%   This file is part of RoMulOC
%   Last Update 5-Jun-2013
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

% convert interval and parallelotopic blocks to polytopes
in=upoly(in);
for ii=1:in.nbb
  if in.constrcode~=10
    error('Only for uncertainties containing uinter, uparal and upoly blocks')
  end
end
vtx=zeros(in.size);
out=zeros(in.size(1),in.size(2),0);
iblk=0;
out=generateit(vtx,in,iblk,out);


function out=generateit(vtx,in,iblk,out);

  iblk=iblk+1;
  nbrepete = size(in.rows{iblk},2);
  rowsi      = reshape(in.rows{iblk}, 1, []);  
  Mrowsi     = sparse(rowsi,                 ...
		      1:length(rowsi),       ...
		      ones(1,length(rowsi)), ...
		      in.size(1),           ...
		      length(rowsi));
  Mrowsi=full(Mrowsi);
  colsi      = reshape (in.cols{iblk}, 1, []);
  Mcolsi     = sparse(1:length(colsi),       ...
		      colsi,                 ...
		      ones(1,length(colsi)), ...
		      length(colsi),         ... 
		      in.size(2));
  Mcolsi=full(Mcolsi);
        
  for ivtx=1:size(in.vtx{iblk} ,3 )
    vtxi = in.vtx{iblk}(:,:,ivtx);
    vtxi = kron( eye(nbrepete) , vtxi );
    vtxn = vtx + Mrowsi*vtxi*Mcolsi;
    if iblk==in.nbb
      out(:,:,end+1)=vtxn;
    else    
      out=generateit(vtxn,in,iblk,out);
    end
  end