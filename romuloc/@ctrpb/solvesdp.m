function [result,status,diagnostic,wc] = solvesdp(quiz,varargin)
% CTRPB/SOLVESDP - Solve SDP problem stored in a CTRPB object
%
% [result,status,diagnostic] = solvesdp(quiz[[,opt]|[,verb]])
%
%   INPUT
%     quiz : a CTRPB object (SEE ctrpb)
% Optional arguments:
%     opt  : solver options
%            If <quiz> is an LMI optimisation problem
%               then <opt=sdpsettings(...)> (SEE sdpsettings)
%            If <quiz> is a randomized method problem
%               then <opt=randsettings(...)> (SEE randsettings)
%     verb : logical value to display more results (Default is true)
%
%   OUTPUT
%     result     : numeric solution of the control problem
%     status     : numeric value
%                  1 if problem is feasible,
%                  0 if problem is infeasible,
%                  negative value (worst constraint residual)
%                      if feasability is not determined
%     diagnostic : Diagnostic information from YALMIP
%
% [result,status,diagnostic,wc] = solvesdp(quiz[[,opt]|[,verb]])
%
% For some LMI problems (for the moment limited to analysis problems of
% polytopic systems), a computation step using the dual-SDP solution allows
% to extract a worst case candidate. When called with fourth output
% argument, and when possible, the output <wc> contains this worst case
% estimate. <wc> is a structure with fields
% wc.xi = the simplex vector defining the combination of vertices
% wc.iswc = if 'true' the worst case estimate is guaranteed to be one
% wc.sys = ssmodel of the plant at the worst case estimate
%
%   SEE ALSO ctrpb, solvesdp, sdpsettings

%   This file is part of RoMulOC
%   Last Update 26-Fev-2015
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

if nargin==1
    options=[];
    if nargout==0
        verbose=true;
    else
        verbose=true;
    end
elseif length(varargin)==1
    if isstruct(varargin{1})
        options=varargin{1};
        verbose=true;
    else
        options=[];
        verbose=varargin{1};
    end
else
    if isstruct(varargin{1})
        options=varargin{1};
        verbose=varargin{2};
    else
        options=varargin{2};
        verbose=varargin{1};
    end
end

