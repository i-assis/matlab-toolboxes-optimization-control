function out = performances(quiz,us,perfval,perfname)
% PERFORMANCES - internal use only
%
% SEE ALSO stability, dstability, h2, i2p, ctrpb/plus, ctrpb/solvesdp
    
%   This file is part of RoMulOC
%   Last Update 19-May-2016
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France 
  
% Check input arguments
if nargin<4
  error('at least 4 input arg. needed');
end
if ~isa(quiz,'ctrpb')
  error('1st input arg. must be a CTRPB object');
end
if ~isa(us,'ssmodel') && ~isa(us,'ussmodel')
  error('2nd input arg. must be either a SSMODEL or a USSMODEL object');
elseif ~isa(us,'ussmodel')
  us=ussmodel(us,[]);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check the method to be applied
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fct='';perfcode=0;
type=us.type;
switch type(1:3)
 case 'LFT'
  fct=[fct,'M11'];
 case {'pol','cer','int','par'}
  fct=[fct,'M21'];  
end
switch quiz.type(1)
 case 01 % analysis problem
  fct=[fct,'C01'];
 case 11 % state-feedback problem
  fct=[fct,'C11'];
  if quiz.type(3) % check dimensions
    if quiz.type(3)~=us.n
      error('State-feedback design possible only for systems with same number of states');
    end
    if quiz.type(4)~=us.mu
      error('State-feedback design possible only for systems with same number of inputs <u>');
    end
  else
    quiz.type(3)=us.n;
    quiz.type(4)=us.mu;
    quiz.type(5)=0;
  end
end
if quiz.type(2)>30 % when PDLF methods are declared without specifying Lyap fct
  switch type(1:3)
    case 'LFT'
      quiz.type(2)=quiz.type(2)-20;
    case {'pol','cer','int','par'}
      quiz.type(2)=quiz.type(2)-10;
  end
end
switch quiz.type(2)
  case {1,2,3,4}
    fct=[fct,'T01'];
  case {11,12,13,14}
    if ~any(any(us.Cd))
      error('This method can be applied only for systems with Cd~=0')
    end
    fct=[fct,'T11'];
  case {21,22,23,24}
    if strcmp(type(1:3),'LFT')
      error('This method cannot be applied to LFT models')
    end
    fct=[fct,'T21'];
  otherwise
    keyboard
end
switch perfname
  case 'stability'
    fct=[fct,'P01'];
    perfcode=01;
    if us.T
      perfval=region('disk',0,1);
    else
      perfval=region('plane',0);
    end
  case 'dstability'
    fct=[fct,'P01'];
    perfcode=01;
  case 'hinfty'
    fct=[fct,'P21'];
    perfcode=21;
  case 'h2'
    fct=[fct,'P31'];
    perfcode=31;
  case 'i2p'
    fct=[fct,'P41'];
    perfcode=41;
end
if exist(fct,'file')~=2 && quiz.type(2)<30
  fprintf('Sorry this method is not yet implemented\n');
  out=[];
  return;
end
fct=str2func(fct);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Start appending the ctrpb object
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
out=quiz;
nbperf=size(quiz.name,1);
nbperf=nbperf+1;
out.name{nbperf,1}=us.name;  
if isa(perfval,'region')
  Rname=display(perfval);
  R=get(perfval);
  if length(R)>1
    error('D-stability for unions of regions is not yet defined');
  elseif length(R{1})>1
    error('D-stability for should rather be defined by adding D-stability performances');
  elseif isempty(R{1}{1})
    error('the REGION object is empty');
  else
    perfval=R{1}{1};
    if isequal(perfname,'stability')
      out.name{nbperf,2}='Stability';
    else
      out.name{nbperf,2}='D-stability';
    end
  end
elseif perfval
  out.name{nbperf,2}=sprintf('%s < %g',upper(perfname),perfval);
else    
  out.name{nbperf,2}=sprintf('minimize %s',upper(perfname));
end
%%% Test type of method to apply
%typeofmethodtoapply='';
if quiz.type(1)==1
  if (mod(quiz.type(2),10)==1 && allprobabilistic(us))...
      || (mod(quiz.type(2),10)==2 && alllti(us))...
      || (mod(quiz.type(2),10)==3 && allltv(us))...
      || (quiz.type(1)==4)
