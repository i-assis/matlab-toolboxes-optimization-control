function [sepvar,seplmi] = separator(delta,zerooflmis)
% SEPARATOR - Builds a quadratic separator variable and associated lmi constraints
%   
%  for internal use only

%   This file is part of RoMulOC
%   Last Update 7-Nov-2014
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

  % added on 7-nov-2014
  if nargin<2
      zerooflmis=0;
  elseif isempty(zerooflmis)
      zzerooflmis=0;
  end
  % initialize the lmi and the variable
  seplmi = lmi ;  
  sepvar = [];
  % convert first any parallelotopic and interval uncertainties to polytopes
  deltain = delta;
  delta = u2poly(delta);
  % get indices and dimensions of polytopic and dissipative blocks
  dblk = []; % indices of dissipative blocks 
  pblk = []; % indices of polytopic blocks
  pr = [];   % rows related to polytopic uncertainties (all)
  pc = [];   % columns related to polytopic uncertainties (all)
  for blkidx=1:delta.nbb
    switch delta.constr{blkidx}(1:7)
     case 'polytop'
      pblk(end+1) = blkidx;   
      blkpr = reshape(delta.rows{blkidx},1,[]);  
      pr((end+1):(end+length(blkpr))) = blkpr;
      blkpc = reshape(delta.cols{blkidx},1,[]);
      pc((end+1):(end+length(blkpc))) = blkpc;
     otherwise      
      dblk(end+1) = blkidx;
    end;
  end;
  % POLYTOPIC BLOCKS
  %%%%%%%%%%%%%%%%%%
  % Build the sdpvar related to the polytopic blocks
  if ~isempty(pr)
    nbpr = length(pr);
    nbpc = length(pc);
    pr = sort(pr);
    pc = sort(pc);
    Mrows = sparse(pr,           ...
		   1:nbpr,       ...
		   ones(1,nbpr), ...
		   delta.size(1),...
		   nbpr);    
    Mcols = sparse(pc,           ...
		   1:nbpc,       ...
		   ones(1,nbpc), ...
		   delta.size(2),...
		   nbpc);
    if delta.complex(blkidx)
      iscomplex='complex';
    else
      iscomplex='';
    end
    XsepPoly = sdpvar(nbpc, nbpc, 'hermitian',iscomplex);
    YsepPoly = sdpvar(nbpc, nbpr, 'full');    
    ZsepPoly = sdpvar(nbpr, nbpr, 'hermitian',iscomplex);    
    sepvar = [Mcols*XsepPoly*Mcols'  , Mcols*YsepPoly*Mrows';...
	      Mrows*YsepPoly'*Mcols' , Mrows*ZsepPoly*Mrows'];

    % Build constraints on ZsepPoly for multi-convexity
    for blkidx=pblk
      blkpr   = reshape(delta.rows{blkidx},1,[]);
      nbblkpr = length(blkpr);
      blkpr   = sort(blkpr);
      Mblk    = sparse(1:nbblkpr,      ...
		       blkpr,          ...
		       ones(1,nbblkpr),...
		       nbblkpr,        ...
		       delta.size(1));
      Tag     = sprintf('multi-conv : Zu%i>=0',deltain.uindex(blkidx));
      Zblk=Mblk*Mrows*ZsepPoly*Mrows'*Mblk';
      seplmi  = seplmi + tag(Zblk >= 0,Tag);
    end;
    % Build vertex constraints on XYZsepPoly
    if ~isempty(pblk)
      ipblk=1;
      vtx = sparse(nbpr,nbpc);
      nbvtx = 0 ;
      [seplmi,nbvtx] =...
	  vtxConstraints(vtx,delta,pblk,ipblk,XsepPoly,YsepPoly,ZsepPoly,Mrows,Mcols,seplmi,nbvtx);
    end;
  end;
  % DISSIPATIVE BLOCKS
  %%%%%%%%%%%%%%%%%%%%
  dblknb=0;
  for blkidx=dblk

    % Build the sdpvar related to the dissipative blocks
    
    dr = reshape(delta.rows{blkidx},1,[]);
    dc = reshape(delta.cols{blkidx},1,[]);
    nbdr = length(dr);
    nbdc = length(dc);
    dr = sort(dr);
    dc = sort(dc);
    Mrows = sparse(dr,           ...
		   1:nbdr,       ...
		   ones(1,nbdr), ...
		   delta.size(1),...
		   nbdr);    
    Mcols = sparse(dc,           ...
		   1:nbdc,       ...
		   ones(1,nbdc), ...
		   delta.size(2),...
		   nbdc);
    
    repeated = size(delta.rows{blkidx},2);
    isscalar = size(delta.rows{blkidx},1)==1 & size(delta.cols{blkidx},1)==1;
    
    Dscaling = sdpvar(repeated, repeated, 'symmetric');
    
    if any(any(delta.X{blkidx})), 
      XsepDiss = Mcols*kron(Dscaling,delta.X{blkidx})*Mcols';
    else
      XsepDiss = Mcols*zeros(size(Dscaling,1)*size(delta.X{blkidx},1),size(Dscaling,2)*size(delta.X{blkidx},2))*Mcols';
    end;
    if any(any(delta.Y{blkidx})), 
      YsepDiss = Mcols*kron(Dscaling,delta.Y{blkidx})*Mrows';
    else
      YsepDiss = Mcols*zeros(size(Dscaling,1)*size(delta.Y{blkidx},1),size(Dscaling,2)*size(delta.Y{blkidx},2))*Mrows';
    end;
    if any(any(delta.Z{blkidx})),
      ZsepDiss = Mrows*kron(Dscaling,delta.Z{blkidx})*Mrows';
    else
      ZsepDiss = Mrows*zeros(size(Dscaling,1)*size(delta.Z{blkidx},1),size(Dscaling,2)*size(delta.Z{blkidx},2))*Mrows';
    end;
    
    if repeated>1 & isscalar & ~delta.complex(blkidx)
      Gscaling = sdpvar(repeated, repeated, 'skew');
      YsepDiss = YsepDiss+Mcols*Gscaling*Mrows';
    end    
    
    if isempty(sepvar)
      sepvar = [XsepDiss, YsepDiss; YsepDiss', ZsepDiss];
    else
      sepvar = sepvar + [XsepDiss, YsepDiss; YsepDiss', ZsepDiss];
    end

    % constraints on the scaling for the dissipative block
    
    Tag = sprintf('Dscaling : Du%i>=0',deltain.uindex(blkidx));
    seplmi = seplmi + tag(Dscaling >= 0,Tag);
    
  end
  
  
%%%%%%%%%% local function %%%%%%%%%%%
  
  function [seplmi,nbvtx] = vtxConstraints(vtx,delta,pblk,ipblk,X,Y,Z,Mrows,Mcols,seplmi,nbvtx)
% vtxConstraints - internal function to generate vertices and constraints
%   
  
  iblk = pblk(ipblk);
  ipblk=ipblk+1;    

  nbrepete = size(delta.rows{iblk},2);
  
  rowsi      = reshape( delta.rows{iblk}, 1, []);  
  Mrowsi     = sparse(rowsi,                 ...
		      1:length(rowsi),       ...
		      ones(1,length(rowsi)), ...
		      delta.size(1),           ...
		      length(rowsi));
  
  colsi      = reshape ( delta.cols{iblk}, 1, []);
  Mcolsi     = sparse(1:length(colsi),       ...
		      colsi,                 ...
		      ones(1,length(colsi)), ...
		      length(colsi),         ... 
		      delta.size(2));
  
  for ivtx=1:size( delta.vtx{iblk} ,3 )
    vtxi = sparse( delta.vtx{iblk}(:,:,ivtx) );
    vtxi = kron( speye(nbrepete) , vtxi );
    vtxn = vtx + Mrows'*Mrowsi*vtxi*Mcolsi*Mcols;
    if ipblk>length(pblk)
      nbvtx = nbvtx + 1;
      Tag = sprintf('separate vertex %i',nbvtx);
      vtxSEPARATED = X+Y*vtxn+vtxn'*Y'+vtxn'*Z*vtxn ;
      seplmi = seplmi + tag(vtxSEPARATED <= 0,Tag);
    else    
      [seplmi,nbvtx]=vtxConstraints(vtxn,delta,pblk,ipblk,X,Y,Z,Mrows,Mcols,seplmi,nbvtx);
    end
  end;
    
    
  
  

  
