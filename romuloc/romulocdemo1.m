% For internal use only - function called by <romuloc(1)>

%   This file is part of RoMulOC
%   Last Update 13-Nov-2013
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France 

text1=['%%%% --------------------------------------\n',...
  '%%%% Mechanical system described by:\n%%%%\n',...
  '%%%%    d^2x     dx \n',...
  '%%%%  M ---- + D -- + K x = E w\n'...
  '%%%%    dt^2     dt\n%%%%\n'...
  '%%%%  z = C x + F w\n%%%%\n'];
clc;fprintf(text1);
fprintf('%%%% ---------------------------------------\n');
fprintf('%%%% -- press key --'),pause,fprintf('\r                     \r');
fprintf('%%%% The K and F matrices are known:\n');
n=3;m=3;p=3;
K = [  3  -1  0 ;
  0   7  1 ;
  -1   0  4 ]
F = [ 0 0 0 ;
  0 0 0 ;
  1 0 0 ]
text1=[text1,...
  '%%%% K and F are known\n'];
fprintf('\n%%%% -- press key --'),pause;
clc;fprintf('\r                     \n');fprintf(text1);
fprintf('%%%% ---------------------------------------\n');
fprintf('%%%% The  inertia M is uncertain such that M = M0 + M1*Dm*M2 with\n');
M0 = [  1  1  0 ;
  -1  1  1 ;
  0 -1  1 ]
M1 = [ 1 ;
  0 ;
  -1 ]
M2 = [ 1 0  0 ;
  0 0 -1 ]
fprintf(['%%%% and Dm is a 1-by-2 matrix whos indentified values are plotted\n%%%%']);
eli = melli([-1 0.5 ; 0.5 -1],[2;-2],5/0.25);
figure,hold on,grid
Dmi=usample(eli,100);
Dmix=reshape(Dmi(1,1,:),1,[]);
Dmiy=reshape(Dmi(1,2,:),1,[]);
plot(Dmix,Dmiy,'x');
fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \r');
fprintf('%%%% This uncertainty is modeled as inside the plotted elipse\n');
plot(eli);
fprintf('%%%% which can be described by a {X,Y,Z}-dissipative uncertainty\n');
X=[-1 0.5 ; 0.5 -1]
Y=[2;-2]
Z=5/0.25
fprintf('Dm = udiss( X, Y, Z, ''Inertia'')\n\n');
Dm  = udiss(eli, 'Inertia')
fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \n');
text1=[text1,...
  '%%%% M = M0 + M1*Dm*M2  :  Dm is {X,Y,Z}-dissipative\n'];
close,clc,fprintf(text1);
fprintf('%%%% ---------------------------------------');
fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \r');
fprintf('%%%% The damping D matrix is uncertain such that D = D0 + D1*Dd*D2 with\n');
D0 = [ 0.5 0   0   ;
  0   0.9 0   ;
  0   0   0.7 ]
D1 = [ 1 0 ;
  1 1 ;
  1 0 ]
D2 = [ 1 0 0 ;
  0 0 1 ]
fprintf(['%%%% and Dd is a 2-by-2 norm bounded matrix: Dd''*Dd<=0.25\n%%%%']);
fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \n');
fprintf('Dd = unb( 2, 2, 0.25, ''Damping'')\n\n');
Dd = unb( 2, 2, 0.25, 'Damping')
fprintf('\n%%%% -- press key --'),pause;
text1=[text1,...
  '%%%% D = D0 + D1*Dd*D2  :  Dd is norm-bounded by 0.25\n'];
clc;fprintf('\r                     \n');fprintf(text1);
fprintf('%%%% ---------------------------------------');
fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \r');
fprintf('%%%% The input matrix E is uncertain such that E = E0 + E1*De*E2 with\n');
E0 = eye(3)
E1 = [ 1 ; 0 ; 0 ]
E2 = [ 0 0 1 ]
fprintf('%%%% and De is a scalar in the interval [-0.25 0.25]\n%%%%');
fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \n');
fprintf('De = uinter(-0.25, 0.25, ''Input'')\n\n');
De = uinter(-1, 1, 'Input')
fprintf('\n%%%% -- press key --'),pause;
text1=[text1,...
  '%%%% E = E0 + E1*De*E2  :  De is an interval [-0.25 0.25]\n'];
clc;fprintf('\r                     \n');fprintf(text1);
fprintf('%%%% ---------------------------------------');
fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \r');
fprintf('%%%% The output matrix C is uncertain such that C = C0 + C1*Dc*C2 with\n');
C0 = eye(3)
C1 = [ 0 1 ;
  1 0 ;
  0 0 ]