%    typeofmethodtoapply='randanalysis';
    out.type(6)=1;
  end
end
if ~out.type(6)%isempty(typeofmethodtoapply)
  if (mod(quiz.type(2),10)==1 && containsprobabilistic(us))...
      || (mod(quiz.type(2),10)==2 && containslti(us))...
      || (mod(quiz.type(2),10)==3 && containsltv(us))...
      || (quiz.type(1)==4)
%    typeofmethodtoapply='randdesign';
    out.type(6)=2;
  else
%    typeofmethodtoapply='robust';
    out.type(6)=3;
  end
end
%switch typeofmethodtoapply
switch out.type(6)
%  case 'randanalysis'
  case 1    %%% = randomized analysis
    out.forRACT{nbperf,2}=perfval;
    out.forRACT{nbperf,3}=us;
    switch perfname
      case 'stability'
        out.forRACT{nbperf,1} = @teststability;
      case 'dstability'
        out.forRACT{nbperf,1} = @teststability;
      case 'hinfty'
        out.forRACT{nbperf,1} = @testhinfty;
      case 'h2'
        out.forRACT{nbperf,1} = @testh2;
      case 'i2p'
        out.forRACT{nbperf,1} = @testi2p;
      otherwise
        error('Something wrong here')
    end
%  case 'randdesign'
  case 2   %%% = randomized LMI design
    out.forRACT{nbperf,1} = fct;
    out.forRACT{nbperf,2} = perfval;
    out.forRACT{nbperf,3} = us;
    usforvars=us;
    for jj=1:(mod(quiz.type(2),10)-1)
      usforvars=usample(usforvars);
    end
    if (perfval==0)
        out = declarevars(out,usforvars,perfcode,1);
    elseif quiz.type(1)==11 && quiz.type(2)==21
        out = declarevars(out,usforvars,perfcode,-1);
    else
        out = declarevars(out,usforvars,perfcode,0);
    end
%  case 'robust'
  case 3   %%% = robust LMI design
    % first append quiz with variables related to the problem
    switch type(1:3)
      case {'cer','int','par'}
        us=upoly(us);
    end
    if (perfval==0)
        out = declarevars(out,us,perfcode,1);
    elseif quiz.type(1)==11 && quiz.type(2)==21
        out = declarevars(out,us,perfcode,-1);
    else
        out = declarevars(out,us,perfcode,0);
    end
    varsglob = reshape(out.vars(:,:,1),size(out.vars,1),size(out.vars,2));
    varsloc = reshape(out.vars(:,:,end),size(out.vars,1),size(out.vars,2));
    % then build the LMI constraints
    cstr = feval(fct,us,perfval,varsglob,varsloc);
    % In case the problem can be treated with extractwc
    if iscell(cstr)
      if isempty(out.forWC)
        out.forWC=(cstr{2}~=0).*(cstr{2}+length(out.lmi));
      else
        error('not coded to do worst case for multi-performance');
      end
      cstr=cstr{1};
    end
    % store the new constraints
    out.lmi=out.lmi+cstr;
end

