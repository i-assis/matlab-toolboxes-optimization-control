%FPOLY
%
%  This function is used by the uniform matrix generation package.
%

% $Id: fpoly.m,v 1.1 2013/12/04 14:56:36 peaucell Exp $

function f=fpoly(x);

global F
f=polyval(F,x);
