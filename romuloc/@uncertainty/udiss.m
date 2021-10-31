function delta = udiss(varargin)
% UNCERTAINTY/UDISS - Generate dissipative set including uncertainty
%
% delta = udiss(ussmodel)        delta = udiss(uncertainty)
%
% Tansforms the uncertainty or the uncertainty in an ussmodel into a
% {X,Y,Z}-disspitave uncertainty

%   This file is part of RoMulOC
%   Last Update 24-May-2011
%   author : Dimitri Peaucelle, Alberto Bortott
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

if ~isa(varargin{1},'uncertainty')
    error('wrong input argument it must be or an USSMODEL or an UNCERTAINTY')
end

uncert=varargin{1};
uncert=u2poly(uncert);
nbb=uncert.nbb;

for blkidx=1:nbb
    switch uncert.constr{blkidx}(1:6)
        case {'norm-b','positi','{X,Y,Z'},  % it's already a {X,Y,Z}-dissipative uncertainty
            %uncert{blkidx}=uncert{blkidx};
        case 'polyto',
            if size(uncert.vtx{blkidx},3)==2 ...
		  && size(uncert.vtx{blkidx},1)==1 ...
		  && size(uncert.vtx{blkidx},2)==1		  
	      % polytope coming from interval (scalar), polytope 2 vertices
                dm=uncert.vtx{blkidx}(:,:,1);
                dM=uncert.vtx{blkidx}(:,:,2);
                X=dm*dM;
                Y=-0.5*(dm+dM);
                Z=eye(size(uncert.vtx{blkidx}(:,:,1)));
                eli=melli(X,Y,Z);
                uncert.X{blkidx}=eli.X;
                uncert.Y{blkidx}=eli.Y;
                uncert.Z{blkidx}=eli.Z;                
            else                         % polytope matrix
                p = size(uncert.vtx{blkidx},1);
                q = size(uncert.vtx{blkidx},2);
                X = sdpvar(q,q,'symmetric');
                Z = sdpvar(p,p,'symmetric');
		Center=mean(uncert.vtx{blkidx},3);
                cnstr = [trace(Z)>=1, Z>=0.001*eye(p)];
                XYZ = [X -Center'*Z;-Z*Center Z];
                for ivtx=1:size(uncert.vtx{blkidx},3)
                    D = uncert.vtx{blkidx}(:,:,ivtx);
                    cnstr = cnstr + [[eye(q) D']*XYZ*[eye(q) ; D]<=0];
                end
                solvesdp(cnstr,trace(Center'*Z*Center-X),sdpsettings('verbose',0));
                eli=melli(double(X),-Center'*double(Z),double(Z));
                uncert.X{blkidx}=eli.X;
                uncert.Y{blkidx}=eli.Y;
                uncert.Z{blkidx}=eli.Z;
            end
            uncert.constr{blkidx}='{X,Y,Z}-dissipative';
            blkpos=find(uncert.struc(1,:)==uncert.uindex(blkidx));
            uncert.uindex(blkidx)=uncertainty('modified: get new uindex');
            uncert.struc(1,blkpos)=uncert.uindex(blkidx);
        otherwise,
            error('not recognized uncertainty name or not yet implemented uncertainty tranformation')
    end
end

delta=uncert;
