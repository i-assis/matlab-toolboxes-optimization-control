function quiz = declarevars(quiz,us,perftype,optim,fSV)
% For internal use only

% <quiz> is a CTRPB that may already contain some SDPVARS
% (in multi-objevtive state-feedback design cases for example)
% <us> is USSMODEL or SSMODEL
% <perftype> indicates which performance is being considered
%           01 for stability and D-satbility
%           21 for Hinfty
%           31 for H2
%           41 for I2P
% <optim> = +1 if a performance to be optimized
% <optim> =  0 if feasiblity of LMI problem (S-procedure variables in such case)
% <optim> = -1 if feasibility index to be minimized (for originally BMI problems)
% <fSV> = 1 if you want for force full Slack Variables
% default <fSV=0> and reduced size SV are looked for

%   This file is part of RoMulOC
%   Last Update 19-May-2016
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

if isa(us,'ssmodel')
  us=upoly(us);
end
quiztype=quiz.type;
systype=us.type;
systype=systype(1:3);

if nargin<5
  if quiztype(1)==11 % for state feedback
    % declare full SV
    fSV=1;
    % transpose the system (only I/O dimensions concerned here)
    us=us';
  else
    fSV=0;
  end
end

% declare variables common to all LMIs
if isempty(quiz.vars);
  quiz.vars{1,1,1} = sdpvar;
  quiz.vars{1,2,1} = 'zero of LMIs';
  switch quiztype(2)
    case {1,2,3,4} % quadratic stability type (one Lyap mat)
      quiz.vars{2,1,1} = sdpvar(us.n,us.n,'symmetric');
      quiz.vars{2,2,1} ='Lyapunov matrix';
      newctr=tag(quiz.vars{2,1,1}>=quiz.vars{1,1,1},'Lyap >0');
      quiz.lmi = quiz.lmi + newctr;
    case {11,12,13,14} % PDLF for LFTs - a larger Lyap mat
      quiz.vars{2,1,1} = sdpvar(us.n+us.md,us.n+us.md,'symmetric');
      quiz.vars{2,2,1} ='def. Lyapunov PDF';
      newctr=tag(quiz.vars{2,1,1}>=quiz.vars{1,1,1},'Lyap >0');
      quiz.lmi = quiz.lmi + newctr;
    case {21,22,23,24} % SV techniques
      switch quiztype(1)
        case 11 % the state feedback case
          quiz.vars{2,1,1} = sdpvar(us.n,us.n,'full');
          quiz.vars{2,2,1} ='F Slack variable';
      end
  end
  switch quiztype(1)
    case 11 % need also to declare the variable defining the sfb gain
      quiz.vars{3,1,1} = sdpvar(us.py,us.n,'full'); % py because on the transposed system
      quiz.vars{3,2,1} ='Ss = -K*(2nd var)';
  end
else
  % check dimensions of variables
  switch quiztype(2)
    case {1,30} % quadratic stability type (one Lyap mat)
      if size(quiz.vars{2,1,1},1)~=us.n
        error('All systems must be of same order');
      end
    case 11 % PDLF for LFTs - a larger Lyap mat
      if size(quiz.vars{2,1,1},1)~=us.n+us.md
        error('All systems must be of same order and same uncertainty size');
      end
    case 21 % SV techniques
      switch quiztype(1)
        case 11 % the state feedback case
          if size(quiz.vars{2,1,1},1)~=us.n
            error('All systems must be of same order');
          end
      end
  end
  switch quiztype(1)
    case 11 % need also to declare the variable defining the sfb gain
      if size(quiz.vars{3,1,1},1)~=us.py
        error('All systems must have same number of control imputs <u>');
      end
  end
  
end

% Now declare local vars
% first variable related to performances (if any)
perfnb=size(quiz.vars,3)+1;
if optim>0
  quiz.vars{1,1,perfnb} = sdpvar;
  quiz.obj = quiz.vars{1,1,perfnb};
  quiz.objt(end+1,1:2)=[perfnb,1];
  quiz.feast(end+1,1:2)=[perfnb,0];
  switch perftype
    case 1
      quiz.vars{1,2,perfnb} = 'not used';
    case 21
      quiz.vars{1,2,perfnb} = 'g > (Hinf cost)^2';
    case 31
      quiz.vars{1,2,perfnb} = 'g > (H2 cost)^2';
    case 41
      quiz.vars{1,2,perfnb} = 'g > (I2P cost)^2';
  end