C2 = [ 1 0 0 ;
  0 1 0 ]
fprintf('%%%% and Dc is a 2-by-2 matrix in the convex hull of the three matrices\n');
Dcv(:,:,1)=[-0.25,0;0,-0.25];
Dcv(:,:,2)=[ 0.25,0.25;0,-0.25];
Dcv(:,:,3)=[ 0.25,0.25;0, 0.25]
fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \r');
fprintf('Dc = upoly( Dcv, ''Output'')\n\n');
Dc = upoly( Dcv, 'Output')
fprintf('\n%%%% -- press key --'),pause;
text1=[text1,...
  '%%%% C = C0 + C1*Dc*C2  :  Dc is norm bounded <= 0.25\n'];
clc;fprintf('\r                     \n');fprintf(text1);
fprintf('%%%% ---------------------------------------\n%%%%');
fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \r');
fprintf('%%%% This uncertain system can be modeled as an LFT-type uncertain system.\n');
fprintf('%%%% That is: the feedback connection of the uncertain operator\n');
fprintf('%%%% such that     wd = Delta*zd    with \n\n');
fprintf('Delta = diag(Dm,Dd,De,Dc)\n\n');
Delta = diag(Dm,Dd,De,Dc)
fprintf('\n%%%% and an LTI system such that\n%%%%\n');
fprintf('%%%% dX/dt = A  X + Bd  wd + Bw  w\n')
fprintf('%%%%  zd   = Cd X + Dd  wd + Ddw w\n')
fprintf('%%%%  z    = Cz X + Dzd wd + Dzw w\n%%%%')
fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \r');
fprintf('%%%% The LTI system is defined as follows\n%%%%');
fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \r');
fprintf('%%%% First define an empty SSMODEL object, and give a name\n\n');
fprintf('sys = ssmodel(''Demo Example 1'')\n\n');
sys=ssmodel('Demo Example 1')
fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \r');
fprintf('%%%% Second define the matrices A, Bd, ...\n\n');
text2=[...
  'iM0=inv(M0);',10,10,...
  'sys.A = [ zeros(n) , eye(n) ; -iM0*D0  , -iM0*K ]',10];
fprintf([text2,'\n']);
eval(text2);
fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \r');
text3=['sys.Bd((n+1):2*n,:)=...',10, ...
  '[ -iM0*M1 , -iM0*D1 , iM0*E1 , zeros(n,size(C1,2)) ];',10,10,...
  'sys.Bw((n+1):2*n,:) = -iM0*E0 ;',10,10,...
  'sys.Cd = ...',10,...
  '[-M2*iM0*D0 , -M2*iM0*K ;',10,...
  'zeros(size(D2,1),n) , D2 ;',10,...
  'zeros(size(E2,1),2*n) ;',10,...
  'C2 , zeros(size(C2,1),n) ];',10,10,...
  'sys.Ddd(1:size(M2,1),:) =...',10, ...
  '[ -M2*iM0*M1 , -M2*iM0*D1 , M2*iM0*E1 , zeros(size(M2,1),size(C1,2)) ];',10,10,...
  'sys.Ddw =...',10, ...
  '[ M2*iM0*E0 ; zeros(size(D2,1),m) ; E2; zeros(size(C2,1),m) ];',10,10,...
  'sys.Cz = [C0 , zeros(p,n) ];',10,10,...
  'sys.Dzd(:,(end-size(C1,2)+1):end) = C1;',10,10,...
  'sys.Dzw = F',10,10];
fprintf([text3]);
fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \r');
eval(text3);
fprintf('\n%%%% -- press key --'),pause;
clc;fprintf('\r                     \n');fprintf(text1);
fprintf('%%%% ---------------------------------------\n%%%%');
fprintf(['\n%%%% All the data of the uncertain system is finally' ...
  ' gathered in a USSMODEL object:\n%%%%']);
fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \n');
fprintf('usys = ussmodel( sys, Delta )\n\n');
usys=ussmodel(sys,Delta)
fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \r');
fprintf('\n%%%% Note that the z/w vectors are considered here as\n%%%%\n');
fprintf('%%%%  w is a vector of disturbances\n');
fprintf('%%%%  z is a vector of controlled outputs\n%%%%\n');
fprintf('%%%% the example is focused on robust performance analysis.\n');
fprintf('\n%%%% -- press key --'),pause;
clc;fprintf('\r                     \n');
fprintf('\n%%%% First analysis problem : robust stability\n%%%%\n');
fprintf('%%%% ---------------------------------------\n%%%%');
fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \r');
fprintf('%%%% As a start what are the poles of the nominal system (Delta=0)?\n\n');
fprintf('pole( usys )\n\n')
pole( usys )
fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \r');
fprintf('%%%% Is the system robustly stable ?\n%%%%\n');
fprintf(['%%%% Define the corresponding analysis LMI problem with quadratic stability' ...
  ' method\n\n']);
