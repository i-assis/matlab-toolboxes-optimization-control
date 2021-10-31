function display(quiz)
% CTRPB/DISPLAY - Display CTRPB object   
      
%   This file is part of RoMulOC
%   Last Update 6-Dec-2013
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France
  
  if ~any(quiz.type)
    fprintf('empty CTRPB object\n');
  end
  fprintf('control problem:')
  switch quiz.type(1)
   case 0
    fprintf(' Undefined type of control problem\n')
   case 1
    fprintf(' ANALYSIS \n')    
   case 11
    fprintf(' STATE-FEEDBACK design \n')    
   case 21
    fprintf(' FULL-ORDER DYNAMIC OUTPUT-FEEDBACK design \n')    
  end
  switch quiz.type(2)
   case 0
     fprintf('Lyapunov function:')
     fprintf(' Undefined type of Lyapunov function\n')
    case 1
      fprintf('Lyapunov function:')
      fprintf(' UNIQUE (quadratic stability)\n')
    case 11
      fprintf('Lyapunov function:')
%      fprintf(' QUADRATIC-LFT (only for LFT USSMODEL)\n')
       fprintf(' QUADRATIC-LFT\n')
    case 21
      fprintf('Lyapunov function:')
%      fprintf(' POLYTOPIC (only for polytopic USSMODEL)\n')
       fprintf(' POLYTOPIC\n')
    case 30
      fprintf('Randomized method\n')
  end
  if size(quiz.name,1)
    fprintf('Specified performances / systems:\n')
    for ii=1:size(quiz.name,1)
      if isempty(quiz.name{ii,1})
	quiz.name{ii,1}='no name';
      end
      fprintf('# %s / %s\n',quiz.name{ii,2},quiz.name{ii,1});
    end
  else
    fprintf('No specified performance\n');
  end