elseif optim<0
  quiz.vars{1,1,perfnb} = sdpvar;
  quiz.feas = quiz.vars{1,1,perfnb};
  quiz.feast(end+1,1:2)=[perfnb,1];
  quiz.objt(end+1,1:2)=[perfnb,0];
  quiz.vars{1,2,perfnb} = sprintf('feas index of %i-th perf.',perfnb-1);
  newctr=tag(quiz.vars{1,1,perfnb}>=-1e-5,'g_region >= 0');
  quiz.lmi = quiz.lmi + newctr;
else
  if perftype>1
    quiz.vars{1,1,perfnb} = sdpvar;
    quiz.vars{1,2,perfnb} = 'S-procedure variable';
  else
    quiz.vars{1,1,perfnb} = [];
  end
  quiz.objt(end+1,1:2)=[perfnb,0];
  quiz.feast(end+1,1:2)=[perfnb,0];
end
% Then depending on type of uncertain models
switch systype(1:3)
  case {'cer','pol'}
    switch quiztype(2)
      case {1,2,3,4,5,6,7,8,9} % quadratic stability type (one Lyap mat)
        switch quiztype(1)
          case 11 % in case of state-feedback
            switch perftype
              case 31 % H2 performance
                % here MR found a bug - fix it with not very clean fashion
                libraryfcttype=func2str(quiz.forRACT{perfnb-1,1});
                libraryfcttype=str2double(libraryfcttype(1,2:3));
                switch libraryfcttype
                  case 11
                    T = sdpvar(us.pz,us.pz,'symmetric');  
                    quiz.vars{3,1,perfnb} = T;
                    quiz.vars{3,2,perfnb} ='T for H2 cost computation';
                  case 21
                    T=cell(us.nb,1);
                    for vtx=1:us.nb
                      T{vtx} = sdpvar(us.pz,us.pz,'symmetric');
                    end
                    quiz.vars{2,1,perfnb} = T;
                    quiz.vars{2,2,perfnb} ='T for H2 cost computation';
                end
            end
        end
      case 21 % SV case - define the local SVs
        %nbvrs=0;
%         switch quiztype(1)
%           case 11 % for state-feedback, the actual constraints are on the dual system
%             n=us.n;
%             mw=us.pz;
%          otherwise
            n=us.n;
            mw=us.mw;
