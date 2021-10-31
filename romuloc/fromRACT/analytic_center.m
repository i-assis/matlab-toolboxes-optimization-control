function x = analytic_center(A,b,x0);
%
%function x = analytic_center(A,b,x0);

% $Id: analytic_center.m,v 1.1 2013/12/04 14:56:36 peaucell Exp $

% using default settings
% nIter = 10;
EPS = 1e-12;
nIter = 100;

ALPHA = 0.2;
BETA  = 0.717;

x       =  x0;
nablaf  = -A'*(1./(b-A*x));
Hessian =  A'*diag((b-A*x).^(-2))*A;
fk      = -sum(log(b-A*x));

while ( (nablaf'*(Hessian\nablaf) > 2*EPS) & (nIter > 0) )
    dx = Hessian\nablaf;
       
    % initial step length (maximum step which keeps us within the bounds of
    % the polytope)
    %
    inProd = A * dx;
    idxGTZero = find(inProd > 0);
    inProd = inProd(idxGTZero); % take only > 0
    slacks = b(idxGTZero) - A(idxGTZero,:) * x;
    t0 = min ( slacks * norm(dx) ./ inProd );
    t0 = min(0.99*t0,1);
    
    % do the backtracking linesearch
    %
    t = t0;
    while ( 1 ),
        fkpp   = -sum(log(b-A*(x+t*dx)));
        if ( (fk - fkpp + ALPHA*t*nablaf'*dx) > 0 ),
            break;
        end
        t = BETA * t;
    end
    x = x + t*dx;

    fk     = -sum(log(b-A*x));
    s      = 1./(b-A*x);
    nablaf = -A'*s;
    SA = diag(s)*A;    
    Hessian = SA'*SA;    
    nIter = nIter - 1;
end