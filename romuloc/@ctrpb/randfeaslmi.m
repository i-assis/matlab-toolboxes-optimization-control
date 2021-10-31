function [status,diagnostic] = randfeaslmi(quiz, verbose, opts)
% Internal RoMulOC function - finds a feasible solution of uncertain LMI

%   This file is part of RoMulOC
%   Last Update 7-Nov-2014
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

% It is a RoMulOC version of <feaslmi.m> from the RACT toolbox
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
diagnostic.inittime = clock;
diagnostic.first_it_asample_feasible = 0;

% Set initial gues of variables (depending on opts)
switch opts.init
  case 'random'
    x=randn(length(all_nums),1);
    assign(recover(all_nums),x);
  case {'LMInominal','LMIrandom'}
    lvars = size(vars,1);
    cvars = size(vars,2);
    varsglob = reshape(vars(:,:,1),lvars,cvars);
    lmi_init = quiz.lmi;
    forRACT = quiz.forRACT;
    nbperf = size(forRACT,1);
    for perfid=1:nbperf
      if opts.init(4)=='n' && mod(quiz.type(2),10)==1
        sys_init=nominal_prob(forRACT{perfid,3});
      else
        sys_init=forRACT{perfid,3};
        for jj=1:mod(quiz.type(2),10)
          sys_init=usample(sys_init);
        end
      end
      varsloc = reshape(vars(:,:,perfid+1),lvars,cvars);
      lmi_init = lmi_init +...
        feval(forRACT{perfid,1},...
              sys_init,...
              forRACT{perfid,2},...
              varsglob,...
              varsloc);
    end
    lmi_init=replace(lmi_init,quiz.vars{1,1,1},LMIprecision);
    assign(quiz.vars{1,1,1},0);
    solvesdp(lmi_init,[],opts.sdpopts);
    fprintf('\n');
  otherwise
    error('Erroneous value for field <init> of randsettings');
end
vars0=cell(size(vars,1),1,size(vars,3));
for ii=1:size(vars,1)
  for kk=1:size(vars,3)
    vars0{ii,1,kk}=double(vars{ii,1,kk});
  end
end
diagnostic.inittime = etime(clock,diagnostic.inittime);
diagnostic.solvertime = clock;

% pstar - eps
if verbose
  fprintf('Looking for a probabilistic solution to uncertain LMIs defined by\n');
  fprintf('  Prob{ P > %g } < %g\n',opts.epsilon,opts.delta);
  fprintf('where P is the probability for an other sample to violate the LMIs\n\n');
end

textdisp='';
outerNit=0;
while ~feasible && outerNit<opts.Nout
  outerNit=outerNit+1;
  % cast probabilistic oracle with some number of samples
  % pstar - eps
  Nin = ceil((0.5 + 2*log(outerNit) + log(1/opts.delta))/log(1/(1-opts.epsilon)));
  Nin = min(Nin,opts.maxsamples);
  if outerNit==1
    % reconstruct x-as-vector by x-by-cells
    % fill x with corresponding values of x0 - column vector!
    switch opts.method
      case 'cutplane' 
        %%% WARNING : not tested for romuloc
        % for cutting plane method we use analytic center as initial point
        [xc] = cheby_center(opts.A, opts.b);
        xac = analytic_center(opts.A, opts.b, xc);
        if xac == 0 % zero is a very bad starting point!!
          xac = 1e-5*ones(size(xac))/numel(xac);
        end
        %%% Dimitri changed x to a vector of length the same as all_num
        %x(all_nums) = xac; % move from compact to sparse representation
        x = xac; % move from compact to sparse representation
      case 'ellipsoid'
        x = megaassign_rmoc(vars, vars0, all_nums);
        if max(abs(x))<1e-6 % zero is a very bad starting point!!
          x = 1e-5*ones(size(x))/numel(x);
        end
        if ~isfield(opts,'R')
