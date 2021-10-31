function [result,status,diagnostic] = randanalysis(quiz,verbose,opts)
% Internal use only - called by ctrpb/solvesdp

%   This file is part of RoMulOC
%   Last Update 6-Mar-2013
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

nbperf=size(quiz.name,1);
for idperf=1:nbperf
  % test if performance validation or worst case computation
  if isa(quiz.forRACT{idperf,2},'region')
    perf=quiz.forRACT{idperf,2};
  elseif quiz.forRACT{idperf,2}
    perf=quiz.forRACT{idperf,2};
  else
    perf=[]; % worst case computation
  end
  % computing the number of samples needed
  if isempty(perf) % worst case computation
    nb_sample=wcsamplenb(opts.epsilon,opts.delta);
  else % reliability computation of performance
    nb_sample=chernoff(opts.epsilon,opts.delta);
  end
  nb_sample = min(nb_sample,opts.maxsamples);
  % tests are done with packets of samples
  size_pack=100;
  size_sample = ones(1,fix(nb_sample/size_pack))*size_pack;
  remainder=rem(nb_sample,size_pack);
  if remainder
    size_sample(end+1)=remainder;
  end
  time_spent=cputime;
  textdisp='';
  if isempty(perf) % worst case computation
    max_tested=-Inf;
    for ii=1:length(size_sample)
      sys_sample=usample(quiz.forRACT{idperf,3},size_sample(ii));
      tested = feval(quiz.forRACT{idperf,1},sys_sample);
      max_tested=max([max_tested;tested]);
      if verbose
        for jj=1:length(textdisp);
          fprintf('\b');
        end
        textdisp=sprintf('%i tested random values out of %i | worst case performance = %4.3e',...
          sum(size_sample(1:ii)),nb_sample,max_tested);
        fprintf('%s',textdisp);
      end
    end
    disp(' ');
    result=max_tested;
  else % reliability computation of performance
    sum_tested=0;
    for ii=1:length(size_sample)
      sys_sample=usample(quiz.forRACT{idperf,3},size_sample(ii));
      tested = feval(quiz.forRACT{idperf,1},sys_sample,quiz.forRACT{idperf,2});
      sum_tested=sum_tested+sum(tested);
      if verbose
        for jj=1:length(textdisp);
          fprintf('\b');
        end
        textdisp=sprintf('%i tested random values out of %i | performance guaranteed with %3.4g%% reliability',...
          sum(size_sample(1:ii)),nb_sample,100*sum_tested/sum(size_sample(1:ii)));
        fprintf('%s',textdisp);
      end
    end
    if verbose
      for jj=1:length(textdisp);
        fprintf('\b');
      end
    end
    result=sum_tested/nb_sample;
  end
  % Build and display results
  status=[];
  time_spent=cputime-time_spent;
  diagnostic.cputime=time_spent;
  diagnostic.nbsample=nb_sample;
  nbperf=size(quiz.name,1);
  if verbose
    eval(quiz.result{1,idperf+1});
    if nb_sample<opts.maxsamples
      if isempty(perf)
        disp('The probability P for an other sample to violate the estimate is such that');
        fprintf('  Prob{ P > %g } < %g\n\n',opts.epsilon,opts.delta);
      else
        disp('The true probability P is such that');
        fprintf('  Prob{ |P-P_est| > %g } < %g\n\n',opts.epsilon,opts.delta);
      end
    end
  end
end
end
    