fprintf('pb1 = ctrpb(''analysis'',''Lyap unique'')\n\n');
pb1 = ctrpb('analysis','Lyap unique')
fprintf('\npb1 = pb1 + stability( usys )\n\n');
pb1 = pb1 + stability(usys)
fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \r');
fprintf('\n%%%% Solve the LMI problem with default settings in YALMIP\n\n');
fprintf('solvesdp( pb1 );\n\n');
solvesdp(pb1);
fprintf('\n%%%% -- press key --'),pause;
clc;fprintf('\r                     \n');
fprintf('\n%%%% Second analysis problem : robust D-stability\n%%%%\n');
fprintf('%%%% ---------------------------------------\n%%%%');
fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \r');
fprintf('%%%% As a start can we plot the poles for random values of Delta?\n%%%%\n');
fprintf('%%%% To do so generate 100 samples of the uncertain system\n');
fprintf('%%%% That combines \n');
fprintf('%%%% (a) sysc=usample(usys,100) : random generator of the uncertain system\n');
fprintf('%%%% (b) pole(sysc) : computation of the poles\n%%%%\n');
fprintf('%%%% The pole location is seen on the figure\n%%%%');
figure
hold on
samplepoles=pole(usample(usys,100));
samplepoles=reshape(samplepoles,[],1);
plot(samplepoles,'+')
sgrid
fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \r');
fprintf('%%%% Let us prove that the damping of all modes is below 0.35\n')
fprintf('%%%% which can be proved if poles are all in the region:\n\n')
fprintf('r1 = region(''plane'',0,asin(0.35))\n\n')
axis([-3.6 0 -3.6 3.6]);
r1=region('plane',0,asin(0.35))
plot(r1,'r')
r1t=region('plane',0,pi-asin(0.35))
plot(r1t,'r')
fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \r');
fprintf('%%%% Is the system robustly D-stable w.r.t. r1 ?\n%%%%\n');
fprintf(['%%%% Define the corresponding LMI problem with quadratic stability' ...
  ' method\n\n']);
fprintf('pb2 = ctrpb(''analysis'',''Lyap unique'');\n');
pb2 = ctrpb('analysis','Lyap unique');
fprintf('pb2 = pb2 + dstability( usys, r1 )\n\n');
pb2 = pb2 + dstability( usys, r1)
fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \r');
fprintf('\n%%%% Solve the LMI problem with default settings in YALMIP\n\n');
fprintf('solvesdp( pb2 );\n\n');
solvesdp(pb2);
fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \n');
fprintf('%%%% Let us prove that poles have natural frequency smaller than 3.5\n')
fprintf('%%%% which can be proved if poles are all in the region:\n\n')
fprintf('r2 = region(''disc'',0,3.6)\n\n')
r2=region('disc',0,3.6)
plot(r2,'r')
fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \r');
fprintf('%%%% Is the system robustly D-stable w.r.t. r2 ?\n%%%%\n');
fprintf(['%%%% Define the corresponding LMI problem with quadratic stability' ...
  ' method\n\n']);
fprintf('pb2b = ctrpb(''analysis'',''Lyap unique'');\n');
pb2b = ctrpb('analysis','Lyap unique');
fprintf('pb2b = pb2b + dstability( usys, r2 )\n\n');
pb2b = pb2b + dstability( usys, r2)
fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \r');
fprintf('\n%%%% Solve the LMI problem with default settings in YALMIP\n\n');
fprintf('solvesdp( pb2b );\n\n');
solvesdp(pb2b);
fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \n');
fprintf('%%%% Let us prove that poles have natural frequency larger than 0.1\n')
fprintf('%%%% which can be proved if poles are all in the region:\n\n')
fprintf('r3 = region(''disc'',0,-0.1)\n\n')
r3=region('disc',0,-0.1)
plot(r3,'r')
fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \r');
fprintf('%%%% Is the system robustly D-stable w.r.t. r3 ?\n%%%%\n');
fprintf(['%%%% Define the corresponding LMI problem with quadratic stability' ...
  ' method\n\n']);
