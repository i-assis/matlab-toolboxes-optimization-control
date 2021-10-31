function syscer = certain(sys,deltavalue,name,type)
% SSMODEL/CERTAIN - build the certain SSMODEL object
%
% syscer = certain(sys,dval,name);
%
%   given an SSMODEL object it closes the loop between wd and zd the
%   exogenous signals defining the LFT uncertainty transfer. The chosen
%   value of the uncertainty is given by <dval>.
%         _______
%        | dval  |
%     .--|_______|--.
%     |   _______   |
%  wd `->|       |--' zd              ________
%  w  -->| sys   |--> z   ==>   w -->| syscer |--> z
%  u  -->|_______|--> y         u -->|________|--> y
%
% <name> is an optionnal string to give a name to the resulting system
%
% SEE ALSO ssmodel, ssmodel/feedback and uncertainty

%   This file is part of RoMulOC
%   Last Update 29-Oct-2013
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France


%%% check inputs
if nargin<2
  error('usage: syscer = certain(sys,deltavalue);');
elseif ~isa(sys,'ssmodel')
  error('1st argument must be a SSMODEL object');
end;
if nargin<4
  type='lft';
end
switch type(1:3)
  case 'pol'
    lxi=max(size(deltavalue,1),size(deltavalue,2));
    nbsamp=size(deltavalue,3);
    if lxi~=sys.nb
      error('Dimensions of <dval> does not fit the number of vertices')
    else
      deltavalue=reshape(deltavalue,lxi,1,nbsamp);
      syscer=sys;
      syscer.name=[sys.name,'CERTAIN'];
      syscer.nb=nbsamp;
      syscer.M=zeros(size(sys.M,1),size(sys.M,2),nbsamp);
      for ii=1:nbsamp
        syscer.M(:,:,ii)=reshape(sys.M,size(sys.M,1),size(sys.M,2)*sys.nb)*kron(deltavalue(:,1,ii),eye(size(sys.M,2)));
      end
    end
  case 'par'
    % to be coded
    error('This case is not coded yet')
  case 'int'
    % to be coded
    error('This case is not coded yet')
  case 'lft'
    if isnumeric(deltavalue)
      if ~any(any(any(deltavalue)))
        deltavalue=zeros(length(sys.c{2}),length(sys.r{2}));
        [md,pd,nbsamp]=size(deltavalue);
      else
        [md,pd,nbsamp]=size(deltavalue);
        if md~=length(sys.c{2})
          error('the 2nd input argument has wrong number of rows');
        end;
        if pd~=length(sys.r{2})
          error('the 2nd input argument has wrong number of columns');
        end;
      end
      if sys.nb==1
        sys.nb=nbsamp;
        sys.M=repmat(sys.M,[size(sys.M,1),size(sys.M,2),nbsamp]);
      elseif sys.nb~=nbsamp
        error('Nb of systems in ssmodel array of 1st input arg. should fit Nb of samples in 2nd input arg.');
      end
      %%% initialize closed-loop system variables
      syscer=ssmodel;
      syscer.T=sys.T;
      syscer.nb=nbsamp;
      if nargin>2
        syscer.name=name;
      else
        syscer.name = '';
      end
      lastr=0;lastc=0;
      for ii=[1 3 4]
        syscer.r{ii}=lastr+(1:length(sys.r{ii}));
        if ~isempty(syscer.r{ii})
          lastr=max(syscer.r{ii});
        end
        syscer.c{ii}=lastc+(1:length(sys.c{ii}));
        if ~isempty(syscer.c{ii})
          lastc=max(syscer.c{ii});
        end
      end
      dr=sys.r{2};
      otherr=[sys.r{1} sys.r{3} sys.r{4}];
      dc=sys.c{2};
      otherc=[sys.c{1} sys.c{3} sys.c{4}];
      MA=sys.M(otherr,otherc,:);
      MB=sys.M(otherr,dc,:);
      MC=sys.M(dr,otherc,:);
      MD=sys.M(dr,dc,:);
      % preallocate matrix
      syscer.M=zeros(length(otherr),length(otherc),nbsamp);
      %%% test well posedness of closed-loop
      for jj=1:nbsamp
        if md<pd
          DT=eye(md)-deltavalue(:,:,jj)*MD(:,:,jj);
          DT=DT\deltavalue(:,:,jj);
        else
          DT=eye(pd)-MD(:,:,jj)*deltavalue(:,:,jj);
          DT=deltavalue(:,:,jj)/DT;
        end
        if ~all(all(DT<Inf))
          error('the closed loop system is not well-posed');
        end
        syscer.M(:,:,jj)=MA(:,:,jj)+MB(:,:,jj)*DT*MC(:,:,jj);
      end
    elseif isa(deltavalue,'uncertainty')
      % code for case when part of the uncertainty is fixed
      del=deltavalue;
      [md,pd]=size(del);
      if md~=length(sys.c{2})
        error('the 2nd input argument has wrong number of rows');
      end;
      if pd~=length(sys.r{2})
        error('the 2nd input argument has wrong number of columns');
      end;
      nbsamp=del.samplenb;
      if ~nbsamp
        syscer=ussmodel(sys,del);
      else
        if sys.nb==1
          sys.nb=nbsamp;
          sys.M=repmat(sys.M,[size(sys.M,1),size(sys.M,2),nbsamp]);
        elseif sys.nb~=nbsamp
          error('Nb of systems in ssmodel array of 1st input arg. should fit Nb of samples in 2nd input arg.');
        end
        [dcert,dunc,rowscert,colscert,rowsunc,colsunc] = separatecertainuncertain(del);
        % build the LFT model with two loops
        syscer=ssmodel;
        syscer.T=sys.T;
        syscer.nb=nbsamp;
        if nargin>2
          syscer.name=name;
        else
          syscer.name = '';
        end
        lastr=0;lastc=0;
        for ii=[1 3 4]
          syscer.r{ii}=lastr+(1:length(sys.r{ii}));
          if ~isempty(syscer.r{ii})
            lastr=max(syscer.r{ii});
          end
          syscer.c{ii}=lastc+(1:length(sys.c{ii}));
          if ~isempty(syscer.c{ii})
            lastc=max(syscer.c{ii});
          end
        end
        syscer.r{2}=lastr+(1:length(colsunc));
        syscer.c{2}=lastc+(1:length(rowsunc));
        dr=sys.r{2}(colscert);
        otherr=[sys.r{1} sys.r{3} sys.r{4} sys.r{2}(colsunc)];
        dc=sys.c{2}(rowscert);
        otherc=[sys.c{1} sys.c{3} sys.c{4} sys.c{2}(rowsunc)];
        MA=sys.M(otherr,otherc,:);
        MB=sys.M(otherr,dc,:);
        MC=sys.M(dr,otherc,:);
        MD=sys.M(dr,dc,:);
        % preallocate matrix
        syscer.M=zeros(length(otherr),length(otherc),nbsamp);
        %%% test well posedness of closed-loop
        md=length(dc);
        pd=length(dr);
        for jj=1:nbsamp
          if md<pd
            DT=eye(md)-dcert(:,:,jj)*MD(:,:,jj);
            DT=DT\dcert(:,:,jj);
          else
            DT=eye(pd)-MD(:,:,jj)*dcert(:,:,jj);
            DT=dcert(:,:,jj)/DT;
          end
          if ~all(all(DT<Inf))
            error('the closed loop system is not well-posed');
          end
          syscer.M(:,:,jj)=MA(:,:,jj)+MB(:,:,jj)*DT*MC(:,:,jj);
        end
        syscer=ussmodel(syscer,dunc);
      end
    else
      error('Unknown case')
    end
end

% 
% else % what follows is the code for values of uncertainties existing before oct 2013
%   if sys.nb>1 %%% this is actually for the case of polytopic systems... where is it used?
%     if length(deltavalue)~=sys.nb
%       error('For arrays of models <dval> should be vector of combination of vertices')
%     else
%       deltavalue=reshape(deltavalue,length(deltavalue),1);
%       syscer=sys;
%       syscer.name=[sys.name,'CERTAIN'];
%       syscer.nb=1;
%       syscer.M=reshape(sys.M,size(sys.M,1),size(sys.M,2)*sys.nb)*kron(deltavalue,eye(size(sys.M,2)));
%     end
%   else
%     if isnumeric(deltavalue)
%       if ~any(any(any(deltavalue)))
%         deltavalue=zeros(length(sys.c{2}),length(sys.r{2}));
%         [md,pd,nbsamp]=size(deltavalue);
%       else
%         [md,pd,nbsamp]=size(deltavalue);
%         if md~=length(sys.c{2})
%           error('the 2nd input argument has wrong number of rows');
%         end;
%         if pd~=length(sys.r{2})
%           error('the 2nd input argument has wrong number of columns');
%         end;
%       end
%     else
%       error('2nd argument must be a matrix gain');
%     end;
%     %%% initialize closed-loop system variables
%     syscer=ssmodel;
%     syscer.T=sys.T;
%     syscer.nb=nbsamp;
%     if nargin>2
%       syscer.name=name;
%     else
%       syscer.name = '';
%     end
%     lastr=0;lastc=0;
%     for ii=[1 3 4]
%       syscer.r{ii}=lastr+(1:length(sys.r{ii}));
%       if ~isempty(syscer.r{ii})
%         lastr=max(syscer.r{ii});
%       end
%       syscer.c{ii}=lastc+(1:length(sys.c{ii}));
%       if ~isempty(syscer.c{ii})
%         lastc=max(syscer.c{ii});
%       end
%     end
%     dr=sys.r{2};
%     otherr=[sys.r{1} sys.r{3} sys.r{4}];
%     dc=sys.c{2};
%     otherc=[sys.c{1} sys.c{3} sys.c{4}];
%     MA=sys.M(otherr,otherc);
%     MB=sys.M(otherr,dc);
%     MC=sys.M(dr,otherc);
%     MD=sys.M(dr,dc);
%     % preallocate matrix
%     syscer.M=zeros(length(otherr),length(otherc),nbsamp);
%     %%% test well posedness of closed-loop
%     for jj=1:nbsamp
%       if md<pd
%         DT=eye(md)-deltavalue(:,:,jj)*MD;
%         DT=DT\deltavalue(:,:,jj);
%       else
%         DT=eye(pd)-MD*deltavalue(:,:,jj);
%         DT=deltavalue(:,:,jj)/DT;
%       end
%       if ~all(all(DT<Inf))
%         error('the closed loop system is not well-posed');
%       end
%       syscer.M(:,:,jj)=MA+MB*DT*MC;
%     end
%   end
% end
