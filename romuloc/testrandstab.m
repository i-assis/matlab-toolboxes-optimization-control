function res = testrandstab(T,n,vtxnb,density,disttounstab,perturb,nbtests)
% TESTRANDSTAB test stability conditions on randomly generated systems
% 
% res = testrandstab(T,n,vtxnb,density,disttounstab,perturb,nbtests)
%
% SEE ALSO randpoly

res.tested=zeros(length(n),length(vtxnb));
res.QS.feas=zeros(length(n),length(vtxnb));
res.SV.feas=zeros(length(n),length(vtxnb));
res.QS.nbvar=zeros(length(n),length(vtxnb));
res.SV.nbvar=zeros(length(n),length(vtxnb));
res.QS.nbrow=zeros(length(n),length(vtxnb));
res.SV.nbrow=zeros(length(n),length(vtxnb));
res.QS.time=zeros(length(n),length(vtxnb));
res.SV.time=zeros(length(n),length(vtxnb));
textdisp1='';
textdisp2='';
for in=1:length(n)
  for iv=1:length(vtxnb)
    nbtested=0;      
    fprintf('\nn=%i  vtxnb=%i  nbtested=',n(in),vtxnb(iv));
    textdisp2='';
    t=cputime;
    while res.SV.feas(in,iv)<nbtests
      nbtested=nbtested+1;
      fprintf(repmat('\b',1,length(textdisp2)));
      textdisp2 = sprintf('%i',nbtested);
      fprintf('%s',textdisp2);
      yalmip('clear');
      usys = randpoly(T,n(in),0,0,vtxnb(iv),density,disttounstab,perturb);
      quiz = ctrpb('a','poly')+stability(usys);
      [nbvars,nbrows]=size(quiz);
      res.SV.nbvar(in,iv)=res.SV.nbvar(in,iv)+nbvars;
      res.SV.nbrow(in,iv)=res.SV.nbrow(in,iv)+nbrows;
      [rSV,rstat,rdiag] = solvesdp(quiz,sdpsettings('verbose',0),0);
      res.SV.time(in,iv)=res.SV.time(in,iv)+rdiag.solvertime;
      if rSV>0   
        res.SV.feas(in,iv)=res.SV.feas(in,iv)+1;
        quiz = ctrpb('a','unique')+stability(usys);
        [nbvars,nbrows]=size(quiz);
        res.QS.nbvar(in,iv)=res.QS.nbvar(in,iv)+nbvars;
        res.QS.nbrow(in,iv)=res.QS.nbrow(in,iv)+nbrows;
        [rQS,rstat,rdiag] = solvesdp(quiz,sdpsettings('verbose',0),0);
        res.QS.time(in,iv)=res.QS.time(in,iv)+rdiag.solvertime;
        if rQS>0
          res.QS.feas(in,iv)=res.QS.feas(in,iv)+1;
        end
      end
    end
    res.tested(in,iv)=nbtested;
    res.SV.nbvar(in,iv)=res.SV.nbvar(in,iv)/nbtested;
    res.SV.nbrow(in,iv)=res.SV.nbrow(in,iv)/nbtested;      
    res.SV.time(in,iv)=res.SV.time(in,iv)/nbtested;      
    res.QS.nbvar(in,iv)=res.QS.nbvar(in,iv)/nbtests;
    res.QS.nbrow(in,iv)=res.QS.nbrow(in,iv)/nbtests;
    res.QS.time(in,iv)=res.QS.time(in,iv)/nbtests;      
    fprintf('  QS=%i  time=%f',res.QS.feas(in,iv),cputime-t);
  end
  fprintf('\n-----------------');
end