%%%%%%%%%%%%%%%%%%%%%%
% Compute the objective functions
if ~isempty(quiz.objt) % could be empty in randomized analysis methods
    if any(quiz.objt(:,2)) % there are performances to optimize
        for ii=1:size(quiz.feast,1) % freeze to zero any feasibility indicator
            if quiz.feast(ii,2)
                quiz.lmi=replace(quiz.lmi,quiz.vars{1,1,ii+1},0);
                assign(quiz.vars{1,1,ii+1},0);
            end
        end
        quiz.obj=0;
        for ii=1:size(quiz.objt,1)
            if ~isempty(quiz.vars{1,1,ii+1})
                quiz.obj=quiz.obj+quiz.objt(ii,2)*quiz.vars{1,1,ii+1};
            end
        end
    elseif any(quiz.feast(:,2))
        quiz.feas=0;
        for ii=1:size(quiz.feast,1)
            if ~isempty(quiz.vars{1,1,ii+1})
                quiz.feas=quiz.feas+quiz.feast(ii,2)*quiz.vars{1,1,ii+1};
            end
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%
switch quiz.type(6)
    case 1 %%% we are in randomized analysis methods
        if isempty(options)
            options = randsettings;
        end
        [result,status,diagnostic] = randanalysis(quiz,verbose,options);
    case 2 % Randomized LMI feasibility
        if isempty(options)
            options = randsettings;
        elseif ~isfield(options,'sdpopts')
            opts = randsettings;
            opts.sdpopts=options;
            options=opts;
        end
        if isequal(options.method,'scenario')
            [pres,diagnostic] = scenfeaslmi(quiz,verbose,options);
            nbperf=size(quiz.name,1);
            if ~isempty(quiz.feas)
                if all(pres>0) && double(quiz.feas)<=0 % found a feasible solution
                    if verbose
                        for ii=2:(1+nbperf)
                            eval(quiz.result{1,ii});
                        end
                    end
                    eval(quiz.result{1,1});
                    status=1;
                elseif diagnostic.problem==1 % Found infeasibility certificate
                    if verbose
                        fprintf('\nInfeasible problem\n');
                        for ii=2:(1+nbperf)
                            eval(quiz.result{2,ii});
                        end
                    end
                    eval(quiz.result{2,1});
                    status=0;
                else % Cannot conclude
                    if verbose
                        fprintf('\nFeasibility is not acheived');
                        if all(~isnan(pres))
                            fprintf('\nIndicator of distance to feasibility is %g > 0\n',double(quiz.feas));
                        end
                        for ii=2:(1+nbperf)
                            eval(quiz.result{2,ii});
                        end
                    end
                    eval(quiz.result{1,1});
                    status=-double(quiz.feas);
                end
            else % general case
                if all(pres>0) % found a feasible solution
                    if verbose
                        for ii=2:(1+nbperf)
                            eval(quiz.result{1,ii});
                        end
                        fprintf('Assessments are in a probabilistic sense:\n');
                        fprintf('  Prob{ P > %g } < %g\n',options.epsilon,options.delta);
                        fprintf('where P is the probability for an other sample to violate the LMIs\n\n');
                    end
                    eval(quiz.result{1,1});
                    if sum(quiz.objt(:,2)~=0)>1
                        display_multi_obj(quiz);
                    end
                    status=1;
                elseif diagnostic.problem==1 % Found infeasibility certificate
                    if verbose
                        fprintf('\nInfeasible problem\n');
                        for ii=2:(1+nbperf)
                            eval(quiz.result{2,ii});
                        end
                    end
                    eval(quiz.result{2,1});
                    status=0;
                else % Cannot conclude
                    if verbose
                        fprintf('\nFeasibility is not strictly determined');
                        if all(~isnan(pres))
                            fprintf('\nWorst constraint residual is %g < 0\n',min(pres));
                        end
                        for ii=2:(1+nbperf)
                            eval(quiz.result{3,ii});
                        end
                    end
                    eval(quiz.result{1,1});
                    if sum(quiz.objt(:,2)~=0)>1
                        display_multi_obj(quiz);
                    end
                    status=min(pres);
                end
            end
            if verbose
                fprintf('\n');
            end
        elseif isequal(options.method,'sequential')
            [pres,diagnostic] = sequfeaslmi(quiz,verbose,options);
            nbperf=size(quiz.name,1);
            if ~isempty(quiz.feas)
                if all(pres>0) && double(quiz.feas)<=0 % found a feasible solution
                    if verbose
                        for ii=2:(1+nbperf)
                            eval(quiz.result{1,ii});
                        end
                    end
                    eval(quiz.result{1,1});
                    status=1;
                elseif diagnostic.problem==1 % Found infeasibility certificate
                    if verbose
                        fprintf('\nInfeasible problem\n');
                        for ii=2:(1+nbperf)
                            eval(quiz.result{2,ii});
                        end
                    end
                    eval(quiz.result{2,1});
                    status=0;
                else % Cannot conclude
                    if verbose
                        fprintf('\nFeasibility is not acheived');
                        if all(~isnan(pres))
                            fprintf('\nIndicator of distance to feasibility is %g > 0\n',double(quiz.feas));
                        end
                        for ii=2:(1+nbperf)
                            eval(quiz.result{2,ii});
                        end
                    end
                    eval(quiz.result{1,1});
                    status=-double(quiz.feas);
                end
            else % general case
                if all(pres>0) % found a feasible solution
                    if verbose
                        for ii=2:(1+nbperf)
                            eval(quiz.result{1,ii});
                        end
                        fprintf('Assessments are in a probabilistic sense:\n');
                        fprintf('  Prob{ P > %g } < %g\n',options.epsilon,options.delta);
                        fprintf('where P is the probability for an other sample to violate the LMIs\n\n');
                    end
                    eval(quiz.result{1,1});
                    if sum(quiz.objt(:,2)~=0)>1
                        display_multi_obj(quiz);
                    end
                    status=1;
                elseif diagnostic.problem==1 % Found infeasibility certificate
                    if verbose
                        fprintf('\nInfeasible problem\n');
                        for ii=2:(1+nbperf)
                            eval(quiz.result{2,ii});
                        end
                    end
                    eval(quiz.result{2,1});
                    status=0;
                else % Cannot conclude
                    if verbose
                        fprintf('\nFeasibility is not strictly determined');
                        if all(~isnan(pres))
                            fprintf('\nWorst constraint residual is %g < 0\n',min(pres));
                        end
                        for ii=2:(1+nbperf)
                            eval(quiz.result{3,ii});
                        end
                    end
                    eval(quiz.result{1,1});
                    if sum(quiz.objt(:,2)~=0)>1
                        display_multi_obj(quiz);
                    end
                    status=min(pres);
                end
            end
            if verbose
                fprintf('\n');
            end
        elseif isequal(options.method,'violated')
            [pres,diagnostic] = violfeaslmi(quiz,verbose,options);
            nbperf=size(quiz.name,1);
            if ~isempty(quiz.feas)
                if all(pres>0) && double(quiz.feas)<=0 % found a feasible solution
                    if verbose
                        for ii=2:(1+nbperf)
                            eval(quiz.result{1,ii});
                        end
                    end
                    eval(quiz.result{1,1});
                    status=1;
                elseif diagnostic.problem==1 % Found infeasibility certificate
                    if verbose
                        fprintf('\nInfeasible problem\n');
                        for ii=2:(1+nbperf)
                            eval(quiz.result{2,ii});
                        end
                    end
                    eval(quiz.result{2,1});
                    status=0;
                else % Cannot conclude
                    if verbose
                        fprintf('\nFeasibility is not acheived');
                        if all(~isnan(pres))
                            fprintf('\nIndicator of distance to feasibility is %g > 0\n',double(quiz.feas));
                        end
                        for ii=2:(1+nbperf)
                            eval(quiz.result{2,ii});
                        end
                    end
                    eval(quiz.result{1,1});
                    status=-double(quiz.feas);
                end
            else % general case
                if all(pres>0) % found a feasible solution
                    if verbose
                        for ii=2:(1+nbperf)
                            eval(quiz.result{1,ii});
                        end
                        fprintf('Assessments are in a probabilistic sense:\n');
                        fprintf('  Prob{ P > %g } < %g\n',options.epsilon,options.delta);
                        fprintf('where P is the probability for an other sample to violate the LMIs\n\n');
                    end
                    eval(quiz.result{1,1});
                    if sum(quiz.objt(:,2)~=0)>1
                        display_multi_obj(quiz);
                    end
                    status=1;
                elseif diagnostic.problem==1 % Found infeasibility certificate
                    if verbose
                        fprintf('\nInfeasible problem\n');
                        for ii=2:(1+nbperf)
                            eval(quiz.result{2,ii});
                        end
                    end
                    eval(quiz.result{2,1});
                    status=0;
                else % Cannot conclude
                    if verbose
                        fprintf('\nFeasibility is not strictly determined');
                        if all(~isnan(pres))
                            fprintf('\nWorst constraint residual is %g < 0\n',min(pres));
                        end
                        for ii=2:(1+nbperf)
                            eval(quiz.result{3,ii});
                        end
                    end
                    eval(quiz.result{1,1});
                    if sum(quiz.objt(:,2)~=0)>1
                        display_multi_obj(quiz);
                    end
                    status=min(pres);
                end
            end
            if verbose
                fprintf('\n');
            end
        else
            [status,diagnostic] = randfeaslmi(quiz,verbose,options);
            nbperf=size(quiz.name,1);
            if status==1;
                if verbose
                    for ii=2:(1+nbperf)
                        eval(quiz.result{1,ii});
                    end
                end
                eval(quiz.result{1,1});
                if sum(quiz.objt(:,2)~=0)>1
                    display_multi_obj(quiz);
                end
            else
                if verbose
                    fprintf('\nInfeasible problem\n');
                    for ii=2:(1+nbperf)
                        eval(quiz.result{2,ii});
                    end
                end
                eval(quiz.result{2,1});
            end
        end
    case 3 % we are in LMI methods
        if ~all(is(quiz,'lmi'))
            error('1st input argument is not purely LMI, use <initialize> first')
        end
        if isempty(options)
            options = sdpsettings;
        end
        quiz.lmi=imag2reallmi(quiz.lmi);
        % Make 'shift' distinction between optimization and feasibility
        nbvars=length(getvariables(quiz.lmi));
        if isempty(quiz.obj)
            quiz.lmi=replace(quiz.lmi,quiz.vars{1,1,1},1/nbvars);
            diagnostic=solvesdp(quiz.lmi,quiz.feas,options);
        else
            quiz.lmi=replace(quiz.lmi,quiz.vars{1,1,1},0);
            diagnostic=solvesdp(quiz.lmi,quiz.obj,options);
        end
        assign(quiz.vars{1,1,1},0);
        
        nbperf=size(quiz.name,1);
        pres=check(quiz.lmi);
        
        if ~isempty(quiz.feas)
            if all(pres>0) && double(quiz.feas)<=0 % found a feasible solution
                if verbose
                    for ii=2:(1+nbperf)
                        eval(quiz.result{1,ii});
                    end
                end
                eval(quiz.result{1,1});
                status=1;
            elseif diagnostic.problem==1 % Found infeasibility certificate
                if verbose
                    fprintf('\nInfeasible problem\n');
                    for ii=2:(1+nbperf)
                        eval(quiz.result{2,ii});
                    end
                end
                eval(quiz.result{2,1});
                status=0;
            else % Cannot conclude
                if verbose
                    fprintf('\nFeasibility is not acheived');
                    if all(~isnan(pres))
                        fprintf('\nIndicator of distance to feasibility is %g > 0\n',double(quiz.feas));
                    end
                    for ii=2:(1+nbperf)
                        eval(quiz.result{2,ii});
                    end
                end
                eval(quiz.result{1,1});
                status=-double(quiz.feas);
            end
        else % general case
            if all(pres>0) % found a feasible solution
                if verbose
                    for ii=2:(1+nbperf)
                        eval(quiz.result{1,ii});
                    end
                end
                eval(quiz.result{1,1});
                if sum(quiz.objt(:,2)~=0)>1
                    display_multi_obj(quiz);
                end
                status=1;
            elseif diagnostic.problem==1 % Found infeasibility certificate
                if verbose
                    fprintf('\nInfeasible problem\n');
                    for ii=2:(1+nbperf)
                        eval(quiz.result{2,ii});
                    end
                end
                eval(quiz.result{2,1});
                status=0;
            else % Cannot conclude
                if verbose
                    fprintf('\nFeasibility is not strictly determined');
                    if all(~isnan(pres))
                        fprintf('\nWorst constraint residual is %g < 0\n',min(pres));
                    end
                    for ii=2:(1+nbperf)
                        eval(quiz.result{3,ii});
                    end
                end
                eval(quiz.result{1,1});
                if sum(quiz.objt(:,2)~=0)>1
                    display_multi_obj(quiz);
                end
                status=min(pres);
            end
            % end of LMI methods
        end
    otherwise
        error('Problem here - no specified solver method')
end

if nargout==4 && ~isempty(quiz.forWC) && size(quiz.tmp,1)==1
    %%% at this point we have not considered extracting WC for problems with
    %%% multiple performances (such as in state-feedback). But is it
    %%% relevant?
    [xi,iswc,syswc] = extractwc(quiz,quiz.tmp{1});
    wc.xi=xi;
    wc.iswc=iswc;
    wc.sys=syswc;
else
    wc=[];
end

end




%
% Internal functions
%
%%%%%%%%
function display_multi_obj(quiz)

out='Multi objective ';
for i = 1:1:size(quiz.objt,1)
    if quiz.objt(i,2) == 1
        out = [out, sprintf('CTRPB.vars{1,1,%i}', quiz.objt(i,1))];
    elseif quiz.objt(i,2)
        out = [out, ...
            sprintf('%g*CTRPB.vars{1,1,%i}', quiz.objt(i,2), quiz.objt(i,1))];
    end
    if i < size(quiz.objt,1)
        out = [out, ' + '];
    end
end
fprintf('\n%s is %g\n\n', out, double(quiz.obj));
end
