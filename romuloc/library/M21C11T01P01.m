function cstr = M21C11T01P01(us,R,varsglob,~)
% M21C11T01P01 - Polytopic model - State Feedback - Quadratic stability - (D-)Stability test  
  
%   This file is part of RoMulOC
%   Last Update 7-Nov-2014
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

P = varsglob{2,1};
S = varsglob{3,1};

if isa(P,'sdpvar')
  isLMI=1;
  cstr=lmi;
else
  isLMI=0;
  cstr=cell(us.nb,1);
end

for vtx=1:us.nb
  payle = us.A(:,:,vtx) * P + us.Bu(:,:,vtx) * S;
  lyap = R(1,1) * P + ...
         R(1,2)' * payle' + ...
         R(2,1)' * payle;
  if R(2,2) == 0
      if isLMI;
        cstr = cstr + tag(lyap <= -varsglob{1,1}, 'Var Lyap <0');
      else
        cstr{vtx}=lyap;% not clear what should be here ...
      end
  else
    payl = [lyap payle; payle' -R(2,2)*P];
    if isLMI
      cstr = cstr + tag(payl <= -varsglob{1,1}, 'Var Lyap < 0');
    else
      cstr{vtx}=payl;
    end
  end
end