%        end
        switch perftype
          case 1 % D-stability conditions
            if fSV
              quiz.vars{2,1,perfnb} = sdpvar(2*n,n,'full');
              quiz.vars{2,2,perfnb} ='Ga Slack variable';
            else
              % here we have to get some info about the system
              M=us.A;
              Mtest=repmat(M(:,:,1),[1,1,us.nb])-M;
              nrSV=sum(~any(any(Mtest,3),2));
              quiz.vars{2,1,perfnb} = sdpvar(2*n-nrSV,n-nrSV,'full');
              quiz.vars{2,2,perfnb} ='Ga Slack variable';
            end
            P=cell(us.nb,1);
            for vtx=1:us.nb
              P{vtx} = sdpvar(n,n,'symmetric');
              newctr=tag(P{vtx}>=quiz.vars{1,1,1},'Lyap >0');
              quiz.lmi = quiz.lmi + newctr;
            end
            quiz.vars{3,1,perfnb} = P;
            quiz.vars{3,2,perfnb} ='Lyapunov matrices at vertices';
          case 21 % H-infinity conditions
            if fSV
              quiz.vars{2,1,perfnb} = sdpvar(2*n+mw,n,'full');
              quiz.vars{2,2,perfnb} ='Ga Slack variable';
            else
              % here we have to get some info about the system
              M=[us.A,us.Bw];
              Mtest=repmat(M(:,:,1),[1,1,us.nb])-M;
              nrSV=sum(~any(any(Mtest,3),2));
              quiz.vars{2,1,perfnb} = sdpvar(2*n+mw-nrSV,n-nrSV,'full');
              quiz.vars{2,2,perfnb} ='Ga Slack variable';
            end
            P=cell(us.nb,1);
            for vtx=1:us.nb
              P{vtx} = sdpvar(n,n,'symmetric');
              newctr=tag(P{vtx}>=quiz.vars{1,1,1},'Lyap >0');
              quiz.lmi = quiz.lmi + newctr;
            end
            quiz.vars{3,1,perfnb} = P;
            quiz.vars{3,2,perfnb} ='Lyapunov matrices at vertices';
          case 31 % H-2 conditions
            if fSV
              quiz.vars{2,1,perfnb} = sdpvar(2*n,n,'full');
              quiz.vars{2,2,perfnb} ='Ga Slack variable';
              quiz.vars{3,1,perfnb} = sdpvar(n+mw,n,'full');
              quiz.vars{3,2,perfnb} ='Gb Slack variable';
            else
              % here we have to get some info about the system
              M=us.A;
              Mtest=repmat(M(:,:,1),[1,1,us.nb])-M;
              nrSV=sum(~any(any(Mtest,3),2));
              quiz.vars{2,1,perfnb} = sdpvar(2*n-nrSV,n-nrSV,'full');
              quiz.vars{2,2,perfnb} ='Ga Slack variable';
              M=us.Bw;
              Mtest=repmat(M(:,:,1),[1,1,us.nb])-M;
              nrSVb=sum(~any(any(Mtest,3),2));
              quiz.vars{3,1,perfnb} = sdpvar(mw+n-nrSVb,n-nrSVb,'full');
              quiz.vars{3,2,perfnb} ='Gb Slack variable';
            end
            P=cell(us.nb,1);
            T=cell(us.nb,1);
            for vtx=1:us.nb
              P{vtx} = sdpvar(n,n,'symmetric');
              newctr=tag(P{vtx}>=quiz.vars{1,1,1},'Lyap >0');
              quiz.lmi = quiz.lmi + newctr;
              T{vtx} = sdpvar(mw,mw,'symmetric');
            end
            quiz.vars{4,1,perfnb} = P;
            quiz.vars{4,2,perfnb} ='Lyapunov matrices at vertices';
            quiz.vars{5,1,perfnb} = T;
            quiz.vars{5,2,perfnb} ='T for H2 cost computation';
          case 41 % Impulse to peak conditions
            if fSV
              quiz.vars{2,1,perfnb} = sdpvar(2*n,n,'full');
              quiz.vars{2,2,perfnb} ='Ga Slack variable';
              quiz.vars{3,1,perfnb} = sdpvar(n+mw,n,'full');
              quiz.vars{3,2,perfnb} ='Gb Slack variable';
            else
              % here we have to get some info about the system
              M=us.A;
              Mtest=repmat(M(:,:,1),[1,1,us.nb])-M;
              nrSV=sum(~any(any(Mtest,3),2));
              quiz.vars{2,1,perfnb} = sdpvar(2*n-nrSV,n-nrSV,'full');
              quiz.vars{2,2,perfnb} ='Ga Slack variable';
              M=us.Bw;
              Mtest=repmat(M(:,:,1),[1,1,us.nb])-M;
              nrSVb=sum(~any(any(Mtest,3),2));
              quiz.vars{3,1,perfnb} = sdpvar(mw+n-nrSVb,n-nrSVb,'full');
              quiz.vars{3,2,perfnb} ='Gb Slack variable';
            end
            P=cell(us.nb,1);
            for vtx=1:us.nb
              P{vtx} = sdpvar(n,n,'symmetric');
              newctr=tag(P{vtx}>=quiz.vars{1,1,1},'Lyap >0');
              quiz.lmi = quiz.lmi + newctr;
            end
            quiz.vars{4,1,perfnb} = P;
            quiz.vars{4,2,perfnb} ='Lyapunov matrices at vertices';
        end
    end
  case 'LFT'
    % in that case we have separator matrices
    un=us.uncertainty;
    switch quiztype(2)
      case {1,2,3,4,5,6,7,8,9} % quadratic stability type (one Lyap mat)
        switch perftype
          case {1,21} % stability and Hinfty
            [sepvar,seplmi] = separator(un,quiz.vars{1,1,1});
            quiz.vars{2,1,perfnb} = sepvar;
            quiz.vars{2,2,perfnb} = 'Quadratic separator';
            quiz.lmi = quiz.lmi + seplmi;
          case 31 % H2
            if any(any(us.Cd))
              [sepvar,seplmi] = separator(un,quiz.vars{1,1,1});
              quiz.vars{2,1,perfnb} = sepvar;
              quiz.vars{2,2,perfnb} = 'Quadratic separator';
              quiz.lmi = quiz.lmi + seplmi;
            else
              %varsloc{2,1}=[];
            end
            if any(any(us.Ddw))
              quiz.vars{3,1,perfnb} = sdpvar(us.mw,us.mw,'symmetric');
              quiz.vars{3,2,perfnb} = 'T';
              [sepvar,seplmi] = separator(un,quiz.vars{1,1,1});
              quiz.vars{4,1,perfnb} = sepvar;
              quiz.vars{4,2,perfnb} = 'Quadratic separator';
              quiz.lmi = quiz.lmi + seplmi;
            else
              quiz.vars{3,1,perfnb} = sdpvar(us.mw,us.mw,'symmetric');
              quiz.vars{3,2,perfnb} = 'T';
              quiz.vars{4,1,perfnb}=[];
            end
          case 41 % Impulse to peak
            if any(any(us.Cd)) && any(any(us.Bd))
              [sepvar,seplmi] = separator(un,quiz.vars{1,1,1});
              quiz.vars{2,1,perfnb} = sepvar;
              quiz.vars{2,2,perfnb} = 'Quadratic separator';
              quiz.lmi = quiz.lmi + seplmi;
            else
              quiz.vars{2,1,perfnb}=[];
            end
            if any(any(us.Ddw)) && any(any(us.Bd))
              [sepvar,seplmi] = separator(un,quiz.vars{1,1,1});
              quiz.vars{3,1,perfnb} = sepvar;
              quiz.vars{3,2,perfnb} = 'Quadratic separator';
              quiz.lmi = quiz.lmi + seplmi;
            else
              quiz.vars{3,1,perfnb}=[];
            end
            if any(any(us.Cd)) && any(any(us.Dzd))
              [sepvar,seplmi] = separator(un,quiz.vars{1,1,1});
              quiz.vars{4,1,perfnb} = sepvar;
              quiz.vars{4,2,perfnb} = 'Quadratic separator';
              quiz.lmi = quiz.lmi + seplmi;
            else
              quiz.vars{4,1,perfnb}=[];
            end
            if any(any(us.Ddw)) && any(any(us.Dzd))
              [sepvar,seplmi] = separator(un,quiz.vars{1,1,1});
              quiz.vars{5,1,perfnb} = sepvar;
              quiz.vars{5,2,perfnb} = 'Quadratic separator';
              quiz.lmi = quiz.lmi + seplmi;
            else
              quiz.vars{5,1,perfnb}=[];
            end
        end
      case {11,12,13,14,15,16,17,18,19} % PDLF for LFTs - a larger Lyap mat
        switch perftype
          case 1 % stability
            [sepvar,seplmi] = separator(diag(un,un),quiz.vars{1,1,1});
            quiz.vars{2,1,perfnb} = sepvar;
            quiz.vars{2,2,perfnb} = 'Quadratic separator';
            quiz.lmi = quiz.lmi + seplmi;
          case 21 % Hinfty
            if any(any(us.Ddw))
              [sepvar,seplmi] = separator(diag(un,un,un),quiz.vars{1,1,1});
            else
              [sepvar,seplmi] = separator(diag(un,un),quiz.vars{1,1,1});
            end
            quiz.vars{2,1,perfnb} = sepvar;
            quiz.vars{2,2,perfnb} = 'Quadratic separator';
            quiz.lmi = quiz.lmi + seplmi;
          case 31 %H2
            [sepvar,seplmi] = separator(diag(un,un),quiz.vars{1,1,1});
            quiz.vars{2,1,perfnb} = sepvar;
            quiz.vars{2,2,perfnb} = 'Quadratic separator';
            quiz.lmi = quiz.lmi + seplmi;
            quiz.vars{3,1,perfnb} = sdpvar(us.mw,us.mw,'symmetric');
            quiz.vars{3,2,perfnb} = 'T';
            if any(any(us.Ddw))
              [sepvar,seplmi] = separator(diag(un,un),quiz.vars{1,1,1});
            else
              [sepvar,seplmi] = separator(un,quiz.vars{1,1,1});
            end
            quiz.vars{4,1,perfnb} = sepvar;
            quiz.vars{4,2,perfnb} = 'Quadratic separator';
            quiz.lmi = quiz.lmi + seplmi;
          case 41 % Impulse to peak
            [sepvar,seplmi] = separator(diag(un,un),quiz.vars{1,1,1});
            quiz.vars{2,1,perfnb} = sepvar;
            quiz.vars{2,2,perfnb} = 'Quadratic separator';
            quiz.lmi = quiz.lmi + seplmi;
            if any(any(us.Ddw))
              [sepvar,seplmi] = separator(diag(un,un),quiz.vars{1,1,1});
            else
              [sepvar,seplmi] = separator(un,quiz.vars{1,1,1});
            end
            quiz.vars{3,1,perfnb} = sepvar;
            quiz.vars{3,2,perfnb} = 'Quadratic separator';
            quiz.lmi = quiz.lmi + seplmi;
            [sepvar,seplmi] = separator(un,quiz.vars{1,1,1});
            quiz.vars{4,1,perfnb} = sepvar;
            quiz.vars{4,2,perfnb} = 'Quadratic separator';
            quiz.lmi = quiz.lmi + seplmi;
            if any(any(us.Ddw))
              [sepvar,seplmi] = separator(un,quiz.vars{1,1,1});
              quiz.vars{5,1,perfnb} = sepvar;
              quiz.vars{5,2,perfnb} = 'Quadratic separator';
              quiz.lmi = quiz.lmi + seplmi;
            else
              quiz.vars{5,1,perfnb}=[];
            end
        end
    end
end