%        opts.R=1e-1*eye(size(x,1));
          opts.R=inv((eye(size(x,1))+x*x.')/norm(x)^2);
        end
      otherwise
        x = megaassign_rmoc(vars, vars0, all_nums);
        if max(abs(x))<1e-6 % zero is a very bad starting point!!
          x = 1e-5*ones(size(x))/numel(x);
        end
    end    
    %%% Dimitri changed x to a vector of length the same as all_num
    %    assign(recover(all_nums), full(x(all_nums)));
    assign(recover(all_nums), x);
  end
  % oracle
  %  [feasible, Ninter, LMI_viol] = lmiporacle(quiz,Nin,LMIprecision);
  quiz.lmi=replace(quiz.lmi,quiz.vars{1,1,1},LMIprecision);
  assign(quiz.vars{1,1,1},LMIprecision);
  [feasible, Ninter, LMI_viol] = lmiporacle(quiz,Nin,LMIprecision);
  if ~diagnostic.first_it_asample_feasible && Ninter>1
    diagnostic.first_it_asample_feasible = outerNit;
  end
  if feasible
    status=1;
    if verbose
      for jj=1:length(textdisp);
        fprintf('\b');
      end
      fprintf('Iter #%i : Oracle passed %i tests, solution is found!\n',outerNit,Ninter);
    end
  else
    if verbose
      for jj=1:length(textdisp);
        fprintf('\b');
      end
      textdisp=sprintf('Iter #%i : Oracle stopped on test %i out of %i needed',outerNit,Ninter,Nin);
      fprintf('%s',textdisp);
    end
    maxorall=1;% 1 for max / 0 for all
    if maxorall
      % function to find a maximum violated LMI
      [~, Imax] = findmaxviol(LMI_viol, opts.lmifunc);
      % Extract the Fi basis of the maximum violated LMI
      Fi_base = getbase(sdpvar(LMI_viol(Imax)));
      % Push the LMI feasibility problems away from zero
      % (trick used in Romuloc to hamonize numerically all such problems)
      Fi_base(:,1)=Fi_base(:,1)-LMIprecision*reshape(eye(sqrt(size(Fi_base,1))),[],1);
      % Get the variables involved in that LMI (only these will be updated)
      Fi_vars_ind = getvariables(LMI_viol(Imax));
      switch opts.method
        case 'gradient'
          % note minus !! (YALMIP has constraints in form F > 0, and we use F < 0
          upgraded = lmiupdgrad(-(Fi_base), (double(recover(Fi_vars_ind))), opts);
          assign(recover(Fi_vars_ind),upgraded);% set YALMIP decision variables (=design parameters) to new values
        case 'ellipsoid'
          pack_ind = intintersect(Fi_vars_ind, all_nums);
          %        [x_packed, opts.R] = lmiupdell(-Fi_base, x(all_nums), pack_ind, opts);
          [x_packed, opts.R] = lmiupdell(-Fi_base, x, pack_ind, opts);
          %        prod(eig(opts.R))
          %        x(all_nums) = x_packed;
          x = x_packed;
          %        assign(recover(all_nums), x(all_nums)); % set YALMIP decision variables (=design parameters) to a current point
          assign(recover(all_nums), x); % set YALMIP decision variables (=design parameters) to a current point
          % assign(recover(Fi_vars_ind), x(Fi_vars_ind)); - for gradient is enough
        case 'cutplane'
          %%% WARNING : not modified for romuloc
          % need also full vector of variables, not only 'gradient'-calculated ones
          %        aaa = nonzeros(all_nums); % pack indices of internal YALMIP vars
          %        bbb = nonzeros(Fi_vars_ind);
          %        [c, ia, ib] = intersect(aaa, bbb); % collect indices of 'grad'-variables how they appear in full-indexes vector
          %        pack_ind = ib;
          pack_ind = intintersect(Fi_vars_ind, all_nums);
          %        [x_packed, opts.A, opts.b] = lmiupdcutplane(-Fi_base, x(all_nums), pack_ind, opts);
          [x_packed, opts.A, opts.b] = lmiupdcutplane(-Fi_base, x, pack_ind, opts);
          %        x(all_nums) = x_packed;
          x = x_packed;
          %        assign(recover(all_nums), x(all_nums)); % set YALMIP decision variables (=design parameters) to a current point
          assign(recover(all_nums), x); % set YALMIP decision variables (=design parameters) to a current point
          % assign(recover(Fi_vars_ind), x(Fi_vars_ind)); - for gradient is enough
        otherwise
          error('Erroneous value for field <method> of randsettings');
      end
    else
      for ii=1:size(LMI_viol)
        % Extract the Fi basis of the maximum violated LMI
        Fi_base = getbase(sdpvar(LMI_viol(ii)));
        % Push the LMI feasibility problems away from zero
        % (trick used in Romuloc to hamonize numerically all such problems)
        Fi_base(:,1)=Fi_base(:,1)-LMIprecision*reshape(eye(sqrt(size(Fi_base,1))),[],1);
        % Get the variables involved in that LMI (only these will be updated)
        Fi_vars_ind = getvariables(LMI_viol(ii));
        switch opts.method
          case 'gradient'
            % note minus !! (YALMIP has constraints in form F > 0, and we use F < 0
            upgraded = lmiupdgrad(-(Fi_base), (double(recover(Fi_vars_ind))), opts);
            assign(recover(Fi_vars_ind),upgraded);% set YALMIP decision variables (=design parameters) to new values
          case 'ellipsoid'
            pack_ind = intintersect(Fi_vars_ind, all_nums);
            %        [x_packed, opts.R] = lmiupdell(-Fi_base, x(all_nums), pack_ind, opts);
            [x_packed, opts.R] = lmiupdell(-Fi_base, x, pack_ind, opts);
            %        prod(eig(opts.R))
            %        x(all_nums) = x_packed;
            x = x_packed;
            %        assign(recover(all_nums), x(all_nums)); % set YALMIP decision variables (=design parameters) to a current point
            assign(recover(all_nums), x); % set YALMIP decision variables (=design parameters) to a current point
            % assign(recover(Fi_vars_ind), x(Fi_vars_ind)); - for gradient is enough
          case 'cutplane'
            %%% WARNING : not modified for romuloc
            % need also full vector of variables, not only 'gradient'-calculated ones
            %        aaa = nonzeros(all_nums); % pack indices of internal YALMIP vars
            %        bbb = nonzeros(Fi_vars_ind);
            %        [c, ia, ib] = intersect(aaa, bbb); % collect indices of 'grad'-variables how they appear in full-indexes vector
            %        pack_ind = ib;
            pack_ind = intintersect(Fi_vars_ind, all_nums);
            %        [x_packed, opts.A, opts.b] = lmiupdcutplane(-Fi_base, x(all_nums), pack_ind, opts);
            [x_packed, opts.A, opts.b] = lmiupdcutplane(-Fi_base, x, pack_ind, opts);
            %        x(all_nums) = x_packed;
            x = x_packed;
            %        assign(recover(all_nums), x(all_nums)); % set YALMIP decision variables (=design parameters) to a current point
            assign(recover(all_nums), x); % set YALMIP decision variables (=design parameters) to a current point
            % assign(recover(Fi_vars_ind), x(Fi_vars_ind)); - for gradient is enough
          otherwise
            error('Erroneous value for field <method> of randsettings');
        end
      end
    end
  end

end
if verbose
  fprintf('\n');
end
if feasible
  status = 1;
  if Nin==opts.maxsamples
    diagnostic.warning='maxsamples reached, no probabilistic guarantee';
    if verbose
      disp('Warning: maxsamples reached, no probabilistic guarantee');
    end
  end
else
  status = -1;
  if verbose
    disp('Stopped because Nout reached - problem assumed unfeasible');
  end
end

diagnostic.nb_outer_it = outerNit;
diagnostic.nb_feas_samples = Ninter;
diagnostic.nb_feas_samples_needed = Nin;
diagnostic.solvertime = etime(clock,diagnostic.solvertime);

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

% assign to decision variables the inital values and get the vector
function x = megaassign_rmoc(vars, vars0, all_nums)
for ii=1:size(vars,1)
  for jj=1:size(vars,3)
    % fill sdpvars design variables with values given
    if ~isempty(vars0{ii,1,jj})
      assign(vars{ii,1,jj}, vars0{ii,1,jj});
    end
  end
end
x = double(recover(all_nums));
end

% function to find a most violated LMI
function [v, Imax] = findmaxviol(anLMI, funcname)
% Imax is number of maxim. violated inequality in 'opt.lmifunc' sense
switch funcname
  case 'maxeig' % maximum eigenvalue
    % note 'min', cause in YALMIP constraints are in form F > 0
    [v, Imax] = max(-double(check(anLMI))); 
  case 'fronorm' % either maximum frobenius norm
     fronorm_vio = zeros(1,size(anLMI));
     for m = 1:size(anLMI)
       % again note minus sign for YALMIP constraints representation
       fronorm_vio(m) = norm(plusprojm(-double(anLMI(m))), 'fro');
     end
     [v, Imax] = max(fronorm_vio);
  otherwise
    error('Cannot find a most violated constraints.');
end
end

% return indexes of elements 'vec' in vector 'full_vec' in the order how
% they appear there (supposed all elements are in full_vec)
function ind = intintersect(vec, full_vec)
ind = zeros(size(vec));
n = length(ind);
fv_cnt = 1;
try
  for k = 1:n
    while vec(k) ~= full_vec(fv_cnt)
      fv_cnt = fv_cnt + 1; % move along bigger vector
    end
    ind(k) = fv_cnt;
    fv_cnt = fv_cnt + 1;
  end
catch
  error(['RACT:feas_clmi:InternalError', 'Some YALMIP decision variable indexing error happens. Please inform!']);
end
end