fprintf('pb2c = ctrpb(''analysis'',''Lyap unique'');\n');
pb2c = ctrpb('analysis','Lyap unique');
fprintf('pb2c = pb2c + dstability( usys, r3 )\n\n');
pb2c = pb2c + dstability( usys, r3)
fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \r');
fprintf('\n%%%% Solve the LMI problem with default settings in YALMIP\n\n');
fprintf('solvesdp( pb2c );\n\n');
solvesdp(pb2c);
fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \n');
close,clc
fprintf('\n%%%% Third analysis problem : robust Hinfty performance\n%%%%\n');
fprintf('%%%% ---------------------------------------\n');
fprintf('%%%% The Hinfty performance is defined for modified Oututs/Inputs\n');
fprintf('%%%% The input is shaped by a weight filter such that\n');
g=tf([0.1 1],[0.02 1]);
G(1,1)=g;G(2,2)=g;G(3,2)=0
fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \r');
fprintf('%%%% The shaped model is obtained by\n');
fprintf('%%%% (a) converting the TF object to SSMODEL\n\n');
fprintf('G = ssmodel( G, ''filter'')\n\n');
G=ssmodel(G,'filter')
fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \r');
fprintf('%%%% (b) shaping the input of usys \n\n');
fprintf('usinf = shape( usys, G)\n\n');
usinf = shape( usys, G)
fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \r');
fprintf('%%%% Only the first output is used to measure the Hinfty preformance\n');
fprintf('%%%% The relevant model is therefore obtained by\n\n');
fprintf('usinf = shape( [1 0 0], usinf, ''shaped model'')\n\n');
usinf = shape( [1 0 0], usinf, 'shaped model')
fprintf('\n%%%% -- press key --'),pause;
clc;fprintf('\r                     \n');
fprintf('\n%%%% Third analysis problem : robust Hinfty performance\n%%%%\n');
fprintf('%%%% ---------------------------------------\n');
fprintf('%%%% For this given model <usinf> we shall compute:\n');
fprintf('%%%% (a) The nominal Hinfty norm (Delta=0)\t\t\t\t\t\n');
fprintf('%%%% (b) Optimistic Hinfty norm (for random Delta values)\t\t\t\t\n');
fprintf('%%%% (c) Robust pessimistic Hinfty norm with quadratic stability method\t\t\n');
fprintf(['%%%% (d) Less pessimistic Hinfty norm with parameter-dependent' ...
  ' Lyapunov function\n']);
fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \r');
fprintf('%%%% ---------------------------------------\n');
fprintf('%%%% (a) is immediate (uses the Control Toolbox of Matlab)\n\n')
fprintf('Hi_a = norm( usinf, Inf )\n');
tic;Hi_a = norm(usinf,Inf),t_a=toc;
fprintf('\n%%%% -- press key --'),pause;
clc;fprintf('\r                     \r');
fprintf('\n%%%% Third analysis problem : robust Hinfty performance\n%%%%\n');
fprintf('%%%% ---------------------------------------\n');
fprintf('%%%% For this given model <usinf> we shall compute:\n');
fprintf('%%%% (a) The nominal Hinfty norm (Delta=0)\t\t\t\t\t%g\n',Hi_a);
fprintf('%%%% (b) Optimistic Hinfty norm (for random Delta values)\t\t\t\t\n');
fprintf('%%%% (c) Robust pessimistic Hinfty norm with quadratic stability method\t\t\n');
fprintf(['%%%% (d) Less pessimistic Hinfty norm with parameter-dependent' ...
  ' Lyapunov function\n']);
fprintf('%%%% ---------------------------------------\n');
fprintf('%%%% (b) To have an <epsilon>-close estimate of reliability\n')
fprintf('%%%% of a worst case performance, with violation probability of <delta>\n')
fprintf('%%%% one needs to generate <nb=wcsamplenb(epsilon,delta)> samples\n')
fprintf('%%%% Here we take <epsilon=0.005> (0.5%%) and <delta:0.01> (1%%), nb=919\n')
fprintf('%%%% The randomized problem is build as follows\n\n');
fprintf('pb3 = ctrpb(''analysis'',''rand'') + hinfty( usinf )\n\n')
fprintf('%%%% An then solved with default options\n\n');
fprintf('Hi_b = solvesdp( pb3 )\n');
tic;
pb3 = ctrpb('analysis','rand') + hinfty( usinf );
Hi_b = solvesdp( pb3 ),
t_b=toc;
fprintf('\n%%%% -- press key --'),pause;
close,clc;fprintf('\r                     \r');
fprintf('\n%%%% Third analysis problem : robust Hinfty performance\n%%%%\n');
fprintf('%%%% ---------------------------------------\n');
fprintf('%%%% For this given model <usinf> we shall compute:\n');
fprintf('%%%% (a) The nominal Hinfty norm (Delta=0)\t\t\t\t\t%g\n',Hi_a);
fprintf('%%%% (b) Optimistic Hinfty norm (with 1%% violation probability)\t\t\t%g\n',Hi_b);
fprintf('%%%% (c) Robust pessimistic Hinfty norm with quadratic stability method\t\t\n');
fprintf(['%%%% (d) Less pessimistic Hinfty norm with parameter-dependent' ...
  ' Lyapunov function\n']);
