function quiz = ctrpb(varargin)
% CTRPB - define an analysis or synthesis control problem
%   
% quiz = ctrpb (type, method)
%	
%    <type> : TYPE OF CONTROL PROBLEM
%    ='a' or 'analysis'        
%      defines an analysis problem
%    ='sf' or 'state-feedback' 
%      defines a state-feedback design problem
%
%    <method> : METHOD USED TO DERIVE LMIs (choice of Lyapunov matrices)
%    ='Lyap unique', 'unique' or 'PILF' (default)     
%      LMIs based on "Lyapunov Shaping Paradim" i.e. a unique Lyapunov
%      matrix for all uncertainties and performances
%    ='PDLF'
%      LMIs are dervied for proving performances with parameter-dependent
%      Lyapunov matrices. For LFT systems these are quadratic with respect
%      to del*(I-Ddd*del)^-1*Cd). For polytopic systems these are
%      polytopic. For multi-objective design problems of polytopic systems,
%      distinct Lyapunov matrices are used for each perfromance. 
%
% quiz = ctrpb (type, method, 'rand')
%
%    Without the 'rand' option, the robustness analysis or design problems
%    are treated assuming robustness should be guaranteed for all
%    deterministic uncertainties and in a probabilistic sense for
%    uncertainties defined as distributions. With the 'rand' option, all
%    LTI uncertainties are treated as if uniformly distributed.
%
% SEE ALSO stability, dstability, hinfty, h2, i2p, ctrpb/plus, ctrpb/solvesdp
      
%   This file is part of RoMulOC
%   Last Update 11-Nov-2013
%   authors : Dimitri Peaucelle, Philippe Spiesser, Maud Sevin
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France
  
  cstr=lmi;
  quiz.type=[0,0,0,0,0,0];
  % 1st entry : Type of problem
  % 1  => Analysis
  % 11 => State Feedback
  % 12 => State Feedback with ellipsoids
  % 21 => Full-order dynamic output feedback
  % 22 => Full-order dynamic output feedback wdith ellipsoids
  % 31 => Static output feedback 
  % 32 => Static output feedback with ellipsoids 
  % 41 => Fixed order output feedback 
  % 2nd entry : Applied method 
  % 1  => quadratic stability 
  % 2 => same as upper but with LTI blocks treated as unif. dist.
  % 3 => same as upper but with LTV blocks treated as unif. dist.
  % 4 => same as upper but with NL blocks treated as unif. dist.
  % 11 => PDLF with P(Del)=[1 C'*Del_a']P[1 ; Del_a*C]
  % 12 => same as upper but with LTI blocks treated as unif. dist.
  % 13 => same as upper but with LTV blocks treated as unif. dist.
  % 14 => same as upper but with NL blocks treated as unif. dist.
  % 21 => PDLF with P(Del)=Sum zeta_i P_i AND slack variables
  % 22 => same as upper but with sampling of uncertainties
  % 31 => PDLF but of undefined type (11 or 21) t.b.d. depending on system
  % 32 => same as upper but with sampling of LTI uncertainties
  % 33 => same as upper but with sampling of LTV uncertainties
  % 34 => same as upper but with sampling of NL uncertainties
  % 3rd entry : Number of measured outputs 
  %             (order of system if state feedback)
  % 4th entry : Number of control inputs
  % 5th entry : Order of the controller
  % 6th entry : Type of resolution to be aplied
  % 1 => for probabilistic analysis methods
  % 2 => for probabilistic LMI design methods
  % 3 => for robust LMI methods (default)
  quiz.name={};   % 2D cell of tags defining the problem
		  % 1st column contains names of systems
		  % 2nd column contains the specified performance names 
  quiz.vars={};   % 3D cell of variables 
		  % 1st column contains the SDPVAR objects
		  % 2nd column contains tags for each variable
      % 1st layer (in 3rd dimension) contains vars common to all performnaces
      % ith layer contains vars specific to performance of row i-1 in quiz.name
  quiz.obj=[];    % SDPVAR object containing the performance objective
  quiz.objt=[];   % array containing the definition of the objective
                  % 1st column contains the performance's index 
                  %%% !! in version after oct 2012 it's third arg of vars
                  % 2nd column contains the performance's weight
  quiz.feas=[];   % SDPVAR object containing a feasibility index (for BMI problems)
  quiz.feast=[];  % array containing the definition of the feasibility index
                  % 1st column contains the performance's index 
                  %%% !! in version after oct 2012 it's third arg of vars
                  % 2nd column contains the performance's weight
  quiz.result={'','';'','';'result=NaN;',''}; 
  % cell of controls telling what to conclude
  % 1st row if feasible solution found
  % 2nd row if problem is infeasible
  % 3rd row if feasibility is undetermined
  % 1st col is what to do
  % next cols is what to display
  quiz.tmp={};    % cell of tags defining the problem with 5 args
                  % 1st column contains the first argument
                  % 2nd column contains the second argument
                  % 3th column contains the third argument
                  % 4th column contains weight on objective or feasibility index
  quiz.forWC=[];  % Array used to compute worst case uncertainties 
                  % based on dual LMI variables 
                  % in case of polytopic ussmodels
                  % As many rows as there are vertices
                  % As many columns as LMIs to test on each vertex
                  % Values are the indexes of the LMIs
  quiz.forRACT={};% cell array each row contains
                  % the function to call <@something>
                  % the performance to test
                  % the uncertain system
  quiz=class(quiz,'ctrpb',cstr); % cstr is a LMI object of all constraints
  
  switch nargin
   case 0
     error('1st imput arg. should indicate which control problem is to be considered');
   case 1
    if isa(varargin{1},'ctrpb');
      quiz=varargin{1};
    elseif isnumeric(varargin{1})
      if any(varargin{1}(1)==[1 11 21]) && any(varargin{1}(2)==[1 11 21])
        quiz.type(1:2)=varargin{1}(1:2);
      else 
        error('wrong usage of CTRPB');
      end
    elseif ischar(varargin{1})
      quiz.type(1) = isproblem(varargin{1});
      quiz.type(2) = 1;
    else
      error('wrong usage of CTRPB');
    end
   case 2
    quiz.type(1) = isproblem(varargin{1});
    if any(ismember({'randomized',...
                     'rand'}, lower(varargin{2})))
      quiz.type(2)=2;
    else
      quiz.type(2) = ismethod(varargin{2});
    end
    case {3,4}
      if isa(varargin{1}, 'ssmodel') || isa(varargin{1}, 'ussmodel')
        [sys, var, fct, name, perf] = isperformance(varargin);
        quiz.tmp{1} = sys;
        quiz.tmp{2} = var;
        quiz.tmp{3} = fct;
        quiz.tmp{4} = 1;
        quiz.name{1} = name;
        if any(ismember({'h2', 'hinfty', 'i2p'}, fct))
          if var
            quiz.name{2} = sprintf('%s < %g', perf, var);
          else
            quiz.name{2} = sprintf('Minimize %s', perf);
            quiz.tmp{4}=1;
          end
        else
          quiz.name{2} = perf;
        end
      else
        quiz.type(1) = isproblem(varargin{1});
        quiz.type(2) = ismethod(varargin{2});
        if any(ismember({'randomized',...
                         'rand'}, lower(varargin{3})))
          quiz.type(2)=quiz.type(2)+1;
        else
          % Not considered
        end
      end
  end
