function [pres,diagnostic] = violfeaslmi(quiz, verbose, opts)
% Internal RoMulOC function - scenario with violated constraints search for solutions of uncertain LMI

% <quiz> is a ctrpb LMI problem to be solved
% <nbrem> is an integer : total nb of cinstraints to be removed

% The algorithm is based on approach presented at G. Calafiore, "Random Convex Programs,"
% SIAM J. Optimization, 2010.

%   This file is part of RoMulOC
%   Last Update 13-Oct-2015
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

% It is a RoMulOC version of <scenviol.m> by Chamanbaz
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
nbrem=opts.violnb;
nb_samples = violsamplenb(opts.epsilon,opts.delta,length(all_nums),nbrem);
nb_samples=100;
% pstar - eps
if verbose
    fprintf('Scenario with violated constraints method is applied.\n');
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
nbLMI(1)=length(scenlmi)+1;
forWC=zeros(nb_samples,2);
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
    nbLMI(2)=length(scenlmi);
    forWC(iisamples,:)=nbLMI;
    nbLMI(1)=nbLMI(2)+1;
end
buildlmitime = etime(clock,buildlmitime);

for testtype=1; % if you choose 2 then removes samples randomly - not recommended
    allLMIindexes=1:length(scenlmi);
    tempLMIindexes=allLMIindexes;
    allsamples=1:nb_samples;
    tmpsamples=allsamples;
    tempobj=Inf;
    keep=0;
    while nb_samples-length(allsamples)<opts.violnb
        if verbose
            fprintf('Now solving the scenario with %i samples',length(tmpsamples))
        end
        if isempty(quiz.obj)
            %scenlmi=replace(scenlmi,quiz.vars{1,1,1},LMIprecision);
            diagnostic=solvesdp(scenlmi(tempLMIindexes),quiz.vars{1,1,1},opts.sdpopts);
            if double(quiz.vars{1,1,1})<0
                disp('All constraints are feasible');
                break
            end
            quiz.obj=quiz.vars{1,1,1};
        else
            scenlmi=replace(scenlmi,quiz.vars{1,1,1},0);
            diagnostic=solvesdp(scenlmi(tempLMIindexes),quiz.obj,opts.sdpopts);
        end
        if double(quiz.obj)<=tempobj
            tempobj=double(quiz.obj);
            fprintf(' - Objective value = %g',tempobj);
            allLMIindexes=tempLMIindexes;
            allsamples=tmpsamples;
            keep=0;
        else
            fprintf(' No improvement')
            keep=[keep,wcidx];
        end
        %%% Now we shall try to use the dual vars to extract a worst case
        if testtype==1
            Dualvars =zeros(0,length(tmpsamples));
            colidx=0;
            for iisamples=tmpsamples;
                Dualvartmp=[];
                for jj=(forWC(iisamples,1):forWC(iisamples,2))
                    Dualvartmp=[Dualvartmp;reshape(dual(scenlmi(jj)),[],1)];
                end
                colidx=colidx+1;
                Dualvars(1:size(Dualvartmp,1),colidx)=Dualvartmp;
            end
            H = sum(Dualvars,2);
            [xi,fval] = quadprog(H'*H*eye(length(tmpsamples)),...
                -Dualvars'*H,...
                [],...
                [],...
                ones(1,length(tmpsamples)),...
                1,...
                0,...
                1,...
                1/length(tmpsamples)*ones(length(tmpsamples),1),...
                optimset('Display','off'));
            if abs(fval+norm(Dualvars,2)^2/2)<1e-4
                %disp('A proved worst case found')
            end
            [~,wcidxloc]=max(xi);
            wcidx=tmpsamples(wcidxloc);
            while any(keep==wcidx)
                xi(wcidxloc)=0;
                [~,wcidxloc]=max(xi);
                wcidx=tmpsamples(wcidxloc);
            end
            fprintf(' - Removing estimated worst case sample #%i',wcidx);
        else
            wcidxloc=max(keep)+1;
            wcidx=tmpsamples(wcidxloc);
            fprintf(' - Removing next sample #%i',wcidx);
        end
        fprintf('\n');
        tempLMIindexes=...
            allLMIindexes(all(...
            repmat(allLMIindexes,length(forWC(wcidx,:)),1)...
            ~=repmat(forWC(wcidx,:)',1,length(allLMIindexes))));
        tmpsamples=allsamples(allsamples~=wcidx);
    end
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

