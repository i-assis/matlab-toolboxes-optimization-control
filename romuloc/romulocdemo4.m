% For internal use only - function called by <romuloc(4)>

%   This file is part of RoMulOC
%   Last Update 13-Nov-2013
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

clc;
  fprintf(['%%%% The considered model is derived from the elevation angle motion\n']);
  fprintf(['%%%% of the ''3DOF helicopter'' produced by Quantser http://www.quanser.com\n']);
  fprintf(['%%%% For the considered motion the model is of ordre 3,\n']);
  fprintf(['%%%% has a signle input and two scalar uncertainties.\n']);
  fprintf('\n%%%% -- press key --'),pause,fprintf('\r                   \n');
  
  fprintf(['%%%% Declare the interval uncertain system -a- the ssmodel at' ...
	   ' one side of the interval\n\n']);
  
  fprintf('sysmax=ssmodel(''Helicopter'');\n')
  fprintf('sysmax.A=[0 1 0 ;0 0 1;0 -2.8 -0.14];\n')
  fprintf('sysmax.Bw=[0;0;-14];\n')
  fprintf('sysmax.Bu=[0;0;8];\n')
  fprintf('sysmax.Dzu=1\n')
  sysmax=ssmodel('Helicopter');
  sysmax.A=[0 1 0 ;0 0 1;0 -2.8 -0.14];
  sysmax.Bw=[0;0;-14];
  sysmax.Bu=[0;0;8];
  sysmax.Dzu=1

  fprintf('\n%%%% -- press key --'),pause,fprintf('\r                   \n');
  fprintf(['%%%% Declare the interval uncertain system -b- the ssmodel at' ...
	   ' the other side of the interval\n\n']);
  
  fprintf('sysmin=ssmodel(''Helicopter'');\n')
  fprintf('sysmin.A=[0 1 0 ;0 0 1;0 -3 -0.2];\n')
  fprintf('sysmin.Bw=[0;0;-14];\n')
  fprintf('sysmin.Bu=[0;0;8];\n')
  fprintf('sysmin.Dzu=1\n')
  sysmin=ssmodel('Helicopter');
  sysmin.A=[0 1 0 ;0 0 1;0 -3 -0.2];
  sysmin.Bw=[0;0;-14];
  sysmin.Bu=[0;0;8];
  sysmin.Dzu=1
  
  fprintf('\n%%%% -- press key --'),pause,fprintf('\r                  \n');  
  fprintf(['%%%% Declare the interval uncertain system -c- the uncertain' ...
	   ' model\n\n']);
  fprintf('usys=uinter(sysmin,sysmax)\n');
  usys=uinter(sysmin,sysmax)

%   fprintf('\n%%%% -- press key --'),pause,fprintf('\r                  \n');  
%   fprintf(['%%%%  As the implemented methods apply to poytopic uncertain' ...
% 	   ' systems \n']);
%   fprintf(['%%%%  the system is converted to the equivalent polytopic model:\n\n']);
%   fprintf('usys=u2poly(usysi)\n')
%   usys=u2poly(usysi)
  
  fprintf('\n%%%% -- press key --'),pause,fprintf('\r                  \n');
  fprintf('%%%% The goal is to find a state feedback.\n');
  fprintf('%%%% The only method yet implemented is conservative\n');
  fprintf('%%%% with a unique Lyapunov matrix for all\n');
  fprintf('%%%% uncertainties and all performances.\n');
  fprintf('%%%% The declaration is as follows\n\n');   
  fprintf('quiz=ctrpb(''state-feedback'',''Lyap unique'')\n\n');
  quiz=ctrpb('state-feedback','Lyap unique')  
  
  HinfSpec=1.9;
  fprintf('\n%%%% -- press key --'),pause,fprintf('\r                  \n');
  fprintf('%%%% The first requirement for the controller is\n')
  fprintf('%%%% to make the closed-loop H-infinity norm less than %g\n',HinfSpec);
  fprintf('%%%% which is specified as follows\n\n');  

  fprintf('quiz=quiz+hinfty(usys,%g)\n\n',HinfSpec);
  quiz=quiz+hinfty(usys,HinfSpec)
  
  fprintf('\n%%%% -- press key --'),pause,fprintf('\r                  \n');
  fprintf('%%%% The second requirement for the controller is\n')
  fprintf('%%%% to make the time constant faster than 0.1sec\n');
  fprintf('%%%% which is specified by a pole location constraint as follows\n\n');  

  fprintf('r1=region(''plane'',-0.1)\n');
  r1=region('plane',-0.1)
  fprintf('\nquiz=quiz+dstability(usys,r1)\n\n');
  quiz=quiz+dstability(usys,r1)
  
