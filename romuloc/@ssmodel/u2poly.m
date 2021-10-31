function uso = u2poly(usi,type)
% U2POLY - Convert parallelotopes and intervals to polytopes
%   
%   uout = u2poly ( uin )
% 
% <uin> can be either an UNCERTAINTY or a USSMODEL object
% <uout> is exactly the same type of object and contains exactly the same
% data except that parallelotopic and/or interval definitions of
% uncertainty are converted to polytopes, i.e. a vertex based description.
% 
% SEE ALSO upoly, uparal, uinter  
  
%   This file is part of RoMulOC
%   Last Update 31-Jan-2005
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France
  
  uso=usi;
  switch type
      case 'interva'
          valmin=usi.M(:,:,1);
          valmax=usi.M(:,:,2);
          [ipar,jpar]=find(valmin-valmax);
          nbparam=length(ipar);
          if nbparam>7
              fprintf('Conversion is computing %i vertices\n',2^nbparam);
          end
          clear vtx
          vtx(:,:,1)=valmin;
          for ii=1:nbparam
              Mpar=valmax(ipar(ii),jpar(ii));
              vtx=addvtx(vtx,ipar(ii),jpar(ii),Mpar);
          end; 
          uso.M=vtx;
          uso.nb=size(uso.M,3);
      case 'paralle'
          nbaxes=usi.nb-1;
          if nbaxes>7
              fprintf('Conversion is computing %i vertices\n',2^nbaxes);	
          end
          clear vtx
          vtx(:,:,1)=usi.M(:,:,end);
          for ii=1:nbaxes
              vtx=addaxe(vtx,usi.M(:,:,ii));
          end; 
          uso.M=vtx;
          uso.nb=size(uso.M,3);
  end;
    
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
  vtx=reshape(vtx,size(vtx,1),size(vtx,2),2*nbvtx);