end

%
% Internal functions
%
  
%%%%%%%%%%%%%
function val = isproblem(a)
  if ~ischar(a)
    error('wrong usage of CTRPB');
  elseif any(ismember({'a','analysis'}, lower(a)))
    val = 01;
  elseif any(ismember({'sf','state-feedback'}, lower(a)))
    val = 11;
%  elseif any(ismember({'foof','full-order output-feedback'}, lower(a)))
%    val = 21;
  else
    error('Sorry but this type problem (1st input arg.) is not coded yet.');
  end
end

%%%%%%%%%%%%%
function val = ismethod(a)
  if ~ischar(a)
    error('wrong usage of CTRPB');
  elseif any(ismember({'lyap unique',... 
                       'unique',... 
                       'pilf'}, lower(a)))
    val = 01;
  elseif any(ismember({'quad-pdlf',...
                       'quadratic-pdlf'}, lower(a)))
    val = 11;
  elseif any(ismember({'polytopic-pdlf',... 
                       'polytope',...
                       'poly'}, lower(a)))
    val = 21;
  elseif any(ismember({'pdlf',...
                      'parameter-dependent'},lower(a)))
    val = 31;
  else
    error('Sorry but this type method (2nd input arg.) is not coded yet.');
  end
end

%%%%%%%%%%%%%
function [sys, var, fct, name, perf] = isperformance(arg)
  
  if isa(arg{1}, 'ssmodel') || isa(arg{1}, 'ussmodel')
    sys = arg{1};
    if isempty(sys.name)
      name = 'no name';
    else
      name = sys.name;
    end
  else
    error('arg1. must be either a SSMODEL or a USSMODEL object');
  end
  
  if isempty(arg{2})
    var = 0;
  elseif isnumeric(arg{2}) || isa(arg{2}, 'region')
    var = arg{2};
  else
    error('arg2 perf must be either empty or a numeric or a REGION object');
  end
  
  if ~ischar(arg{3})
    error('wrong usage of CTRPB');
  elseif any(ismember({'stability'}, lower(arg{3})))
    var=[];
    fct = 'stability';
    perf = 'Stability';
  elseif any(ismember({'dstability'}, lower(arg{3}))) && isa(var, 'region')
    fct = 'dstability';
    perf = 'D-stability';
  elseif any(ismember({'h2'}, lower(arg{3}))) && isnumeric(var)
    fct = lower(arg{3});
    perf = 'H2';
  elseif any(ismember({'hinfty'}, lower(arg{3}))) && isnumeric(var)
    fct = lower(arg{3});
    perf = 'Hinfty';
  elseif any(ismember({'i2p'}, lower(arg{3}))) && isnumeric(var)
    fct = lower(arg{3});
    perf =  'I2P';
  else
    error('arg3 fct wrong usage of CTRPB');
  end
      
end
 
