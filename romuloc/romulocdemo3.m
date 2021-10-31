% For internal use only - function called by <romuloc(3)>

%   This file is part of RoMulOC
%   Last Update 5-Nov-2013
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France 

clc;
  fprintf(['%%%% The considered model is derived from the elevation angle motion\n']);
  fprintf(['%%%% of the ''3DOF helicopter'' produced by Quantser http://www.quanser.com\n']);
  fprintf(['%%%% For the considered motion the model is of ordre 3,\n']);
  fprintf(['%%%% has a signle input and two scalar uncertainties.\n']);
  fprintf('\n%%%% -- press key --'),pause,fprintf('\r                   \n');
  
  fprintf('%%%% Declare the LFT uncertain system -a- the LTI ssmodel\n\n');
  
  fprintf('sys=ssmodel(''Helicopter'');\n')
  fprintf('sys.A=[0 1 0 ;0 0 1;0 -2.8 -0.14];\n')
  fprintf('sys.Bd=[0 0 ;0 0;1 1];\n')
  fprintf('sys.Bw=[0;0;-14];\n')
  fprintf('sys.Bu=[0;0;8];\n')
  fprintf('sys.Cd=[0 1 0;0 0 1; 0 0 0];\n')
  fprintf('sys.Ddd=zeros(3,2);\n')
  fprintf('sys.Ddu=[0;0;1];\n')
  fprintf('sys.Dzu=1\n')
  sys=ssmodel('Helicopter');
  sys.A=[0 1 0 ;0 0 1;0 -2.8 -0.14];
  sys.Bd=[0 0 ;0 0;1 1];
  sys.Bw=[0;0;-14];
  sys.Bu=[0;0;8];
  sys.Cd=[0 1 0;0 0 1; 0 0 0];
  sys.Ddd=zeros(3,2);
  sys.Ddu=[0;0;1];
  sys.Dzu=1
  fprintf('\n%%%% -- press key --'),pause,fprintf('\r                  \n');  
  fprintf('%%%% Declare the LFT uncertain system -b- the uncertainties\n\n');
  fprintf('%%%% The first uncertain parameter is modeled as inside the plotted elipse\n\n');
  fprintf('e1=melli(-[0.08 0.004;0.004 0.00021],[0;0],1);\n\n');
  fprintf('delta1=udiss(e1,''delta1'')\n\n');
  e1=melli(-[0.08 0.004;0.004 0.00021],[0;0],1);
  plot(e1);
  delta1=udiss(e1,'delta1')
  fprintf('\n%%%% -- press key --'),pause,fprintf('\r                  \n');
  close;
  fprintf('%%%% and the second uncertainty is in the interval [-4 4]\n\n');
  fprintf('delta2 = uinter(-4, 4, ''delta2'')\n\n');
  delta2=uinter(-4,4,'delta2')
  fprintf('\n%%%% -- press key --'),pause,fprintf('\r                  \n');
  fprintf('%%%% Declare the LFT uncertain system -c- the LFT\n\n');
  fprintf('%%%% ''sys'' is operated via a feedback connection \n');
  fprintf('%%%% with the uncertain operator such that wd = Delta*zd where \n\n');
  fprintf('Delta = diag(delta1,delta2)\n\n');
  delta=diag(delta1,delta2)
  fprintf('\nusys=ussmodel(sys,Delta)\n\n');
  usys=ussmodel(sys,delta)
  fprintf('\n%%%% -- press key --'),pause,fprintf('\r                  \n');
  fprintf('%%%% The goal is to find a state feedback.\n');
  fprintf('%%%% The only method yet implemented is conservative\n');
  fprintf('%%%% with a unique Lyapunov matrix for all\n');
  fprintf('%%%% uncertainties and all performances.\n');
  fprintf('%%%% The simplified declaration is as follows\n\n');   
  fprintf('quiz=ctrpb(''state-feedback'',''unique'')\n\n');
  quiz=ctrpb('state-feedback','unique')  
  fprintf('\n%%%% -- press key --'),pause,fprintf('\r                  \n');
  fprintf('%%%% The first requirement for the controller is\n')
  fprintf('%%%% to make the time constant faster than 0.1sec\n');
  fprintf('%%%% which is specified by a pole location constraint as follows\n\n');  

  fprintf('r1=region(''plane'',-0.1)\n');
  r1=region('plane',-0.1)
  fprintf('\nquiz=quiz+dstability(usys,r1)\n\n');
  quiz=quiz+dstability(usys,r1)
    
  fprintf('\n%%%% -- press key --'),pause,fprintf('\r                  \n');
  fprintf('%%%% The second requirement for the controller is\n')
  fprintf('%%%% to make the damping below a 0.7071 factor\n');
  fprintf('%%%% which is specified by a pole location constraint as follows\n\n');  

  fprintf('r2=region(''plane'', 0, pi/4)\n');
  r2=region('plane', 0, pi/4)
  fprintf('\nquiz=quiz+dstability(usys,r2)\n\n');
  quiz=quiz+dstability(usys,r2)
  
  fprintf('\n%%%% -- press key --'),pause,fprintf('\r                  \n');
  fprintf('%%%% The third requirement for the controller is\n')
  fprintf('%%%% to guarantee an Hinfinity norm below 4\n');
  fprintf('%%%% for the performance transfer\n\n');

  fprintf('quiz=quiz+hinfty(usys,4)\n\n');
  quiz=quiz+hinfty(usys,4)
  
  fprintf('%%%% -- press key --'),pause,fprintf('\r                  \n');
  fprintf('%%%% The LMI control problem is solved:\n\n');

  fprintf('k=solvesdp(quiz)\n');
  k=solvesdp(quiz,true)
  fprintf('%%%% -- press key --'),pause,fprintf('\r                     \r');
  fprintf('%%%% For the obtained controller satisfying the constraints\n')
  fprintf('%%%% an analysis step is performed to have a bound on the actual\n');
  fprintf('%%%% H-infinity performance of the closed-loop system.\n');
  fprintf('%%%% To do so, declare a PDLF analysis problem\n\n');
  fprintf('quiz=ctrpb(''analysis'',''PDLF'')\n\n');
  quiz=ctrpb('analysis','PDLF')
  
  fprintf('%%%% -- press key --'),pause,fprintf('\r                     \r');
  fprintf('%%%% and specify H-infinity optimization for the closed-loop:\n\n')
  fprintf('quiz=quiz+hinfty(sfeedback(usys,k))\n');
  quiz=quiz+hinfty(sfeedback(usys,k))
  
  fprintf('%%%% -- press key --'),pause,fprintf('\r                     \r');
  fprintf('%%%% Solve the analysis problem:\n\n')
  fprintf('solvesdp(quiz)\n');
  solvesdp(quiz,true)

  fprintf('%%%% -- press key --'),pause,fprintf('\r                     \r');
  fprintf('%%%% Note the results may be announced as not strictly feasible\n')
  fprintf('%%%% this is a drawback of the solver used.\n')
  fprintf('%%%% But the provided values usually happen to be valid.\n');
 
%  return