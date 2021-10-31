function out = mtimes(in1,in2,name)
% USSMODEL/MTIMES - Same as ssmodel/mtimes  
% but handles simultaneously the uncertainties   
%  
% SEE ALSO certain, feedback, ussmodel   
        
%   This file is part of RoMulOC
%   Last Update 23-May-2013
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

  if nargin<2
    error('must have at least two input agr.');
  end
  if size(in1,2)==1 && size(in2,1)>1
    in1=in1*eye(size(in2,1));
  elseif size(in1,2)>1 && size(in2,1)==1
    in2=eye(size(in1,2))*in2;
  end
  if isnumeric(in1)
    in1=ssmodel(in1,'control');
    in1.Ts=in2.ssmodel.Ts;
  elseif isa(in1,'lti')
    in1=ssmodel(in1,'control');
  end
  if ~isa(in1,'ussmodel')
    in1=ussmodel(in1,[]);
  end
  if isnumeric(in2)
    in2=ssmodel(in2,'control');
    in2.Ts=in1.ssmodel.Ts;
  elseif isa(in2,'lti')
    in2=ssmodel(in2,'control');
  end
  if ~isa(in2,'ussmodel')
    in2=ussmodel(in2,[]);
  end
  if ~isempty(in1.ssmodel.name) & ~isempty(in2.ssmodel.name)
    name=sprintf('%s * %s',in1.ssmodel.name,in2.ssmodel.name);
  else
    name='';
  end

  type1=in1.type;
  type1=type1(1:3);
  type2=in2.type;
  type2=type2(1:3); 
  
  switch type1
   case 'cer'
    switch type2
     case 'LFT'
      out = mtimes(in1.ssmodel,in2.ssmodel,name);
      out = ussmodel(out,in2.uncertainty);
     case 'par'
      in1tmp = ssmodel(0,in1.ssmodel);
      in1tmp(in2.ssmodel.nb) = in1.ssmodel;
      out = mtimes(in1tmp,in2.ssmodel,name);
      out = ussmodel(out,in2.uncertainty,in2.type,'OK');    
     otherwise % poly, or inter
      out = mtimes(in1.ssmodel,in2.ssmodel,name);
      out = ussmodel(out,in2.uncertainty,in2.type,'OK');    
    end
   case 'LFT'
    switch type2
     case {'cer','LFT'}
      out = mtimes(in1.ssmodel,in2.ssmodel,name);
      out = ussmodel(out,diag(in2.uncertainty,in1.uncertainty));
     otherwise % poly, paral, or inter
      error('Inputs cannot be USSMODELs of different types')    
    end
   case 'par'
    switch type2
     case 'cer'
      in2tmp = ssmodel(0,in2.ssmodel);
      in2tmp(in1.ssmodel.nb) = in2.ssmodel;
      out = mtimes(in1.ssmodel,in2tmp,name);
      out = ussmodel(out,in1.uncertainty,in1.type,'OK');    
     case 'LFT'
      error('Inputs cannot be USSMODELs of different types')    
     otherwise % poly, paral, or inter
       in1=upoly(in1);
       in2=upoly(in2);
       M=[];
       for ii=1:in2.nb
         tmp=mtimes(in1.ssmodel,in2.ssmodel(ii));
         M(:,:,(end+1):(end+in1.nb))=tmp.allmatrices;
       end
       out=ssmodel(M,1:tmp.n,...
                     (tmp.n+1):(tmp.n+tmp.pd),...
                     (tmp.n+tmp.pd+1):(tmp.n+tmp.pd+tmp.pz),...
                     (tmp.n+tmp.pd+tmp.pz+1):(tmp.n+tmp.pd+tmp.pz+tmp.py),...
                     1:tmp.n,...
                     (tmp.n+1):(tmp.n+tmp.md),...
                     (tmp.n+tmp.md+1):(tmp.n+tmp.md+tmp.mw),...
                     (tmp.n+tmp.md+tmp.mw+1):(tmp.n+tmp.md+tmp.mw+tmp.mu),...
                     tmp.Ts);
       out=upoly(out);
    end
   otherwise % poly or inter
    switch type2
     case 'cer'
      out = mtimes(in1.ssmodel,in2.ssmodel,name);
      out = ussmodel(out,in1.uncertainty,in1.type,'OK');       
     case 'LFT'
      error('Inputs cannot be USSMODELs of different types')    
     otherwise % poly, paral, or inter
       in1=upoly(in1);
       in1=in1.ssmodel;
       in2=upoly(in2);
       in2=in2.ssmodel;
       M=[];
       for ii=1:in2.nb
         tmp=mtimes(in1,in2(ii));
         M(:,:,(1+(ii-1)*in1.nb):(ii*in1.nb))=tmp.allmatrices;
       end
       out=ssmodel(M,1:tmp.n,...
                     (tmp.n+1):(tmp.n+tmp.pd),...
                     (tmp.n+tmp.pd+1):(tmp.n+tmp.pd+tmp.pz),...
                     (tmp.n+tmp.pd+tmp.pz+1):(tmp.n+tmp.pd+tmp.pz+tmp.py),...
                     1:tmp.n,...
                     (tmp.n+1):(tmp.n+tmp.md),...
                     (tmp.n+tmp.md+1):(tmp.n+tmp.md+tmp.mw),...
                     (tmp.n+tmp.md+tmp.mw+1):(tmp.n+tmp.md+tmp.mw+tmp.mu),...
                     tmp.Ts);
       out=upoly(out);
   end
  end
  
  out.ssmodel.name = name;