%%%%%%%%%%%%%%%%%%%
% Build the way results will be displayed
%%%%%%%%%%%%%%%%%%%
% define the global result
out.result{2,1}='result=Inf;';
switch out.type(6)
  %  case 'randanalysis'
  case 1    %%% = randomized analysis
    switch perfname
      case 'stability'
        out.result{1,nbperf+1}=sprintf(...
          'fprintf(''\\nstability over all uncertainties with estimated probability P_est=%%3.4g%%%%\\n'',result*100)');
      case 'dstability'
        out.result{1,nbperf+1}=sprintf(...
          ['fprintf(''\\nD-stability for region ',...
          perfname,...
          ' over all uncertainties with estimated probability P_est=%%3.4g%%%%\\n'',result*100)']);
      case 'hinfty'
        if perfval
          out.result{1,nbperf+1}=sprintf(...
            ['fprintf(''\\nHinfty norm < ',...
            num2str(perfval),...
            ' over all uncertainties with estimated probability P_est=%%3.4g%%%%\\n'',result*100)']);
          out.result{3,nbperf+1}='';
        else
          out.result{1,nbperf+1}=sprintf(...
            'fprintf(''\\nHinfty norm = %%g is the worst case estimate\\n'',result);');
        end
      case 'h2'
        if perfval
          out.result{1,nbperf+1}=sprintf(...
            ['fprintf(''\\nH2 norm < ',...
            num2str(perfval),...
            ' over all uncertainties with estimated probability P_est=%%3.4g%%%%\\n'',result*100)']);
          out.result{3,nbperf+1}='';
        else
          out.result{1,nbperf+1}=sprintf(...
            'fprintf(''\\nH2 norm = %%g is the worst case estimate\\n'',result);');
        end
      case 'i2p'
        if perfval
          out.result{1,nbperf+1}=sprintf(...
            ['fprintf(''\\nI2P perf < ',...
            num2str(perfval),...
            ' over all uncertainties with estimated probability P_est=%%3.4g%%%%\\n'',result*100)']);
          out.result{3,nbperf+1}='';
        else
          out.result{1,nbperf+1}=sprintf(...
            'fprintf(''\\nI2P perf = %%g is the worst case estimate\\n'',result);');
        end
      otherwise
        error('Something wrong here')
    end
  otherwise
    if isempty(out.result{1,1})
      if quiz.type(1)==01
        % Analysis problem
        switch perfname
          case 'stability'
            out.result{1,1}=sprintf('result=1;');
          case 'dstability'
            out.result{1,1}=sprintf('result=1;');
          case {'hinfty','h2','i2p'}
            if perfval
              out.result{1,1}=sprintf('result=%g;',perfval);
            else
              out.result{1,1}=sprintf('result=sqrt(double(quiz.vars{1,1,%i}));',nbperf+1);
            end
          otherwise
            error('Something wrong here')
        end
      elseif quiz.type(1)==11
        % state-feedback problem
        out.result{1,1}='result=-double(quiz.vars{3,1,1})*inv(double(quiz.vars{2,1,1}));';
      else
        error('Something wrong here')
      end
    end
    % define the display
    out.result{2,nbperf+1}='';
    switch perfname
      case 'stability'
        out.result{1,nbperf+1}='[''Stability assessed'',10]';
        out.result{3,nbperf+1}='[''Stability might hold'',10]';
      case 'dstability'
        out.result{1,nbperf+1}=['[''D-stability assessed for region '',',Rname,']'];
        out.result{3,nbperf+1}=['[''D-stability might hold for region '',',Rname,']'];
      case 'hinfty'
        if perfval
          out.result{1,nbperf+1}=['[''Hinfty norm < ',num2str(perfval),' assessed'',10]'];
          out.result{3,nbperf+1}=['[''Hinfty norm < ',num2str(perfval),' might hold'',10]'];
        else
          out.result{1,nbperf+1}='[''Hinfty norm < %%g assessed'',10],sqrt(double(quiz.vars{1,1,%i}))';
          out.result{3,nbperf+1}='[''Hinfty norm < %%g might hold'',10],sqrt(double(quiz.vars{1,1,%i}))';
        end
      case 'h2'
        if perfval
          out.result{1,nbperf+1}=['[''H2 norm < ',num2str(perfval),' assessed'',10]'];
          out.result{3,nbperf+1}=['[''H2 norm < ',num2str(perfval),' might hold'',10]'];
        else
          out.result{1,nbperf+1}='[''H2 norm < %%g assessed'',10],sqrt(double(quiz.vars{1,1,%i}))';
          out.result{3,nbperf+1}='[''H2 norm < %%g might hold'',10],sqrt(double(quiz.vars{1,1,%i}))';
        end
      case 'i2p'
        if perfval
          out.result{1,nbperf+1}=['[''I2P perf < ',num2str(perfval),' assessed'',10]'];
          out.result{3,nbperf+1}=['[''I2P perf < ',num2str(perfval),' might hold'',10]'];
        else
          out.result{1,nbperf+1}='[''I2P perf < %%g assessed'',10],sqrt(double(quiz.vars{1,1,%i}))';
          out.result{3,nbperf+1}='[''I2P perf < %%g might hold'',10],sqrt(double(quiz.vars{1,1,%i}))';
        end
      otherwise
        error('Something wrong here')
    end
    out.result{1,nbperf+1}=sprintf(['fprintf(',out.result{1,nbperf+1},')'],nbperf+1);
    out.result{3,nbperf+1}=sprintf(['fprintf(',out.result{3,nbperf+1},')'],nbperf+1);
end
