function quiz_out = initialize(quiz,init,ops)
% INITIALIZE - Initialize control problem (for cases when it is not pure LMI)
%
% quiz_init = initialize(quiz,init,ops)
%
% Some control problem do not have a pure LMI formulation but can be such
% if some "slack variables" are constrained a priori. These a priori
% choices are in general guided by the control objectives themselves.
% Some are proposed in this function.
%
% For state-feedback problems with PDLF
% <init> is either
% - empty, then a default choice of SVs is made
% - a scalar (negative for continuous-time systems,
%             with modulus less than one for discrete-time systems,
%             with value inside the regions where to place poles if such problem)
% - a stable matrix of dimensions the order of the model to be controlled
%	- a guess of a state feedback gain (an LMI is then solved to initialize)
% <ops> options pour "solvesdp". Use ops=sdpsettings(...) to define it.
%
% OUTPUT
% <quiz>  reformulaton of the problem of PDLF Synthesis as an LMI problem
%
% SEE ALSO ctrpb, stability, dstability, hinfty, h2, i2p, ctrpb/plus, ctrpb/solvesdp

%   This file is part of RoMulOC
%   Last Update 7-Nov-2014
%   author : Dimitri Peaucelle, Maud Sevin, Alberto Bortott
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

if nargin<1 || nargin>3
  error('One, two or three input arg. needed')
elseif nargin<2
  init=[];
end
if nargin<3
  ops=sdpsettings('verbose',1);
end
quiz_out=quiz;

