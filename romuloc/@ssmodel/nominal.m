function so = nominal(si,type)
% for internal use only

%   This file is part of RoMulOC
%   Last Update 23-May-2013
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

if nargin<2
  so=si;
elseif nargin>2
  error('No more than 2 input arg. needed')
else
  so=ssmodel;
  so.T=si.T;
  so.nb=1;
  if ~isempty(si.name)
    so.name=[si.name ' NOMINAL'];
  end
  switch type
    % removed on may-23 2013, became irrelevant
    %      case 'LFT'
    %       lastr=0;lastc=0;
    %       for ii=[1 3 4]
    % 	so.r{ii}=lastr+(1:length(si.r{ii}));
    % 	lastr=max([so.r{ii},lastr]);
    % 	so.c{ii}=lastc+(1:length(si.c{ii}));
    % 	lastc=max([so.c{ii},lastr]);
    %       end
    %       otherr=[si.r{1} si.r{3} si.r{4}];
    %       otherc=[si.c{1} si.c{3} si.c{4}];
    %       so.M=si.M(otherr,otherc);
    case 'pol'
      so.r=si.r;
      so.c=si.c;
      zeta=1/si.nb;
      so.M=zeros(size(si.M(:,:,1)));
      for ii=1:si.nb
        so.M=so.M+zeta*si.M(:,:,ii);
      end
    case 'int'
      so.r=si.r;
      so.c=si.c;
      so.M=0.5*(si.M(:,:,1)+si.M(:,:,2));
    case 'par'
      so.r=si.r;
      so.c=si.c;
      so.M=si.M(:,:,1);
  end;
end
