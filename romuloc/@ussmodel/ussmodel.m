function usys = ussmodel(varargin)
% USSMODEL - Define an uncertain model
%
%- for LFT uncertain models
%      usys = ussmodel(sys,delta);
% <sys> is a SSMODEL object
% <delta> is an uncertainty object
%
%-for affine polytopic uncertain models:
%      usys = upoly(sys)
% <sys> is an array of SSMODEL objects
% that defines the vertices of the polytope
%
%- for parallelotopic uncertain models
%      usys = uparal(sysc,sysax);
% <sysc> is the central SSMODEL and
% <sysax> is an array of SSMODEL objects
% that defines the axes of the parallelotope
%
%- for interval uncertain models
%      usys = uinter(sys1,sys2);
% <sys1> and <sys2> are SSMODEL objects with same sizes
% that define the extramal values of the interval
%
% SEE ALSO ssmodel, uncertainty, upoly, uparal, uinter

%   This file is part of RoMulOC
%   Last Update 24-Oct-2013
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

inputerror = 0;
usys=struct([]);
switch nargin
  
  
  case 0
    type = 'empty';
    sys = ssmodel;
    delta = uncertainty;
    
    
  case 1
    sys=varargin{1};
    
    if isa(sys,'ussmodel')
      usys = sys;
      
    elseif isa(sys,'lfr')
      lfrsys=lfr(sys);
      [py,mu,n,nconst,md,pd] = size(lfrsys);
      if nconst
        error('constant blocs in LFR object : not handled in RoMulOC');
      end
      usys = ssmodel;
      usys.A   = lfrsys.a(1:n,1:n);
      usys.Bd  = lfrsys.a(1:n,(n+1):end);
      usys.Bu  = lfrsys.b(1:n,:);
      usys.Cd  = lfrsys.a((n+1):end,1:n);
      usys.Ddd = lfrsys.a((n+1):end,(n+1):end);
      usys.Ddu = lfrsys.b((n+1):end,:);
      usys.Cy  = lfrsys.c(:,1:n);
      usys.Dyd = lfrsys.c(:,(n+1):end);
      usys.Dyu = lfrsys.d;
      nbincert=size(lfrsys.blk.names,2);
      incertstart=1;
      if nbincert
        if n
          incertstart=2;
          switch lfrsys.blk.names{1}
            case '1/s'
              usys.Ts=0;
            case '1/z'
              usys.Ts=1;
            otherwise
              error('First block in LFR object is not integrator or delay !')
          end
        end
      end
      delta=uncertainty;
      for ii=incertstart:nbincert
        type = lfrsys.blk.desc(:,ii);
        if ~type(4)
          error('Sorry I did not understand the full blocks definition in LFRtoolbox')
        end
        if ~type(5)
          error('Sorry RoMulOC does not handle nonlinear blocks')
        end
        switch type(7)
          case 1
            switch type(8)
              case 2 % case of interval uncertainty
                deltatmp=uinter(type(9),type(10),lfrsys.blk.names{ii});
                for jj=1:type(1) % repeat it as many times as necessary
                  delta=diag(delta,deltatmp);
                end
              case 1 % case of uncertainty in a disc
                error('conversion of LFR disc uncertainty into RoMulOC uncertainty not yet implemented')
            end
          case 2
            switch type(8)
              case 1 % case of uncertainty in a sector
                deltatmp=usector(type(9),type(10),lfrsys.blk.names{ii});
                for jj=1:type(1) % repeat it as many times as necessary
                  delta=diag(delta,deltatmp);
                end
            end
          otherwise
            error('conversion of this type of LFR uncertainty into RoMulOC uncertainty not yet implemented')
        end
      end
      if ~isempty(delta)
        usys=ussmodel(usys,delta);
      end
      
    else
      error('Wrong usage of USSMODEL');
    end
    
    
  case 2
    sys = varargin{1};
    if ~isa(sys,'ssmodel')
      error('1st input arg. must be an SSMODEL');
    end
%     if sys.nb>1
%       error('1st input arg. cannot be an array of SSMODELs');
%     end
    if isa(varargin{2},'uncertainty')
      delta = varargin{2};
      if any([sys.md sys.pd]-size(delta))
        error('exogenous wd/zd signal sizes do not fit in 1st and 2nd input arg.');
      end
      type = 'LFT';
    elseif isempty(varargin{2})
      delta = uncertainty;
      type = 'certain';
    end
    
    
  case 4
    if isequal(varargin{4},'OK')
      sys   =varargin{1};
      delta =varargin{2};
      type  =varargin{3};
    else
      error('wrong usage of USSMODEL');
    end
    
    
  otherwise
    error('wrong usage of USSMODEL')
end


if isempty(usys)
  clear usys
  usys.type = type;
  usys = class(usys,'ussmodel',sys,delta);
end