if quiz.type(1)==11 && quiz.type(2)==21 % state-feedback with SVs
  n=quiz.tmp{1,1}.n; % all systems have same nb of states so that can be done once for ever
  if isempty(init) % default SVs
    for nbperf=1:size(quiz.tmp,1)
      switch quiz.tmp{nbperf,3}
        case 'stability'
          if quiz.tmp{nbperf,1}.T
            Ga=[zeros(n);-eye(n)];
          else
            Ga=[-eye(n);-1e-2*eye(n)];
          end
          quiz_out.lmi=replace(quiz_out.lmi,quiz.vars{2,1,nbperf+1},Ga);
          assign(quiz.vars{2,1,nbperf+1},Ga);
        case 'dstability'
          R=get(quiz.tmp{nbperf,2});
          R=R{1}{1};
          if R(2,2)>0
            Ga=[-R(1,2)'*eye(n);-R(2,2)*eye(n)];
          elseif R(1,1)>0 && R(2,2)<0
            Ga=[-R(1,1)*eye(n);-R(2,1)'*eye(n)];
          else
            Ga=[-R(1,2)'*eye(n);-1e-0*eye(n)];
%          elseif R(1,1)==0
%            Ga=[-1e-8*eye(n);-R(2,1)'*eye(n)];
%          else
%            keyboard
          end
          quiz_out.lmi=replace(quiz_out.lmi,quiz.vars{2,1,nbperf+1},Ga);
          assign(quiz.vars{2,1,nbperf+1},Ga);
        case 'hinfty'
          pz=quiz.tmp{nbperf,1}.pz;
          if quiz.tmp{nbperf,1}.T
            Ga=[zeros(n);zeros(pz,n);-eye(n)];
          else
            Ga=[-eye(n);zeros(pz,n);-1e-2*eye(n)];
          end
          quiz_out.lmi=replace(quiz_out.lmi,quiz.vars{2,1,nbperf+1},Ga);
          assign(quiz.vars{2,1,nbperf+1},Ga);
        case {'h2','i2p'}
          if quiz.tmp{nbperf,1}.T
            Ga=[zeros(n);-eye(n)];
          else
            Ga=[-eye(n);-1e-2*eye(n)];
          end
          quiz_out.lmi=replace(quiz_out.lmi,quiz.vars{2,1,nbperf+1},Ga);
          assign(quiz.vars{2,1,nbperf+1},Ga);
          pz=quiz.tmp{nbperf,1}.pz;
          Gb=[zeros(pz,n);-eye(n)];
          quiz_out.lmi=replace(quiz_out.lmi,quiz.vars{3,1,nbperf+1},Gb);
          assign(quiz.vars{3,1,nbperf+1},Gb);
      end
    end
  elseif ismatrix(init) && size(init,1)==size(init,2)
    % we are asusming that there is no situation when the number of inputs
    % is equal to the number of states. This is how we distinguish the
    % state-feedback gain from a stable central matrix.
    if isscalar(init)
      init=init*eye(n);
    end
    if any(size(init)-[n,n])
      error('When a square matrix, 2nd input arg. should be same size as order of system');
    end
    for nbperf=1:size(quiz.tmp,1)
      switch quiz.tmp{nbperf,3}
        % check if init is reasonnable
        case {'stability','hinfty','h2','i2p'}
          if quiz.tmp{nbperf,1}.T
            if max(abs(eig(init)))>=1
              error('2nd input argument should have eigenvalues in the unit disc');
            end
          else
            if max(real(eig(init)))>=0
              error('2nd input argument should have eigenvalues in left-hand half plane');
            end
          end
        case 'dstability'
          R=get(quiz.tmp{nbperf,2});
          R=R{1}{1};
          poles0=eig(init);
          testreg=R(1,1)*ones(n,1)...
            +conj(poles0)*R(2,1)...
            +poles0*R(1,2) ...
            +abs(poles0).^2*R(2,2);
          if any(testreg>0)
            error('2nd input argument should have eigenvalues in specified region')
          end
      end
      switch quiz.tmp{nbperf,3}
        % assign the values of the SVs
        case {'stability','dstability'}
          Ga=[init;-eye(n)];
          quiz_out.lmi=replace(quiz_out.lmi,quiz.vars{2,1,nbperf+1},Ga);
        case 'hinfty'
          Ga=[init;zeros(us.pz,n);-eye(n)];
          quiz_out.lmi=replace(quiz_out.lmi,quiz.vars{2,1,nbperf+1},Ga);
        case {'h2','i2p'}
          Ga=[init;-eye(n)];
          quiz_out.lmi=replace(quiz_out.lmi,quiz.vars{2,1,nbperf+1},Ga);
          Gb=[zeros(us.pz,n);-eye(n)];
          quiz_out.lmi=replace(quiz_out.lmi,quiz.vars{3,1,nbperf+1},Gb);
      end
    end
  elseif ismatrix(init) && size(init,1)~=size(init,2)
    % here the initialization is based on a given state feedback, the goal
    % is to find some SVs appropriate for the guy.
    % We could put here a test that would check whether the proposed
    % state feedback satisfies the constraints at least on the
    % vertices, but finally this migth be costly, we can just try to
    % solve the LMIs and if it fails then the user can try to
    % understand why by himself.
    %%%%%%%%%%%%%%%%%%%%%% 
    % Compute the objective functions
    if any(quiz.objt(:,2)) % there are performances to optimize
      for ii=1:size(quiz.feast,1) % freeze to zero any feasibility indicator
        if quiz.feast(ii,2)
          quiz.lmi=replace(quiz.lmi,quiz.vars{1,1,ii+1},0);
          assign(quiz.vars{1,1,ii+1},0);
        end
      end
      quiz.obj=0;
      for ii=1:size(quiz.objt,1)
        quiz.obj=quiz.obj+quiz.objt(ii,2)*quiz.vars{1,1,ii+1};
      end
    elseif any(quiz.feast(:,2))
      quiz.feas=0;
      for ii=1:size(quiz.feast,1)
        quiz.feas=quiz.feas+quiz.feast(ii,2)*quiz.vars{1,1,ii+1};
      end
    end
    %%%%%%%%%%%%%%%%%%%%%% 
    % Freeze the given control gain and related SV
    quiz_tmp=replace(quiz.lmi,quiz.vars{2,1,1},eye(n));
    assign(quiz.vars{2,1,1},eye(n));
    quiz_tmp=replace(quiz_tmp,quiz.vars{3,1,1},-init);    
    assign(quiz.vars{3,1,1},-init);
    quiz_tmp=imag2reallmi(quiz_tmp);
    %%%%%%%%%%%%%%%%%%%%%%
    % Make 'shift' distinction between optimization and feasibility
    if isempty(quiz.obj)
      nbvars=length(getvariables(quiz_tmp));
      quiz_tmp=replace(quiz_tmp,quiz.vars{1,1,1},1/nbvars);
      solvesdp(quiz_tmp,quiz.feas,ops);
    else
      quiz_tmp=replace(quiz_tmp,quiz.vars{1,1,1},0);
      solvesdp(quiz_tmp,quiz.obj,ops);
    end
    assign(quiz.vars{1,1,1},0);
    pres=check(quiz_tmp);
    if all(pres>0) && double(quiz.feas)<0 % found a feasible solution 
      disp('The proposed state-feedback is already a solution')
    end
    for nbperf=1:size(quiz.tmp,1)
      Ga=double(quiz.vars{2,1,nbperf+1});
      quiz_out.lmi=replace(quiz_out.lmi,quiz.vars{2,1,nbperf+1},Ga);
      switch quiz.tmp{nbperf,3}
        case {'h2','i2p'}
          Gb=double(quiz.vars{3,1,nbperf+1});
          quiz_out.lmi=replace(quiz_out.lmi,quiz.vars{3,1,nbperf+1},Gb);
      end
    end
  else
    error('2nd input arg. is of the wrong type')
  end
  
end

