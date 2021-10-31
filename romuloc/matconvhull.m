function out = matconvhull( in )
% MATCONVHULL Remove samples from the interior of the convex hull
%
% out = matconvhull( in )
% 
% <in> is a 3D matrix where the 3rd dimension describes the samples
% <out> is the same but with only vertices for the same convex hull
%
% SEE ALSO upoly

%   This file is part of RoMulOC
%   Last Update 15-Oct-2015
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

invec=reshape(permute(in,[3,2,1]),size(in,3),[]);
invec1=repmat(invec(1,:),size(invec,1),1);
test=invec-invec1;
invec=invec(:,any(test));

if size(invec,1)>size(invec,2)
    if size(in,1)==1 && size(in,2)==1
        [~,vertices(1)]=max(invec);
        [~,vertices(2)]=min(invec);
    else
        nbsamples=size(invec,1);
        dims=size(invec,2);
        Aeq=[kron(invec.',eye(nbsamples));kron(ones(1,nbsamples),eye(nbsamples))];
        beq=[reshape(invec,[],1);ones(nbsamples,1)];
        lb=zeros(nbsamples^2,1);
        ub=ones(nbsamples^2,1);
        f=reshape(eye(nbsamples),1,[]);
        opts=optimoptions(@linprog,...
            'Algorithm','simplex',...
            'Display','off');
        x = linprog(f,[],[],Aeq,beq,lb,ub,f',opts);
        X=reshape(x,nbsamples,nbsamples);
        vertices=find(diag(X)>=1e-4);
        nb_almost_one=sum(diag(X)>=0.99);
        nb_olmost_zero=sum(diag(X)<=0.01);
%         facets=convhulln(invec);
%         vertices=unique(facets);
    end
    out=in(:,:,vertices);
else
    out=in;
end

