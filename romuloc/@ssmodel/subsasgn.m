function sys = subsasgn(sys,S,data)
% SSMODEL/SUBSASGN - overloaded
%
% sys.info = data
% 
% Assign <data> to field <info> of SSMODEL <sys> 
%
% SEE ALSO ssmodel/subsref

%   This file is part of RoMulOC
%   Last Update 14-Sept-2012
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

switch S(1).type
    case '.'
        switch lower(S(1).subs)
            % TIME
            case {'t','ts'}
                if ~isnumeric(data)
                    error('sample time must be a real scalar');
                elseif max(size(data))>1 | ~isreal(data)
                    error('sample time must be a real scalar');
                else
                    sys.T=data;
                end
            % NAME
            case 'name'
                if ~ischar(data)
                    error('name must be a string');
                else
                    sys.name=data;
                end;
            % Number of elements in array
            case 'nb'
                if data<=sys.nb
                    warning('Some elements in the array of SSMODEL may be removed');
                else
                    sys.M(:,:,data)=zeros(size(sys.M,1),size(sys.M,2));
                    sys.nb=size(sys.M,3);
                end
            % A, BW, BV....
            otherwise
                if ~isnumeric(data)
                    error('system matrices must be numeric');
                end
                datasize=size(data);
                if length(datasize)>3
                    error('system matrices may only be 3D');
                end
                maxr = max([0, sys.r{1}, sys.r{2}, sys.r{3}, sys.r{4} ]);
                maxc = max([0, sys.c{1}, sys.c{2}, sys.c{3}, sys.c{4} ]);
                test1=0;
                for ii=1:4
                    for jj=1:4
                        if isequal(lower(S(1).subs),lower(sys.Mn{ii,jj}))
                            tmp=sys.M(sys.r{ii},sys.c{jj},:);	    
                            if isempty(tmp)
                                tmp=[];
                            end
                            if length(S)>1
                                tmp=subsasgn(tmp,S(2:end),data);
                            else
                                tmp=data;
                            end
                            rdif = size(tmp,1) - length(sys.r{ii});
                            if rdif>0
                                sys.r{ii}=[sys.r{ii}, maxr+(1:rdif)];
                            end
                            cdif = size(tmp,2) - length(sys.c{jj});
                            if cdif>0
                                sys.c{jj}=[sys.c{jj}, maxc+(1:cdif)];
                            end
                            if size(tmp,3)==1
                              tmp=repmat(tmp,[1 1 sys.nb]);
                            end
                            sys.M(sys.r{ii},sys.c{jj},1:size(tmp,3))=tmp;
                            test1=1;
                        end
                    end
                end
                if test1==0
                    error('Unknow subsref');
                end
                sys.nb=size(sys.M,3);
        end
    case '()'
        idx=S(1).subs{1};
%        if length(idx)>1
%            error('such assignment is not implemented');
%        end
% 21/1/12 commented, because why not. Seems to work.
        if length(S)>1
            if max(idx)>sys.nb
                systmp=ssmodel(0,sys);
            else
                systmp=subsref(sys,S(1));
            end
            data = subsasgn(systmp,S(2:end),data);
        end
        if ~isa(data,'ssmodel')
            error('such assignment is not implemented');
        end
        for ii=1:4
          maxr = max([0, sys.r{1}, sys.r{2}, sys.r{3}, sys.r{4} ]);
          maxc = max([0, sys.c{1}, sys.c{2}, sys.c{3}, sys.c{4} ]);
          if isempty(sys.r{ii})
            sys.r{ii}=[(maxr+1):(maxr+length(data.r{ii}))];
          end          
          if isempty(sys.c{ii})
            sys.c{ii}=[(maxc+1):(maxc+length(data.c{ii}))];
          end
          if length(sys.r{ii})~=length(data.r{ii}) | ...
                    length(sys.c{ii})~=length(data.c{ii});
                  error('Dimension mismatch');
          end
        end
        for ii=1:4
            for jj=1:4
                sys.M(sys.r{ii},sys.c{jj},idx)...
                    =data.M(sys.r{ii},sys.c{jj},1:length(idx));
% 21/1/12 <,1:length(idx)> added to take into account the commented lines
% above
            end
        end
        sys.nb=size(sys.M,3);
    otherwise
        error('irrelevant assignation');
end