% removed temporarily (i2p not upgraded to ract version)
%   fprintf('\n%%%% -- press key --'),pause,fprintf('\r                  \n');
%   fprintf('%%%% The third requirement for the controller is\n')
%   fprintf('%%%% to make minimize the impulse-to-peak performance\n');
%   fprintf('%%%% which is specified as follows\n\n');  
% 
%   fprintf('quiz=quiz+i2p(usys)\n');
%   quiz=quiz+i2p(usys)
  
  fprintf('%%%% -- press key --'),pause,fprintf('\r                  \n');
  fprintf('%%%% The LMI control problem is solved:\n\n');

  fprintf('k=solvesdp(quiz)\n');
  [k,status,diagn]=solvesdp(quiz,true);
  k
  fprintf('Total computation time = %g\n',diagn.yalmiptime+diagn.solvertime);
  
  fprintf('%%%% -- press key --'),pause,fprintf('\r                  \n');
  fprintf('%%%% Try to do the same using RACT method\n\n');
  fprintf('quiz2=ctrpb(''state-feedback'',''rand'');\n');
  fprintf('quiz2=quiz2+hinfty(usys,%g);\n',HinfSpec);
  fprintf('quiz2=quiz2+dstability(usys,r1)\n\n');
  quiz2=ctrpb('state-feedback','rand');  
  quiz2=quiz2+hinfty(usys,HinfSpec);
  quiz2=quiz2+dstability(usys,r1);

  fprintf('%%%% -- press key --'),pause,fprintf('\r                  \n');
  fprintf('%%%% An now we solve it (default gradient algorithm)\n\n');
  fprintf('k2=solvesdp(quiz2,true)\n\n');
   
  [k2,status,diagn]=solvesdp(quiz2,true,randsettings('method','gradient'));
  k2
  fprintf('First iterate with a feasible sample = %g\n',diagn.first_it_asample_feasible);
  fprintf('Initialisation time = %g\n',diagn.inittime);
  fprintf('Computation time = %g\n',diagn.solvertime);

  fprintf('%%%% -- press key --'),pause,fprintf('\r                     \r');
  fprintf('%%%% For the obtained controllers \n')
  fprintf('%%%% an analysis step is performed to have a bound on the actual\n');
  fprintf('%%%% H-infinity performance of the closed-loop systems.\n');
  fprintf('%%%% To do so, declare a PDLF analysis problem\n\n');
  fprintf('quiz=ctrpb(''analysis'',''Polytopic-PDLF'')\n\n');
  quiz=ctrpb('analysis','Polytopic-PDLF')
  
  fprintf('%%%% -- press key --'),pause,fprintf('\r                     \r');
  fprintf('%%%% and specify H-infinity optimization for the closed-loops:\n\n')
  fprintf('quiz1=quiz+hinfty(sfeedback(usys,k))\n\n');
  quiz1=quiz+hinfty(sfeedback(usys,k))

  fprintf('\nquiz2=quiz+hinfty(sfeedback(usys,k2))\n');
  quiz2=quiz+hinfty(sfeedback(usys,k2))
  
  fprintf('%%%% -- press key --'),pause,fprintf('\r                     \r');
  fprintf('%%%% Solve the analysis problem for ''LMI'' based controller:\n\n')
  fprintf('solvesdp(quiz)\n');
  solvesdp(quiz1,true)
  
  fprintf('%%%% -- press key --'),pause,fprintf('\r                     \r');
  fprintf('%%%% Solve the analysis problem for ''randomized'' based controller:\n\n')
  fprintf('solvesdp(quiz2)\n');
  solvesdp(quiz2,true)
  
%   fprintf('%%%% -- press key --'),pause,fprintf('\r                     \r');
%   fprintf('%%%% Note the results may be announced as not strictly feasible\n')
%   fprintf('%%%% this (if it happens) is a drawback of the solver.\n')
%   fprintf('%%%% But the provided values usually happen to be valid.\n');

  