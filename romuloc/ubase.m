function out = ubase(Name, DistrType, varargin)
%UBASE - creates uncertain object with probabilistic nature
%
% a = UBASE('NAME', 'DISTRIBUTION') 
% creates an uncertain parameter, with name 'NAME', distribution 'DISTRIBUTION'.
%   and default parameters of the distribution.
% 
% a = UBASE('NAME', 'DISTRIBUTION', 'PARAM1_NAME', PARAM1_VALUE, 'PARAM2_NAME', PARAM2_VALUE, ...)
%   sets the properties PARAM1_NAME, PARAM2_NAME, ... to the values PARAM1_VALUE, PARAM2_VALUE, ...
%   the NAME now is only for compatability
%   This parameters and their admissible values are (default ones denoted with [DEF]):
%     All the distributions and the parameters:
%     Real scalar uniform distribution:
%       'real_scalar_uniform': 
%         'nominal' - a real value [DEF: non-exist]
%         'range'   - a real non-negative value [DEF: non-exist]
%     Complex scalar uniform distribution:
%       'complex_scalar_uniform': 
%         'nominal' - a complex value [DEF: non-exist]
%         'radius'   - a real non-negative value [DEF: non-exist]
%     Real scalar gaussian distribution:
%       'real_scalar_gaussian': 
%         'mean': a real value [DEF: non-exist]
%         'std': (standard deviation) a real value > 0 [DEF: non-exist]
%
%     Real vector uniform distribution (column vector): ||x - nominal||_p <= \rho
%       'real_vector_uniform': 
%         'dim'     - (dimension) positive integer [ignored]
%         'nominal' - a real-valued vector with same dimension [DEF: non-exist]
%         'range'   - a real-valued non-negative vector with same dimension [ignored]
%         'p_norm'  - a real value >= 1 [DEF: non-exist]
%         'rho'     - a real non-negative value [DEF: non-exist]
%     Complex vector uniform distribution (column vector): ||x - nominal||_p <= \rho
%       'complex_vector_uniform': 
%         'dim'     - (dimension) positive integer [ignored]
%         'nominal' - a complex-valued vector with same dimension [DEF: non-exist]
%         'range'   - a real-valued non-negative vector with same dimension [ignored]
%         'p_norm'  - a real value >= 1 [DEF: non-exist]
%         'rho'     - a real non-negative value [DEF: non-exist]
%     Real vector gaussian distribution (column vector): 
%       'real_vector_gaussian': 
%         'dim'     - (dimension) positive integer [ignored]
%         'mean'    - a real-valued vector with same dimension [DEF: non-exist]
%         'covar'   - a square non-negative matrix [dim x dim] [DEF: non-exist]
%         'rho'     - a real non-negative value [DEF: non-exist]
%
%     Stable discrete monic polynomial uniform distribution of degree given
%        (column vector [1; a_1; ...; a_n], uniform in coefficient space):
%       'real_stable_discrete_poly_uniform': 
%         'degree'  - an integer >= 1 [DEF: non-exist]
%
%     Real matrix uniform distribution (induced norm): ||M - nominal||_p <= \rho
%       'real_matrix_uniform': 
%         'rows'    - (1st dimension) positive integer [ignored]
%         'cols'    - (2nd dimension) positive integer [ignored]
%         'nominal' - a real-valued matrix with same size [DEF: non-exist]
%         'p_norm'  - 1, 2 or Inf [DEF: non-exist]
%         'rho'     - a real non-negative value [DEF: non-exist]
%     Complex matrix uniform distribution (induced norm): ||M - nominal||_p <= \rho
%       'complex_matrix_uniform': 
%         'rows'    - (1st dimension) positive integer [ignored]
%         'cols'    - (2nd dimension) positive integer [ignored]
%         'nominal' - a complex-valued matrix with same size [DEF: non-exist]
%         'p_norm'  - 1, 2 or Inf [DEF: non-exist]
%         'rho'     - a real non-negative value [DEF: non-exist]
%
%     Real matrix uniform distribution (elementwise norm): \forall i,j: |M_ij - nominal_ij| <=  rho*range_ij
%       'real_matrix_uniform_elem': 
%         'rows'    - (1st dimension) positive integer [ignored]
%         'cols'    - (2nd dimension) positive integer [ignored]
%         'nominal' - a real-valued matrix with same size [DEF: non-exist]
%         'range'   - a real-valued non-negative matrix with same dimension [DEF: non-exist]
%         'rho'     - a real non-negative value [DEF: non-exist]
%
%   % EXAMPLES: (CUT/PASTE)
%   % Create a UBASE with name 'a', uniform over [0, 2].
%   uvar1 = ubase('a', 'real_scalar_uniform', 'nominal', 1, 'range', 1)
% 
%   % Create a UBASE with name 'b', gaussian with mean [1 2 3] and identity covariance matrix.
%   uvar2 = ubase('b', 'real_vector_gaussian', 'mean', [1 2 3].', 'covar', eye(3), 'rho', 1)
% 
% SEE ALSO uncertainty

%   This file is part of RoMulOC
%   Last Update 24-Oct-2013
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

% File replaces RACT toolbox class <ubase>

% absolutely necessary parameters, though 'Name' is reserved
UStruct.Name = Name;
UStruct.DistrType = DistrType;
% automatically fails if number of parameters is odd
UStruct.Params = cell2struct(varargin(2:2:end), varargin(1:2:end), 2);
% check required parameters depending of distribution, throw awaw all other
UStruct = validateubase(UStruct);
% That was RACT style, now we plug that into RoMulOC <uncertainty> object
data.size = [UStruct.Params.rows,UStruct.Params.cols];
data.names{1} = UStruct.Name;
data.constr{1} = displayubase(UStruct);
data.constrcode = 30;
if UStruct.DistrType(1:4)=='real'
  data.complex=0;
else
  data.complex=1;
end
if sum(ismember('uniform',DistrType))==7
  data.distribution=2;
elseif sum(ismember('gaussian',DistrType))==8
  data.distribution=3;
end
data.nature=10;
data.rows{1}=(1:UStruct.Params.rows)';
data.cols{1}=(1:UStruct.Params.cols)';
data.X{1}=[];
data.Y{1}=[];
data.Z{1}=[];
data.vtx{1}={};
data.ubase{1}=UStruct;
if isfield(data.ubase{1}.Params,'nominal')
  data.nominal{1}=data.ubase{1}.Params.nominal;
elseif isfield(data.ubase{1}.Params,'mean')
  data.nominal{1}=data.ubase{1}.Params.mean;
else
  data.nominal{1}=zeros(UStruct.Params.rows,UStruct.Params.cols);
end
data.usample={[]};
data.sampled=0;
% 

if isequal(Name,'temporary-special')
  out = uncertainty('temporary-special',data);
else
  out = uncertainty('new',data);
end







