function dout = upoly(din)
% UNCERTAINTY/UPOLY - Convert parallelotopic and interval blocks to polytopes
%   
%   deltapoly = upoly ( delta )
% 
% The resulting incertainty has the same block structure and contains
% exactly the same data, except that parallelotopic and interval block
% have been converted to poytopic blocks.
% 
% SEE ALSO upoly, uparal and uinter
  
%   This file is part of RoMulOC
%   Last Update 24-May-2011
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

  for blkidx=1:din.nbb
      switch din.constr{blkidx}(1:7)
        case 'interva'
            valmin=din.vtx{blkidx}(:,:,1);
            valmax=din.vtx{blkidx}(:,:,2);
            [ipar,jpar]=find(valmin-valmax);
            nbparam=length(ipar);
            if nbparam>11
                fprintf('Convertion is computing %i vertices\n',2^nbparam);
            end
            clear vtx
            vtx(:,:,1)=valmin;
            for ii=1:nbparam
                Mpar=valmax(ipar(ii),jpar(ii));
                vtx=addvtx(vtx,ipar(ii),jpar(ii),Mpar);
            end; 
            din.constr{blkidx}=sprintf('polytope %i vertices',2^nbparam);
            din.constrcode(blkidx)=10;
            din.vtx{blkidx}=vtx;
            blkpos=find(din.struc(1,:)==din.uindex(blkidx));
            din.uindex(blkidx) = uncertainty('modified: get new uindex');
            din.struc(1,blkpos)=din.uindex(blkidx);
        case 'paralle'
            nbaxes=size(din.vtx{blkidx},3)-1;
            if nbaxes>11
                fprintf('Convertion is computing %i vertices\n',2^nbaxes);
            end
            clear vtx
            vtx(:,:,1)=din.vtx{blkidx}(:,:,end);
            for ii=1:nbaxes
                vtx=addaxe(vtx,din.vtx{blkidx}(:,:,ii));
            end; 
            din.constr{blkidx}=sprintf('polytope %i vertices',2^nbaxes);
            din.constrcode(blkidx)=10;
            din.vtx{blkidx}=vtx;            
            blkpos=find(din.struc(1,:)==din.uindex(blkidx));
            din.uindex(blkidx) = uncertainty('modified: get new uindex');
            din.struc(1,blkpos)=din.uindex(blkidx);
    end;
  end;
  dout=din;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function vtx=addvtx(vtx,ipar,jpar,Mpar);
  nbvtx=size(vtx,3);
  vtx(:,:,:,2)=vtx(:,:,:,1);
  vtx(ipar,jpar,:,2)=Mpar*ones(1,nbvtx);
  vtx=reshape(vtx,size(vtx,1),size(vtx,2),2*nbvtx);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function vtx=addaxe(vtx,axe);
  nbvtx=size(vtx,3);
  axe=kron(ones(1,nbvtx),axe);
  axe=reshape(axe,size(vtx,1),size(vtx,2),nbvtx);
  vtx(:,:,:,2)=vtx(:,:,:,1)+axe;
  vtx(:,:,:,1)=vtx(:,:,:,1)-axe;  
  vtx=reshape(vtx,size(vtx,1),size(vtx,2),[]);

