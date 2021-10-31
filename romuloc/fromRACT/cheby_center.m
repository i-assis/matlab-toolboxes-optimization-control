function [x,r] = cheby_center(A,b)

% $Id: cheby_center.m,v 1.1 2013/12/04 14:56:36 peaucell Exp $

AA=[A, sqrt(diag(A*A'))];
[m,n]=size(A);
xc = sdpvar(n,1);
rc = sdpvar(1,1);
F = set(AA*[xc; rc] <= b) + set(rc>=0);
ops = sdpsettings('solver','linprog','verbose',0);
ops.linprog.TolX = 1e-12;

solvesdp(F, -rc, ops);

x = double(xc);
r = double(rc);

