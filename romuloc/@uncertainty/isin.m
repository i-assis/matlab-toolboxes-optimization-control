function ok = isin(a,b,verb)
% UNCERTAINTY/ISIN - Tells if a matrix belongs to the uncertainty set
%
% ok = isin(uset,value) or isin(value,uset)
%
% <uset> is a UNCERTAINTY object
% <value> is a matrix (DOUBLE)
% ok=1 if <value> satisfies the constraints of <uset>
% ok=0 otherwise
%
% when ok=0 a display returns an indication on which constraint is
% violated, to turn off this display use
% ok = isin(vaue,uset,0)
%
% SEE ALSO uncertainty

%   This file is part of RoMulOC
%   Last Update 20-Jul-2007
%   author : Dimitri Peaucelle, Maud Sevin
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

if nargin<2 | nargin>3
  error('wrong number of input arguments')
elseif nargin<3
  verb=1;
end

if isnumeric(a) & isa(b,'uncertainty')
  uset=b;
  value=a;
elseif isnumeric(b) & isa(a,'uncertainty')
  uset=a;
  value=b;
else
  error('wrong usage of ISIN');
end

% test the structure of <value>
ok=1;

if any(size(value)-uset.size)
  ok=0;
  if verb
    disp('general dimension of the matrix is invalid');
  end
else
  struct=sparse(uset.size(1),uset.size(2));
  ii=1;
  while ok & ii<=uset.nbb
    rows=uset.rows{ii};
    cols=uset.cols{ii};
    valueii=value(rows(:,1),cols(:,1));
    if uset.complex(ii)-~isreal(valueii)
      ok=0;
      if verb
        fprintf('Tested element at position of block #%i should be real-valued\n',uset.uindex(ii));
      end
    else
      % test if the value corresponds to the bloc
      switch uset.constr{ii}(1:7)
        case 'interva'
          if any(min(uset.vtx{ii}(:,:,1),uset.vtx{ii}(:,:,2))-valueii>0)
            ok=0;
            if verb
              fprintf(['Tested element at position of block #%i is below' ...
                ' lower limit of interval\n'],uset.uindex(ii));
            end
          elseif any(max(uset.vtx{ii}(:,:,1),uset.vtx{ii}(:,:,2))-valueii<0)
            ok=0;
            if verb
              fprintf(['Tested element at position of block #%i is greater' ...
                ' than upper limit of interval\n'],uset.uindex(ii));
            end
          end
        case 'paralle'
          nbaxes=size(uset.vtx{ii},3)-1;
          Aeq=reshape(uset.vtx{ii}(:,:,1:end-1),size(valueii,1)*size(valueii,2),nbaxes);
          beq=reshape(valueii-uset.vtx{ii}(:,:,end),size(valueii,1)*size(valueii,2),1);
          LB=-ones(nbaxes,1);
          UB=ones(nbaxes,1);
          [xivals,fval,exitflag]=linprog([],[],[],Aeq,beq,LB,UB,[],optimset('Display','off'));
          if exitflag<=0
            ok=0;
            if verb
              fprintf(['Tested element at position of block #%i is ' ...
                ' outside parallelotope\n'],uset.uindex(ii));
            end
          end
        case 'polytop'
          nbvertices=size(uset.vtx{ii},3);
          Aeq=reshape(uset.vtx{ii},size(valueii,1)*size(valueii,2),nbvertices);
          Aeq(end+1,:)=ones(1,nbvertices);
          beq=reshape(valueii,size(valueii,1)*size(valueii,2),1);
          beq(end+1,:)=1;
          LB=zeros(nbvertices,1);
          UB=ones(nbvertices,1);
          [xivals,fval,exitflag]=linprog([],[],[],Aeq,beq,LB,UB,[],optimset('Display','off'));
          if exitflag<=0
            ok=0;
            if verb
              fprintf(['Tested element at position of block #%i is ' ...
                ' outside polytope\n'],uset.uindex(ii));
            end
          end
        case {'{X,Y,Z}','norm-bo','positiv'}
          ok=isin(melli(uset.X{ii},uset.Y{ii},uset.Z{ii}),valueii);
          if ~ok & verb
            fprintf(['Tested element at position of block #%i is ' ...
              ' outside {X,Y,Z}-dissipative set\n'],uset.uindex(ii));
          end
        otherwise
          disp('what happened ?');
      end
      % the block is valid - but is it indeed repeated with the correct
      % structure ?
      struct(rows(:,1),cols(:,1))=valueii;
      for jj=2:size(rows,2)
        struct(rows(:,jj),cols(:,jj))=valueii;
      end
    end
    ii=ii+1;
  end
  if any(any(value-struct)) & ok
    ok=0;
    if verb
      disp('The bloc-diagonal structure is not respected');
    end
  end
end


