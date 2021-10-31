function opt = randsettings(varargin)
%RANDSETTINGS - Create/alter settings for randomized methods
% 
%   opts = randsettings 
%   with no input arguments returns setting structure with default values
%
%   opts = randsettings('NAME1',VALUE1,'NAME2',VALUE2,...) 
%   creates a solution options structure OPTIONS in which the named
%   properties have the specified values.  Any unspecified properties have
%   default values. It is sufficient to type only the leading characters
%   that uniquely identify the property. Case is ignored for property names.
%
%   opts = randsettings(oldopts,'NAME1',VALUE1,...) 
%   alters an existing options structure <oldopts>.
%
%   GENERAL SETTINGS 
%
%   <maxsamples>
%   maximal number of samples of uncertain parameters on which a
%   probabilistic robustness evaluation is done. Default = 1e5
%   <epsilon>
%   precision of the probabilistic evaluation 
%   (probability P that the property is violated by an other sample is
%   required to be less than epsilon : P < epsilon). Default = 1e-2
%   <delta>
%   level of confidence of the probabilistic evaluation
%   (probability of { P > epsilon } is less than delta). Default = 1e-2
%
%   GENERAL SETTINGS FOR uncertain LMI design problems
%
%   <method> among following (default = 'gradient') 
%   'scenario': scenario appoach
%   'sequential': sequential scenario appoach
%   'violated': scenario appoach with violated constraints
%   'gradient': gradient based algorithm
%   'ellipsoid': NOT converted to RoMulOC yet
%   'cutplane': NOT converted to RoMulOC yet
%   <init> among the following (default = 'LMIrandom')
%   'random': initial guess of LMI decision variables chosen randomly
%   'LMInominal': initial guess by solving the LMIs for nominal system 
%   'LMIrandom': initial guess by solving the LMIs for random system
%   <sdpopts> (default = sdpsettings)
%   For some methods LMIs without uncertainties are solved. 
%   Settings for SDP solvers to be set using YALMIP <sdpsettings> function.
%
%   CUTTING PLANE SETTINGS (uncertain LMI design problems)
%
%   <Nout> maximal number of outer iterations. Default = 1e3
%   <r> internal radius. Default = 1e-5
%   <lmifunc> function to minimize ('fronorm' or 'maxeig'). Default = maxeig
%
%   OTHER SETTINGS NOT DEFINED YET....
% 
%   SEE ALSO ctrpb, ctrpb/solvesdp

%   This file is part of RoMulOC
%   Last Update 30-Jan-2015
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

%   (ripped from yalmip/sdpsettings)

if (nargin == 0) & (nargout == 0)
    help randsettings
    return;
end

Names = {'maxsamples',
  'epsilon'
  'delta'
  
  'method'
  'init'
  'sdpopts'
  
  'sequscenit'
  
  'violnb'

  'Nout'
  'r'
  'lmifunc'
  
  };

[m,n] = size(Names);
names = lower(Names);

% Set default values
if (nargin>0) & isstruct(varargin{1})
    opt = varargin{1};
    paramstart = 2;
else
    paramstart = 1;
    % General options
    opt.maxsamples = 1e5;
    opt.epsilon = 1e-2;
    opt.delta = 1e-2;
    opt.method = 'gradient';
    opt.init = 'LMIrandom';
    opt.sdpopts = sdpsettings;
    % Sequential scenario options
    opt.sequscenit = 20;
    % Scenario with violated constraints options
    opt.violnb = 1;
    % Gradient options
    opt.Nout = 1e3;
    opt.r = 1e-5;
    opt.lmifunc = 'maxeig';
end

% Append values with inputs by user
i = paramstart;
% A finite state machine to parse name-value pairs.
if rem(nargin-i+1,2) ~= 0
    error('Arguments must occur in name-value pairs.');
end

expectval = 0; % start expecting a name, not a value
while i <= nargin
    arg = varargin{i};
    
    if ~expectval
        if ~isstr(arg)
            error(sprintf('Expected argument %d to be a string property name.', i));
        end
        
        lowArg = lower(arg);
        j = strmatch(lowArg,names);
        if isempty(j)                       % if no matches
            error(sprintf('Unrecognized property name ''%s''.', arg));
        elseif length(j) > 1                % if more than one match
            % Check for any exact matches (in case any names are subsets of others)
            k = strmatch(lowArg,names,'exact');
            if (length(k) == 1) 
                j = k;
            else
                msg = sprintf('Ambiguous property name ''%s'' ', arg);
                msg = [msg '(' deblank(Names{j(1)})];
                for k = j(2:length(j))'
                    msg = [msg ', ' deblank(Names{k})];
                end
                msg = sprintf('%s).', msg);
                error(msg);
            end
        end
        expectval = 1;                      % we expect a value next
    else
        eval(['opt.' Names{j} '= arg;']);
        expectval = 0;
    end
    i = i + 1;
end

if expectval
    error(sprintf('Expected value for property ''%s''.', arg));
end
