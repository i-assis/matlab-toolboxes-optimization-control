function [x, R] = lmiupdell(varargin)
%LMIUPDELL updates feasible solution by an ellipsoid step
% first argument are 'columned' matrices F0, F1 ... Fn
% getbase(LMI) (see YALMIP for the format)
% = updgrad(LMI_matrix, x, Nin, mode)
%   lmiupdcutplane(-Fi_base, x(Fi_vars_ind), Fi_vars_ind, x, all_nums, Delta_viol, options)

% $Id: lmiupdell.m,v 1.1 2013/12/04 14:56:37 peaucell Exp $

Fi_base = varargin{1};
x_full = varargin{2};
%x_grad = varargin{3};
x_grad_ind = varargin{3};
opt = varargin{4}; % options

% vector of x-es, used for gradient calculation
x_grad = x_full(x_grad_ind);

R = opt.R;

% vectorized notation, x - sparse !!!
F_vec = Fi_base*[1;x_grad]; % the matrix of LMI
nn = sqrt(length(F_vec)); % F is nn x nn 
%construct the evaluated F
F = reshape(F_vec, nn, nn);
gr = zeros(size(x_grad));
switch opt.lmifunc
  case 'maxeig' % (sub)gradient of maximum eingenvector of F
%     if F == 0 % cause eigs returns random eigenvector for zero eigenvalue
%       eigvec = ones(nn, 1);
%       f_val = 0;
%     else
      eigopt.disp = 0;
      if length(F) == 1 % scalars are treated directly !
        eigvec = F'/abs(F);
        f_val = abs(F);
      else
%        [eigvec, f_val] = eigs(F, 1, 'la', eigopt); % the largest eigenvalue only
          [eigvec, f_val]=eig(full(F));
          [~,jj]=max(diag(f_val));
          eigvec=eigvec(:,jj);
          f_val=f_val(jj,jj);
        % [lamax, Imax] = max(eig(full(F))); % [eigvecs, D] = eig(full(F));% eigvecs = null(full(F) - f_val*eye(nn)); v = eigvecs(:,1);
      end
%     end
    for k = 1:length(x_grad);
        gr(k) = eigvec.'*reshape(Fi_base(:, k+1), nn, nn)*eigvec;
    end
  case 'fronorm'
    F_pp = plusprojm(full(F));
    f_val = norm(F_pp, 'fro');
    if f_val > 0
      F_pp_vec = F_pp(:);
      for k = 1:length(x_grad);
        gr(k) = Fi_base(:, k+1).'*F_pp_vec; % gr = Fi_base(:,2:end).'*F_pp(:)/f_val;
      end
      gr = gr/f_val; 
    end
  otherwise
    error('Unknown function to minimize. Use opt.lmifunc = ''maxeig'' either ''fronorm''');
end

if f_val < 0 % solution 'x' is found
 warning('Solution passed to calculate a gradient for update?! Strange...');
 x = x_full;
 return;
end

% construct a full-size gradient
gr_full = zeros(size(x_full));
gr_full(x_grad_ind) = gr;

if nnz(gr) == 0 % 
  warning('Solution passed to calculate a gradient for update (zero gradient)?! Strange...');
  x = x_full;
  return;
end


N = length(x_full);

% update ellipse
tmp_var = gr_full.'*R*gr_full;
x = x_full - R*gr_full/(sqrt(tmp_var)*(N+1));

R = N^2/(N^2 - 1)*(R - 2*R*gr_full*gr_full.'*R.'/(tmp_var*(N+1)));

if ~isreal(x)
  error('Computation stopped due to numerical problems');
end

