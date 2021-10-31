function out = teststability(A,R)
% REGION/TESTSTABILITY - tests if a matrix A has eigenvalues in specified region
%
% out = teststability(A,reg)
%
% If <A> is a 3D matrix the test is done along the 3rd dimension and <out>
% is the vector of yes (1) / no (0) answers
% 
% SEE ALSO region

%   This file is part of RoMulOC
%   Last Update 16-Oct-2012
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

out = ones(1,size(A,3));
R=R.mat;

if length(R)>1
  error('D-stability testing for unions of regions is not yet defined');
else
  R=R{1};
end
if isempty(R{1})
    error('the REGION object is empty');
end    

% First convert the region to simpler one
mcenter=[];
scale1=zeros(1,length(R));
scale2=[];
for jj=1:length(R)
  Rjj=R{jj};
  if Rjj(2,2)>0
    mcenter(jj)=-Rjj(2,1)/Rjj(2,2);
    scale2(jj)=Rjj(2,2)/sqrt(Rjj(2,1)*Rjj(1,2)-Rjj(1,1)*Rjj(2,2));
  else
    scale1(jj)=Rjj(1,2);
    mcenter(jj)=0.5*Rjj(1,1);
  end
end
for ii=1:size(A,3)
  for jj=1:length(R)
    if out(ii)
      if scale1(jj)
%         Atest=sparse(A(:,:,ii)*scale1(jj)+mcenter(jj)*eye(size(A,1)));
%         out(ii)=eigs(Atest,1,'LR',opts)<0;
        Atest=A(:,:,ii)*scale1(jj)+mcenter(jj)*eye(size(A,1));
        out(ii)=max(real(eig(Atest)))<0;
      else
%         Atest=sparse((A(:,:,ii)+mcenter(jj)*eye(size(A,1)))*scale2(jj));
%         out(ii)=abs(eigs(Atest,1,'LM',opts))<1;
        Atest=(A(:,:,ii)+mcenter(jj)*eye(size(A,1)))*scale2(jj);
        out(ii)=max(abs(eig(Atest)))<1;
      end
    end
  end
end