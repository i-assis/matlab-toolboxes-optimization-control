% For internal use only - function called by <romuloc(2)>

%   This file is part of RoMulOC
%   Last Update 13-Nov-2013
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France 

clc;
fprintf(['%%%% This is the demo example of the "getting started" section of' ...
  ' the users guide\n\n']);
fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \n');

fprintf('%%%% First step is to declare the nominal system\n\n');

fprintf('sys=ssmodel(''Geromel et al. 2002'');\n')
fprintf('sys.A=[0.9 0.1; 0.01, 0.9];\n')
fprintf('sys.Bw=[ 1 0 0 ; 0 1 0];\n')
fprintf('sys.Cy=[1 0;1 1];\n')
fprintf('sys.Dyw=[0 0 1.414;0 0 0];\n')
fprintf('sys.T=1\n\n');
sys=ssmodel('Geromel et al. 2002');
sys.A=[0.9 0.1; 0.01, 0.9];
sys.Bw=[ 1 0 0 ; 0 1 0];
sys.Cy=[1 0;1 1];
sys.Dyw=[0 0 1.414;0 0 0];
sys.T=1
fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \n');
fprintf('%%%% Second step is to declare the "axes" and the parallelotopic model\n\n');

fprintf('axes=ssmodel(0,sys);\n')
fprintf('axes(1).A=[0 0.06;0 0];\n')
fprintf('axes(2).A=[0 0;0.05 0];\n')
fprintf('usys=uparal(sys,axes)\n\n')

axes=ssmodel(0,sys);
axes(1).A=[0 0.06;0 0];
axes(2).A=[0 0;0.05 0];
usys=uparal(sys,axes)
fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \n');
fprintf(['%%%% Third step is to declare a new system working as a filter on the' ...
  ' measured outputs\n']);
fprintf('%%%% and obtain the uncertain filtered system\n\n');
fprintf('filter=ssmodel(''filter Xie et al.2004'');\n')
fprintf('filter.A=[0.0705 0.0263;1.2779 0.5492];\n')
fprintf('filter.Bu=[0.9114 0;-0.9972 0];\n')
fprintf('filter.Cz=[-1.2885 -0.2382];\n')
fprintf('filter.Dzu=[0 1];\n')
fprintf('filter.T=1\n\n')
filter=ssmodel('filter Xie et al.2004');
filter.A=[0.0705 0.0263;1.2779 0.5492];
filter.Bu=[0.9114 0;-0.9972 0];
filter.Cz=[-1.2885 -0.2382];
filter.Dzu=[0 1];
filter.T=1
fprintf('\nfiltered=filter*usys\n\n')
filtered=filter*usys

fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \n');
fprintf(['%%%% Convert the filtered system to a polytopic uncertain model\n\n']);
fprintf('filtered=u2poly(filtered)\n\n');
filtered=u2poly(filtered)

fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \n');
fprintf(['%%%% Declare the analysis H2 problem with quadratic stability' ...
  ' based methods\n\n']);
fprintf('quiz=ctrpb(''analysis'',''Lyap unique'');\n')
fprintf('quiz=quiz + h2(filtered)\n\n')
quiz=ctrpb('analysis','Lyap unique');
quiz=quiz+h2(filtered)

fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \n');

fprintf(['%%%% Solve the H2 analysis problem\n\n']);

fprintf('[result,status,diagnostic,wc]=solvesdp(quiz)\n');
fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \n');
[result,status,diagnostic,wc]=solvesdp(quiz);

fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \n');

fprintf('%%%% The 1st output arg. contains the computed H2 upper bound\n')
%fprintf('result\n')
result

fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \n');

fprintf('%%%% The 2nd output arg. is 1 of problem is strictly feaasible\n')
%fprintf('status\n')
status

fprintf('%%%% If it is negative, this value is the worst constrain residual.\n')
fprintf('%%%% It then means that the solver stopped with some numerical problems.\n')
fprintf('%%%% The solution may be close to optimal.\n')
fprintf('%%%% The value <status> is an indicator of the distance to feasibility.\n')
fprintf('%%%% If such phenomenon occurs it is recommended to change solvers.\n')
fprintf('%%%% For example with the following syntaxe:\n')
fprintf(' solvesdp(quiz,sdpsettings(''solver'',''sdpt3''))\n')

fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \n');

fprintf('%%%% The 3rd output arg. is the output of YALMIP when solving an LMI problem\n')
%fprintf('diagnostic\n')
diagnostic

fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \n');

fprintf('%%%% The 4th output arg. is a candidate for worst case performance.\n')
fprintf('%%%% It is computed using the solution to the dual SDP problem.\n')
fprintf('%%%% It has three fields.\n')
fprintf('%%%% The first one is the worst case candidate for the simplex vector.\n')
fprintf('wc.xi\n')
wc.xi
fprintf('%%%% The second one indicates whether this is guaranteed to be a worst case.\n')
fprintf('%%%% (it is not)\n')
fprintf('wc.iswc\n')
wc.iswc
fprintf('%%%% The last one is the plant model evaluated at the worst case candidate.\n')
fprintf('wc.sys\n')
wc.sys

fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \n');

fprintf('%%%% For this worst case candidate the H2 norm is\n')
fprintf('norm(wc.sys,2)\n')
norm(wc.sys,2,0)

fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \n');

fprintf(['%%%% Using quadratic stability based results\n']);
fprintf('%%%% the robust H2 cost is less than 4.70402\n')
fprintf(['%%%% Now declare the analysis H2 problem with Parameter-Dependent Lyapunov' ...
  ' based methods\n\n']);
fprintf('quiz=ctrpb(''analysis'',''PDLF'');\n')
fprintf('quiz=quiz + h2(filtered)\n\n')
quiz=ctrpb('analysis','PDLF');
quiz=quiz + h2(filtered)

fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \n');

fprintf(['%%%% Solve the new H2 analysis problem\n\n']);

fprintf('[result,status,diagnostic,wc]=solvesdp(quiz);\n');
[result,status,diagnostic,wc]=solvesdp(quiz);

fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \n');

fprintf('%%%% If the LMI problem is declared as feasible (no numerical problems)\n')
fprintf('%%%% then on can notice that the worst case estimate is guaranteed to be one\n');
fprintf('wc.iswc\n')
wc.iswc
fprintf('%%%% The worst case value happens to be the fourth vertex\n');
fprintf('wc.xi\n')
wc.xi
fprintf('%%%% The H2 norm computed at this vertex is equal to the computed upper bound\n');
fprintf('norm(wc.sys,2)\n')
norm(wc.sys,2,0)

fprintf(['%%%% The results are therefore proved to be non conservative' ...
  ' for this example\n']);
%fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \n');
% fprintf('-- END --\n\n')
% return