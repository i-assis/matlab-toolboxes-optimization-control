function display(sysm,disptype);
% SSMODEL/DISPLAY - display a SSMODEL object describing an LTI system

%   This file is part of RoMulOC
%   Last Update 30-Oct-2013
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

if sysm.nb
%%% number of models
if nargin==1
  disptype=0;
end
if sysm.nb>1 && disptype~=1 
  fprintf('Array of %i systems\n',sysm.nb);
end
%%% name of the model
if ~isempty(sysm.name)
  fprintf('name: %s\n',sysm.name);
end;
if sysm.c{1}
  fprintf('    \t      %2.2s=%i    ',sysm.c{1,3},length(sysm.c{1}));
elseif isempty(sysm.M)
  fprintf('empty SSMODEL');
elseif sysm.r{1}
  fprintf('    \t      ');
else 
  fprintf('static gain   ');
end;
for ii=2:4
  if sysm.c{ii}
    if ii==2
      fprintf(' ');
    end
    fprintf('%2.2s=%i    ',sysm.c{ii,3},length(sysm.c{ii}));
  end
end
fprintf('\n');
for jj=1:4
  if sysm.r{jj}
    issome=0;
    fprintf('%2.2s=%i\t%2.2s  =',sysm.r{jj,3},length(sysm.r{jj,1}),sysm.r{jj,2});
    for ii=1:4
      if any(any(any(sysm.M(sysm.r{jj},sysm.c{ii},:))))
	if issome, fprintf(' +'); end
	fprintf(' %3.3s*%s',sysm.Mn{jj,ii},sysm.c{ii,2});
	issome=1;
      elseif sysm.c{ii}
	fprintf('        ');
	if ii==2
	  fprintf(' ');
	end
      end
    end
    fprintf('\n');
  end
end  
%%% discrete or continuous
%fprintf('\n');
if sysm.T
   fprintf('discrete time  ( dx : advance operator ) period T=%g\n',sysm.T);
elseif isempty(sysm.M)
else
   fprintf('continuous time ( dx : derivative operator ) \n');
end;

else
  fprintf('Empty ssmodel object\n');
end
