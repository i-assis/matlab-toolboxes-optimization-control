function ANew = makesparse(A)
% MAKESPARSE --- Get sparse form.
%
% ANew = makesparse(A)
%
% ANew is the sparse form of A. If A is already sparse, the memory
% will be optimized further.
%

% This file is part of SOSTOOLS - Sum of Squares Toolbox ver 3.01.
%
% Copyright (C)2002, 2004, 2013, 2016  A. Papachristodoulou (1), J. Anderson (1),
%                                      G. Valmorbida (2), S. Prajna (3), 
%                                      P. Seiler (4), P. A. Parrilo (5)
% (1) Department of Engineering Science, University of Oxford, Oxford, U.K.
% (2) Laboratoire de Signaux et Systmes, CentraleSupelec, Gif sur Yvette,
%     91192, France
% (3) Control and Dynamical Systems - California Institute of Technology,
%     Pasadena, CA 91125, USA.
% (4) Aerospace and Engineering Mechanics Department, University of
%     Minnesota, Minneapolis, MN 55455-0153, USA.
% (5) Laboratory for Information and Decision Systems, M.I.T.,
%     Massachusetts, MA 02139-4307
%
% Send bug reports and feedback to: sostools@cds.caltech.edu
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program. If not, see <http://www.gnu.org/licenses/>.
%

% 12/12/01 - SP
% 10/08/02 - SP

if ~issparse(A)
    ANew = sparse(A);
    return;
else
    [I,J,V] = find(A);
    if length(I)>0
        ANew = sparse(I,J,V,size(A,1),size(A,2),length(I));    % 12/25/01 - SP
    else
        ANew = sparse(size(A,1),size(A,2));     % For compatibility with MATLAB 5, 10/08/02 - SP
    end;
end;
