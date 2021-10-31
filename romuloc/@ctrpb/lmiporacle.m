function [feasible, Niter, LMI_viol] = lmiporacle(quiz,nb_sample,LMIprecision)
% Iternal use only - probabilistic oracle to test feasibility

%   This file is part of RoMulOC
%   Last Update 19-May-2016
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

%   (ripped from ract/lmiporacle)

% tests are done with packets of samples
% first packets are small (at the beginning one sample is enough)
% last packets are large (at the end one need to test thousands)
size_pack=50;
size_sample(1:3)=[1 10 0];
already=sum(size_sample(1:3));
nb_pack=fix((nb_sample-already)/size_pack);
size_sample(4:(3+nb_pack)) = ones(1,nb_pack)*size_pack;
remainder=rem(nb_sample-already,size_pack);
if remainder<size_sample(2)
  size_sample(2)=size_sample(2)+remainder;
else
  size_sample(3)=remainder;
end
size_sample=size_sample(find(size_sample));
% initialize some variabes
feasible = 1; % if no violating value is found default it means feasible
textdisp='';% used for nice display of iterations
Niter = 0;% number of tests done
vars = quiz.vars;
lvars = size(vars,1);
cvars = size(vars,2);
assign(quiz.vars{1,1,1},LMIprecision);
varsglob = reshape({vars{:,:,1}},lvars,cvars);
lmi_glob = quiz.lmi;
forRACT = quiz.forRACT;
nbperf = size(forRACT,1);

ii=0;
while feasible && ii<length(size_sample)
  ii=ii+1;
  for truc=1:length(textdisp);
    fprintf('\b');
  end
  textdisp=sprintf(' (Next Iter %i succeeded)',sum(size_sample(1:(ii-1))));
  fprintf('%s',textdisp);
  % generate a pack of uncertain values
  sample_sys=cell(1,nbperf);
  for perfid=1:nbperf;
    sample_sys{perfid}=usample(forRACT{perfid,3},size_sample(ii));
  end
  % check the feasibility of the elements of the pack
  kk=0;
  while feasible && kk<size_sample(ii)
    kk=kk+1;
    Niter=Niter+1;
    % first do a numerical test of feasibility without building the sdpvar LMIs 
    if min(checkset(lmi_glob))<=LMIprecision
      feasible=0;
    end
    perfid=0;
    while feasible && perfid<nbperf
      perfid=perfid+1;
      varsloc = reshape({vars{:,:,perfid+1}},lvars,cvars);
      LMIloc = feval(...
        forRACT{perfid,1},...
        sample_sys{perfid}(kk),...
        forRACT{perfid,2},...
        varsdouble(varsglob),...
        varsdouble(varsloc));
      cstr_test=1;
      while feasible && cstr_test<=length(LMIloc)        
        if max(eig(LMIloc{cstr_test}))>=-LMIprecision;
%        if eigs(LMIloc{cstr_test},1,'lr')>=-LMIprecision;
          feasible=0;
        end
        cstr_test=cstr_test+1;
      end
    end
  end
end

if ~feasible
  % build the SDP LMI problem, known to be unfeasible
  LMI_viol=lmi_glob;
  for perfid=1:nbperf
    varsloc = reshape({vars{:,:,perfid+1}},lvars,cvars);
    LMI_viol = LMI_viol + feval(...
      forRACT{perfid,1},...
      sample_sys{perfid}(kk),...
      forRACT{perfid,2},...
      varsglob,...
      varsloc);
  end
else
  LMI_viol=[];
end
for truc=1:length(textdisp);
  fprintf('\b');
end
end

%%% Internal function
function varso = varsdouble (varsi)
varso=cell(size(varsi,1),1);
for varsii=1:size(varsi,1)
  varso{varsii,1}=double(varsi{varsii,1});
end
end



