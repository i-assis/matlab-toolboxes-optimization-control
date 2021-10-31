function x = lmiupdgrad(varargin)
%LMIUPDGRAD updates feasible solution by a gradient step
% first argument are 'columned' matrices F0, F1 ... Fn
% getbase(LMI) (see YALMIP for the format)
% = updgrad(LMI_matrix, x, Nin, mode)

% $Id: lmiupdgrad.m,v 1.2 2015/03/10 13:57:26 peaucell Exp $

Fi_base = varargin{1};
x = varargin{2};
opt = varargin{3}; % options

% make a lot of gradient steps to ensure out unfeaseable Delta seize to be
% unfeseable. In theory k_max supposed to be 1
k_max = 1; 
r_def = 1; % default radius 
for k=1:k_max
  % vectorized notation, x - sparse !!!
  F_vec = Fi_base*[1;x]; % the matrix of LMI
  nn = sqrt(length(F_vec)); % F is nn x nn 
  %construct the evaluated F
  F = reshape(F_vec, nn, nn);
  if ~isreal(F) || ~issymmetric(F)
      if all(all(F-F'))<1e-10
          F=0.5*(F+F');
      else
          error('LMI non real symmetric')
      end
  end
  %F=0.5*real(F+F');
  gr = zeros(size(x));
  switch opt.lmifunc
    case 'maxeig' % (sub)gradient of maximum eingenvector of F
%       if F == 0 % cause eigs returns random eigenvector for zero eigenvalue
%         eigvec = ones(nn, 1);
%         f_val = 0;
%       else
        eigopt.disp = 0;
        if length(F) == 1 % scalars are treated directly !
          eigvec = F'/abs(F);
          f_val = abs(F);
        else
%          try
%            [eigvec, f_val] = eigs(F, 1, 'la', eigopt); % the largest eigenvalue only
          [eigvec, f_val]=eig(full(F));
          [~,jj]=max(diag(f_val));
          eigvec=eigvec(:,jj);
          f_val=f_val(jj,jj);
%          catch ME
%            [eigvec, f_val] = eigs(F, 1, 'lr', eigopt); % the largest eigenvalue only
%          end
        end
%       end
      % [lamax, Imax] = max(eig(full(F))); % [eigvecs, D] = eig(full(F));% eigvecs = null(full(F) - f_val*eye(nn)); v = eigvecs(:,1);
      for k = 1:length(x);
          gr(k) = eigvec.'*reshape(Fi_base(:, k+1), nn, nn)*eigvec;
      end
    case 'fronorm'
      F_pp = plusprojm(full(F));
      f_val = norm(F_pp, 'fro');
      if f_val > 0
        F_pp_vec = F_pp(:);
        for k = 1:length(x);
          gr(k) = Fi_base(:, k+1).'*F_pp_vec; % gr = Fi_base(:,2:end).'*F_pp(:)/f_val;
        end
        gr = gr/f_val; 
      end
    otherwise
      error('Unknown function to minimize. Use opt.lmifunc = ''maxeig'' either ''fronorm''');
  end
     
   if f_val < 0 % solution 'x' is found
     warning('Solution passed to calculate a gradient for update?! Strange...');
     return;
   end

  gr_norm = norm(gr);

  if gr_norm > 0
    if isfield(opt, 'r')
      stepsize = (f_val/gr_norm + opt.r)/gr_norm;
    else
      stepsize = f_val/gr_norm^2;  %stepsize = r_def/sqrt(k);
    end
  else
    stepsize = 0;
  end
  x = x - stepsize*gr; %  x = makestep(x, gr_val, -stepsize);
end
