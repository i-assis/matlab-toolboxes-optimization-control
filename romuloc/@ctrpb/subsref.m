function out = subsref(quiz,info)
% CTRPB/SUBSREF - overloaded
      
%   This file is part of RoMulOC
%   Last Update 19-Oct-2012
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France
  
  out=[];
  switch info(1).type
   case '.'
    switch lower(info(1).subs)
     case 'vars'
       out={};
       for kk=1:size(quiz.vars,3)
         for ii=1:size(quiz.vars,1)
           if ~isempty(quiz.vars{ii,1,kk})
             out{end+1,1}=quiz.vars{ii,1,kk};
             out{end,2}=quiz.vars{ii,2,kk};
           end
         end
       end       
      switch length(info)
       case 1
         out=out;
       case 2
         switch info(2).type
           case '{}'
             if length(info(2).subs)==1
               info(2).subs{2}=1;
             end
             out=out{info(2).subs{1},info(2).subs{2}};
         end
        otherwise
          switch info(2).type
            case '{}'
              if length(info(2).subs)==1
                info(2).subs{2}=1;
              end
              S=info(3:end);
              out=subsref(out{info(2).subs{1},info(2).subs{2}},S);
          end
      end
     case 'lmi'
      if length(info)==1
	out=quiz.lmi;
      else
	S=info(2:end);
	out=subsref(quiz.lmi,S);
      end
     case 'type'
      out=quiz.type;
     case 'obj'
      out=quiz.obj;
     case 'objt'
      out=[];
      for i = 1:1:size(quiz.objt,1)
        if quiz.objt(i,2) ~= 1
          out = [out, ...
                 sprintf('%g*CTRPB.vars{%i}', quiz.objt(i,2), quiz.objt(i,1))];
        else
          out = [out, sprintf('CTRPB.vars{%i}', quiz.objt(i,1))];
        end
        if i < size(quiz.objt,1)
          out = [out, ' + '];
        end
      end
     case 'name'
      out=quiz.name;
     case 'tmp'
      out=quiz.tmp;
     case 'result'
      out=quiz.result;
     case 'objw'
      out=quiz.objw;
    end
  end
