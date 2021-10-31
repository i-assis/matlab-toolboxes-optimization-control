function cstr = M11C11T01P41(us,perf,varsglob,varsloc)
% M11C11T01P41 - LFT model - State feedaback - Quadratic stability - i2p test
  
%   This file is part of RoMulOC
%   Last Update 7-Nov-2014
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

n=us.n;
mu=us.mu;
pd=us.pd;
md=us.md;

P = varsglob{2,1};
S = varsglob{3,1};

if isa(P,'sdpvar')
  isLMI=1;
  cstr=lmi;
else
  isLMI=0;
  cstr=cell(4,1);
end

if perf
  gamma2 = perf^2;
  tau = varsloc{1,1};
else
  gamma2 = varsloc{1,1};
  tau = 1;
end

RS = [sparse(mu,mu), S;...
      S', sparse(n, n)];

if isempty(varsloc{2,1})
  if us.T == 0
    RP = [sparse(n,n), P;...
          P, sparse(n, n)];
    MP = [us.A, speye(n)];
    MS = [us.Bu, speye(n)];
  else
    RP = [-P, sparse(n, 2*n); ...
          sparse(n, 2*n), P;...
          sparse(n, n), P, sparse(n, n)];
    MP = [speye(n), us.A, sparse(n,n); ...
          sparse(n, n), -0.5*speye(n), speye(n)];
    MS = [us.Bu, sparse(n,n); ...
          sparse(n,mu),speye(n)];
  end
  cstr1 = MP*RP*MP' + MS*RS*MS';  
else
  if us.T == 0
    RP = [sparse(n,n), P;...
          P, sparse(n, n)];
    MP = [us.A, speye(n); us.Cd, sparse(pd,n)];
    MS = [us.Bu, speye(n); us.Ddu, sparse(pd,n)];
    Mt = [us.Bd, sparse(n,pd); us.Ddd, speye(pd)];
  else
    RP = [-P, sparse(n, 2*n); ...
          sparse(n, 2*n), P; ...
          sparse(n, n), P, sparse(n, n)];
    MP = [speye(n), us.A, sparse(n,n); ...
          sparse(n,n), us.Cd, sparse(n,n); ...
          sparse(n,n), -0.5*speye(n), speye(n)];
    MS = [us.Bu, sparse(n,n); us.Ddu, sparse(pd,n); ...
         sparse(n,n), speye(n)];
    Mt = [us.Bd, sparse(n,pd); us.Ddd, speye(pd); ...
          sparse(n, md + pd)];
  end
  cstr1 = MP*RP*MP' + MS*RS*MS' - Mt*varsloc{2,1}*Mt';  
end
if isLMI;
  cstr = tag(cstr1<= -varsglob{1,1},'Constraint on A');
else
  cstr{1} = cstr1;
end

RP = [sparse(n,n), P;...
      P, sparse(n, n)];
if isempty(varsloc{3,1})
  MP = [us.Cz, sparse(us.pz,n); ...
        -0.5*speye(n), speye(n)];
  MS = [us.Dzu, sparse(us.pz, n); ...
        sparse(n,mu), speye(n)];
  Mg = [speye(us.pz); sparse(n, us.pz)];
  cstr2 = MP*RP*MP'  + MS*RS*MS' - tau* gamma2 * (Mg*Mg');
else
  MP = [us.Cz, sparse(us.pz,n); ...
        us.Cd, sparse(us.pz,n); ...
        -0.5*speye(n), speye(n)];
  MS = [us.Dzu, sparse(us.pz, n); ...
        us.Ddu, sparse(pd, n); ...
        sparse(n, mu), speye(n)];
  Mg = [speye(us.pz); sparse(pd+n, us.pz)];
  Mt = [us.Dzd, sparse(pd,pd); us.Ddd, speye(pd); ...
        sparse(n, md + pd)];
  cstr2 = MP*RP*MP' + MS*RS*MS' - tau* gamma2 * (Mg*Mg')- Mt*varsloc{3,1}*Mt';
end
if isLMI;
  cstr = cstr + tag(cstr2<= -varsglob{1,1}, 'Constraint on Cz');
else
  cstr{2} = cstr2;
end

if size(varsloc,1)<4
    varsloc{4,1}=[];
end
if isempty(varsloc{4,1})
  Mc=us.Bw;
  cstr3 = -P + tau* (Mc * Mc');
else
  MP = [speye(n); sparse(pd, n)];
  Mc = [us.Bw; us.Ddw];
  Mt = [us.Bd, sparse(n, pd); us.Ddd, speye(pd)];
  cstr3 = -MP*P*MP' + tau*(Mc*Mc') -Mt*varsloc{4,1}*Mt';  
end
if isLMI;
  cstr = cstr + tag(cstr3<= -varsglob{1,1}, 'Constraint on Bw');
else
  cstr{3} = cstr3;
end

if size(varsloc,1)<5
    varsloc{5,1}=[];
end
if isempty(varsloc{5,1})
  Mc = us.Dzw;
  cstr4 = tau*(Mc * Mc') - tau*gamma2 * speye(us.pz);
  if perf
    inutile=sdpvar(1);
    cstr4=[cstr4,sparse(size(cstr4,1),1);sparse(1,size(cstr4,2)),inutile];
  end
else
  Mc = [us.Dzw; us.Ddw];
  Mg = [speye(us.pz); sparse(pd, us.pz)];
  Mt = [us.Dzd, sparse(us.pz,pd);
        us.Ddd, speye(pd)];  
  cstr4 = tau*(Mc*Mc') - tau*gamma2 * (Mg*Mg') - Mt*varsloc{5,1}*Mt';  
end
if isLMI;
  cstr = cstr + tag(cstr4<= -varsglob{1,1}, 'Constraint on Dzw');
else
  cstr{4} = cstr4;
end