fprintf('%%%% ---------------------------------------\n');
fprintf('%%%%(c) Define the LMI problem with quadratic stability method\n\n');
fprintf('pb4 = ctrpb(''analysis'',''Lyap unique'');\n');
tic;
pb4 = ctrpb('analysis','Lyap unique');
fprintf('pb4 = pb4 + hinfty( usinf )\n\n');
pb4 = pb4 + hinfty( usinf )
t_c=toc;
fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \r');
fprintf('\n%%%% Solve the LMI problem with default settings in YALMIP\n\n');
fprintf('Hi_c=solvesdp( pb4 )\n\n');
tic;
Hi_c=solvesdp(pb4),
t_c=t_c+toc;
fprintf('\n%%%% -- press key --'),pause;
clc;fprintf('\r                     \n');
fprintf('\n%%%% Third analysis problem : robust Hinfty performance\n%%%%\n');
fprintf('%%%% ---------------------------------------\n');
fprintf('%%%% For this given model <usinf> we shall compute:\n');
fprintf('%%%% (a) The nominal Hinfty norm (Delta=0)\t\t\t\t\t%g\n',Hi_a);
fprintf('%%%% (b) Optimistic Hinfty norm (with 1%% violation probability)\t\t\t%g\n',Hi_b);
fprintf('%%%% (c) Robust pessimistic Hinfty norm with quadratic stability method\t\t%g\n',Hi_c);
fprintf(['%%%% (d) Less pessimistic Hinfty norm with parameter-dependent' ...
  ' Lyapunov function\n']);
fprintf('%%%% ---------------------------------------\n');
fprintf('%%%%(d) Define the LMI problem with quadratic-LFT method\n\n');
fprintf('pb5 = ctrpb(''analysis'',''Quadratic-PDLF'');\n');
tic;
pb5 = ctrpb('analysis','Quadratic-PDLF');
fprintf('pb5 = pb5 + hinfty( usinf )\n\n');
pb5 = pb5+ hinfty( usinf )
t_d=toc;
fprintf('\n%%%% -- press key --'),pause,fprintf('\r                     \r');
fprintf('\n%%%% Solve the LMI problem with default settings in YALMIP\n\n');
fprintf('Hi_d = solvesdp( pb5 )\n\n');
tic;
Hi_d = solvesdp( pb5 ),
t_d=t_d+toc;
fprintf('\n%%%% -- press key --'),pause;
clc;fprintf('\r                     \n');
fprintf('\n%%%% Third analysis problem : robust Hinfty performance\n%%%%\n');
fprintf('%%%% ---------------------------------------\n');
fprintf('%%%% For this given model <usinf> we computed:\n');
fprintf('%%%% (a) The nominal Hinfty norm (Delta=0)\n');
fprintf('%%%% (b) Optimistic Hinfty norm (with 1%% violation probability)\n');
fprintf('%%%% (c) Robust pessimistic Hinfty norm with quadratic stability method\n');
fprintf(['%%%% (d) Less pessimistic Hinfty norm with parameter-dependent' ...
  ' Lyapunov function\n']);
fprintf('\nThe results are as expected\n\n');
fprintf('\t(a)\t(b)\tROBUST\t(d)\t(c)\n');
fprintf('value:\t%0.4g\t%.4g\t??\t%.4g\t%.4g\n',...
  Hi_a,Hi_b,Hi_d,Hi_c);
fprintf('time: \t%0.2g\t%0.2g\tNP\t%0.2g\t%0.2g\n\n',...
  t_a,t_b,t_d,t_c);
fprintf('%%%% Note that an attempt was made off-line to get closer to the exact robust value\n')
fprintf('%%%% by taking 20 000 random uncertainties, the result was : 2.4957\n\n');
fprintf('\n%%%% -- press key --'),pause;
fprintf('\r                     \n');
%  fprintf('-- END --\n\n')
if nargout>0, varargout(1)={usys};end,
if nargout>1, varargout(2)={usinf};end,
%  return