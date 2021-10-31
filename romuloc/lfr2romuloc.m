function [usys]=lfr2romuloc(sys,int)

% [usys]=lfr2romuloc(sys,int)
%
% converts LFR object with interval uncertainty into SSMODEL object with
% interval uncertainty in the interval specified in <int>
%
% <int> is Nx2 vector: -N is equal to the number of uncertainties or 1 in 
%                       case of all the uncertainties have the same interval.
%                      -first colomn is the minimal value of the interval,
%                       second column is the maximal value

if ~isa(sys,'lfr')
    error('First imput argument must be LFR object')
end

lfrsys=lfr(sys);
[py,mu,n,nconst,md,pd] = size(lfrsys);

if nconst
    error('constant blocs in LFR object : not handled in RoMulOC');
end
usys = ssmodel;
usys.A   = lfrsys.a(1:n,1:n);
usys.Bd  = lfrsys.a(1:n,(n+1):end);
usys.Bu  = lfrsys.b(1:n,:);
usys.Cd  = lfrsys.a((n+1):end,1:n);
usys.Ddd = lfrsys.a((n+1):end,(n+1):end);
usys.Ddu = lfrsys.b((n+1):end,:);
usys.Cy  = lfrsys.c(:,1:n);
usys.Dyd = lfrsys.c(:,(n+1):end);
usys.Dyu = lfrsys.d;              
nbincert=size(lfrsys.blk.names,2);
incertstart=1;
if nbincert
    if n
        incertstart=2;
        switch lfrsys.blk.names{1}
            case '1/s'
                usys.Ts=0;
            case '1/z'
                usys.Ts=1;
            otherwise
                error('First block in LFR object is not integrator or delay !')
        end
    end
end
if nargin == 1
    int(:,1)=lfrsys.blk.desc(9,:)';
    int(:,2)=lfrsys.blk.desc(10,:)';
end
if nargin == 2 & size(int,2) ~= 2
    error('<int> vector must have 2 columns')
end
if size(int,1) ~= 1 & size(int,1) ~= nbincert-1
    error('wrong length of <int>')
end
if size(int,1) == 1
    int=repmat(int,[nbincert-1 1]);
end
delta=uncertainty;
for ii=incertstart:nbincert
    type = lfrsys.blk.desc(:,ii);
    if ~type(4)
        error('Sorry I did not understand the full blocks definition in LFRtoolbox')
    end
    if ~type(5)
        error('Sorry RoMulOC does not handle nonlinear blocks')
    end
    switch type(7)
        case 1
            switch type(8)
                case 2 % case of interval uncertainty
                    deltatmp=uinter(int(ii-1,1),int(ii-1,2),lfrsys.blk.names{ii});
                    for jj=1:type(1) % repeat it as many times as necessary
                        delta=diag(delta,deltatmp);
                    end
                case 1 % case of uncertainty in a disc
                    error('conversion of LFR disc not considered')
            end
        case 2 % case of uncertainty in a sector
            error('conversion of LFR sector not considered')
        otherwise
            error('conversion of this type of LFR uncertainty not considered')
    end
end
usys=ussmodel(usys,delta);

