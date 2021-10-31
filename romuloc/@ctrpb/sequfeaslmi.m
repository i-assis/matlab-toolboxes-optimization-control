function [pres,diagnostic] = sequfeaslmi(quiz, verbose, opts)
% Internal RoMulOC function - sequential scenario search for solutions of uncertain LMI

%   This file is part of RoMulOC
%   Last Update 13-Oct-2015
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

% It is a RoMulOC version of <seqoptfull.m> by Chamanbaz
% Please cite "M. Chamanbaz, F. Dabbene, R. Tempo, V. Venkataramanan,
% and Q.-G. Wang, “Sequential Randomized Algorithms for Convex Optimization in the Presence of
% Uncertainty,” IEEE Transactions on Automatic Control, 2013, Submitted.
% See Also arXiv:1304.2222 [cs.SY]."
%
% quiz has replaced hLMI
% vars0 has replaced x0
% opts has replaced options

% collect internal Yalmip numbers for decision variables
vars=quiz.vars;
%vars={vars{:,1,:}};
all_nums = getcellvars_rmoc(vars);

% Some tuning values
LMIprecision=1/length(all_nums); % same as for LMIsolvers 

%default outputs 
feasible = 0;
status = 0;
%%% diagnostic.inittime = clock;
%%% diagnostic.first_it_asample_feasible = 0;

% get number of samples needed for scenario approach
nb_samples_scen = scensamplenb(opts.epsilon,opts.delta/2,length(all_nums));
% get number of iteration of the sequential scenario
nb_sequ = opts.sequscenit;
% parameter involved in nb_samples_validation
alfa=0.1;
Skt=0; for kk=1:nb_sequ-1, Skt=Skt+1/(kk^alfa);end

for kk=1:nb_sequ % iteration of scenarios + validations
    %%% Scenario step
    nb_samples=ceil(nb_samples_scen*kk/nb_sequ);
    if verbose
        fprintf('%i-th Scenario method is applied.\n',kk);
        fprintf('Currently generating the LMIs for %i samples of the uncertain plants\n',nb_samples)
    end
    % get some data from quiz
    scenlmi=quiz.lmi;
    forRACT = quiz.forRACT;
    nbperf = size(forRACT,1);
    lvars = size(vars,1);
    cvars = size(vars,2);
    varsglob = reshape(vars(:,:,1),lvars,cvars);
    buildlmitime = clock;
    for iisamples=1:nb_samples;
        for perfid=1:nbperf
            sys=usample(forRACT{perfid,3});
            varsloc = reshape(vars(:,:,perfid+1),lvars,cvars);
            %add the lmis relative to that sample and that performance
            scenlmi = scenlmi +...
                feval(forRACT{perfid,1},...
                sys,...
                forRACT{perfid,2},...
                varsglob,...
                varsloc);
        end
    end
    buildlmitime = etime(clock,buildlmitime);
    if verbose
        fprintf('Now solving the LMIs\n')
    end
    if isempty(quiz.obj)
        scenlmi=replace(scenlmi,quiz.vars{1,1,1},LMIprecision);
        diagnostic=solvesdp(scenlmi,quiz.feas,opts.sdpopts);
    else
        scenlmi=replace(scenlmi,quiz.vars{1,1,1},0);
        diagnostic=solvesdp(scenlmi,quiz.obj,opts.sdpopts);
    end
    %%% Validation step
    nb_samples_valid=ceil((alfa*log(kk)+log(Skt)+log(2/opts.delta))/log(1/(1-opts.epsilon)));
    if verbose
        fprintf('%i-th validation method is applied.\n',kk);
        fprintf('It should satisfy the LMIs for %i samples of the uncertain plants\n',nb_samples_valid)
    end
    [val_feas, ~, ~] = lmiporacle(quiz,nb_samples_valid,0);
    if val_feas
        fprintf('Validation succeeded\n\n');
        break
    else
        fprintf('Validation failed\n');
    end    
end
assign(quiz.vars{1,1,1},0);
pres=check(scenlmi);
infoscenlmi=lmiinfo(scenlmi);
diagnostic.nb_rows=sum(infoscenlmi.sdp(:,1));
diagnostic.nb_vars=length(getvariables(scenlmi));
diagnostic.last_scen_nb_samples = nb_samples;
diagnostic.last_validation_nb_samples = nb_samples_valid;
diagnostic.last_scen_buildlmitime=buildlmitime;    
end

%%% Internal functions

% get all indexes of scalar decision variables
function all_nums = getcellvars_rmoc(vars)
all_nums=[];
  for ii=1:size(vars,1)
    for kk=1:size(vars,3)
      if ~isempty(vars{ii,1,kk})
        loc_nums = getvariables(vars{ii,1,kk});
        all_nums = union(all_nums,loc_nums);
      end
    end
  end
end

