function display(delta,disptype)
% UNCERTAINTY/DISPLAY - Command window display of an UNCERTAINTY object

%   This file is part of RoMulOC
%   Last Update 9-Mar-2013
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

if nargin==1
  disptype=0;
end

if any(size(delta))
  
  if delta.transpose
    tr='''';
  else
    tr='';
  end
  
  if size(delta.struc,2)>1
    fprintf('diagonal structured uncertainty\nsize: %ix%i | ',delta.size(1),delta.size(2));
    fprintf('nb blocks: %i | independent blocks: %i\n',size(delta.struc,2),delta.nbb);
    structure=[];
    for ii=1:size(delta.struc,2)
      structure=[structure,' #',num2str(delta.struc(1,ii))];
    end;
    fprintf(' wd = diag(%s )%s * zd\n',structure,tr);
  else
    fprintf(' wd = #%i%s * zd\n',delta.struc(1,1),tr);
  end;
  if disptype==0
    fprintf('index\tsize\trepeat.\tRorC\tdist.\tnature\t');
    if ~isempty([delta.names{:}])
      fprintf('\t\t\tname\n');
    else
      fprintf('\n');
    end
    for ii=1:delta.nbb
      fprintf('#%i\t%ix%i\t',...
        delta.uindex(ii),...
        size(delta.rows{ii},1),...
        size(delta.cols{ii},1));
      fprintf('%i\t',sum(delta.struc(2,:)==ii));
      if delta.complex(ii)
        fprintf('complex\t');
      else
        fprintf('real\t');
      end
      switch delta.distribution(ii)
        case 1
          fprintf('det.\t');
        case 2
          fprintf('unif.\t');
        case 3
          fprintf('gauss.\t');
      end
      switch delta.nature(ii)
        case 10
          fprintf('LTI\t');
        case 20
          fprintf('TV\t');
        case 30
          fprintf('NL\t');
      end
      fprintf('%s\t',delta.constr{ii});
      fprintf('%s',delta.names{ii});
      if ~isempty(delta.usample{ii})
        fprintf('\t %i SAMPLES OF',size(delta.usample{ii},3));
      end
      fprintf('\n');      
    end;
    %      fprintf('\n');
  end
  
else
  fprintf('Empty uncertainty object\n');
end
