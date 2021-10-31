% R-RoMulOC - Randomized & RObust MULti-Objective Control
% Version R-2 Release R20160826 Aug-26-2016
%
%###### LTI MODELS ###################################################
%
%LTI models are defined as 'ssmodel' objects 
%(a) define an 'ssmodel'
% - ssmodel               build a 'ssmodel' object
%(b) extract data from 'ssmodel'
% - ssmodel/display       nice display of 'ssmodels'
% - ssmodel/get           get any data (SEE ALSO ssmodel/subsref) 
% - ssmodel/data          get all data (converse to ssmodel first usage) 
% - ssmodel/size          get control input, measure output size 
% - ssmodel/ss            get the 'ssmodel' object in the 'ss' object data form
%(c) modify an 'ssmodel'
% - ssmodel/set           set any data (SEE ALSO ssmodel/subsasgn)
% - ssmodel/ctranspose    dual representation of the 'ssmodel'
% - ssmodel/evalfr        get the transfer matrix for given/or/interval frequency
%(d) connect systems
% - ssmodel/feedback      compute the feedback with an LTI controller 
% - ssmodel/sfeedback     compute the feedback with a state-feedback gain controller 
% - ssmodel/dynof2sof     convert dynamic feedback model to static feedback
% - ssmodel/certain       compute the interconnection with a frozen uncertainty
% - ssmodel/shape         add a shaping filter on the z/w performance signals
% - ssmodel/mtimes        multiply two systems (acts on y/u signals)
% - ssmodel/plus          add two systems (acts on y/u signals)
%(e) basic analysis tools
% - ssmodel/pole          get the poles of the LTI system
% - ssmodel/norm          get H2 and Hinf norm of the LTI system
% - ssmodel/sigma         sigma plot of the LTI system
% - ssmodel/impulse       plot impulse disturbance response 
% - ssmodel/uminus        control inputs of the system are multiplied by -1
%
%###### STRUCTURED UNCERTAINTIES #####################################
%
%Uncertain operators are defined as 'uncertainty' objects.
%(a) define an 'uncertainty'
% - udiss                  {X}{Y}{Z}-dissipative
% - unb                    norm-bounded 
% - upos                   positive-real  
% - upoly                  polytopic  
% - uparal                 parallelotopic 
% - uinter                 interval 
% - uncertainty/diag       build a block diagonal uncertainty
%(b) extract data from 'uncertainty'
% - uncertainty/display    nice display of 'uncertainty'
% - uncertainty/udata      extract any data
% - uncertainty/get        get elements of block-diag uncerainty (SEE ALSO uncertainty/subsref) 
% - uncertainty/size       get the size of the uncertainty
% - uncertainty/usample    generate random value inside uncertainty set
% - uncertainty/isin       test if a matrix belongs to uncertainty set
% - uncertainty/center     get center of uncertainty set
% - uncertainty/nominal    get nominal value of the uncertainty 
% - uncertainty/vtxofupoly builds all vertices of uncertainty 
%(c) derived uncertainty sets (when possible)
% - uncertainty/ctranspose generates the set of conjugate transposed unceratinties
% - uncertainty/upoly      generates equivalent polytopic set
% - uncertainty/udiss      generates including dissipative set
%
%###### UNCERTAIN MODELS #############################################
%
%Uncertain LTI systems are defines as 'ussmodel' objects.
%(a) define an 'ussmodel'
% - ussmodel              LFT uncertain models with an 'uncertainty'
% - upoly                 affine polytopic uncertain models
% - uparal                affine parallelotpic uncertain models
% - uinter                affine interval uncertain models
%(b,c,d,e) same as for 'ssmodel' with in addition
% - ussmodel/nominal      compute nominal system
% - ussmodel/center       compute system with uncertainty at center
% - ussmodel/nominal      compute system with uncertainty at nominal value
% - ussmodel/usample      generate random value inside uncertainty set
% - ussmodel/upoly        convert interval or parallelotopic models to polytopic
% - ussmodel/udiss        convert using including dissipative set
% - ussmodel/poly2lft     convert to LFT model
%
%###### CONTROL PROBLEMS #############################################
%
%(a) define a 'ctrpb'
% - ctrpb                 specify type of problem (analysis/design...)
%(b) extract data from 'ctrpb'
% - ctrpb/display         nice display of 'ctrpb'
% - ctrpb/subsref         extract LMI variables and constraints of 'ctrpb'
% - ctrpb/size            get number of variables and rows of constraints
%(c) modify a 'ctrpb'
% - ctrpb/plus            overloaded, to add constraints such as follows
% - stability             add a (robust) stability constraint
% - dstability            add a (robust) pole location constraint
% - hinfty                add a (robust) Hinfinity cost constraint
% - h2                    add a (robust) H2 cost constraint
% - i2p                   add a (robust) impulse to peak performance constraint
% - ctrpb/initialize      for those ctrpb that are BMI (heuristic method)
% - ctrpb/solvesdp        solve the LMIs of the constructed control problem
%
%###### REGIONS OF THE COMPLEX PLANE #################################
%
%Classical regions of the complex plane are predefined as 'region' objects:
% - region                regions of the complex plane
% - region/plot           plot border of region
%
%###### MATRIX ELLIPSOIDS #############################################
%
%Matrix {X,Y,Z}-ellipsoids are defined as 'melli' objects. 
%(a) define a 'melli'
% - melli                 define {X,Y,Z}-ellipsoid
% - melli2                same as melli but in (radius, center, axes) format
%(b) extract data from 'ssmodel'
% - melli/size            size of elements of the ellipsoid
% - melli/center          extract center of ellipsoid
% - melli/radius          extract "radius" of ellipsoid 
% - melli/volume          extract volume of ellipsoid 
% - melli/usample         generate a random element in ellipsoid
% - melli/isin            test if matrix belongs to ellipsoid
% - melli/plot            plot projections of ellipsoid

%   This file is part of R-RoMulOC
%   Last Update 26-Aug-2016
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France
