function [pres,diagnostic] = scenfeaslmi(quiz, verbose, opts)
% Internal RoMulOC function - scenario search for solutions of uncertain LMI

%   This file is part of RoMulOC
%   Last Update 13-Oct-2015
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

% It is a RoMulOC version of <scenlmi.m> from the RACT toolbox
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

%get number of samples needed for the required options
nb_samples = scensamplenb(opts.epsilon,opts.delta,length(all_nums));
% pstar - eps
if verbose
  fprintf('Scenario method is applied.\n');
  fprintf('Currently generating the LMIs for %i samples of the uncertain plants\n',nb_samples)
end

%get some data from quiz
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
if verbose
  fprintf('Now solving the LMIs\n')
end
buildlmitime = etime(clock,buildlmitime);
if isempty(quiz.obj)
    scenlmi=replace(scenlmi,quiz.vars{1,1,1},LMIprecision);
    diagnostic=solvesdp(scenlmi,quiz.feas,opts.sdpopts);
else
    scenlmi=replace(scenlmi,quiz.vars{1,1,1},0);
    diagnostic=solvesdp(scenlmi,quiz.obj,opts.sdpopts);
end
assign(quiz.vars{1,1,1},0);
pres=check(scenlmi);
diagnostic.buildlmitime=buildlmitime;
diagnostic.nb_samples = nb_samples;
diagnostic.nb_vars=length(getvariables(scenlmi));
infoscenlmi=lmiinfo(scenlmi);
diagnostic.nb_rows=sum(infoscenlmi.sdp(:,1));

    
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

