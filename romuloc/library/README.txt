This folder contains all functions used to build robust control problems.
The functions are classified with the following rule :

MaaCbbTccPdd.m

For Models
aa=01 : LTI models without uncertainties 
(analysis handled with analytic tools, can also be done as if LFT models with empty uncertainty)
aa=11 : LFT models
aa=21 : Polytopic models
aa=22 : Paralelotopic models
aa=23 : Interval models

Type of Control problem
bb=01 : Analysis
bb=11 : State-feedback
bb=12 : Ellipsoidal set of State-feedback gains
bb=21 : Full-order dynamic output-feedback
bb=22 : Ellipsoidal set of full-order dynamic-output controllers 
bb=31 : Static output-feedback 
bb=32 : Ellipsoidal set of static output-feedback gains 
bb=41 : Fixed-order output-feedback 

Which Theory is used
cc=01 : quadratic stability (or classical Lyap theory if no uncertainties)
cc=11 : PDLF with P(Del)=[1 Cd'*Del_a']P[1 ; Del_a*Cd]
cc=19 : PDLF with PA Bliman method
cc=21 : PDLF with P(Del)=Sum zeta_i P_i AND slack variables
cc=22 : PDLF with P(Del)=Sum zeta_i P_i 
              AND coupling constraints (PLD Peres)
cc=23 : PDLF with P(Del)=Sum zeta_i P_i 
              AND coupling constraints 
              AND slack variables (PLD Peres) 

Required Performances
dd=01 : stability
dd=11 : regional pole location 
(at the present time dd=11 and dd=01 do the same, only order 1 regions)
dd=21 : Hinfinity performance
dd=31 : H2 performance
dd=41 : impulse to peak performance

IMPLEMENTED AT THIS TIME 

		LTI (M01)	LFT (M11)	Poly (M21)	Para (M22)	Inte (M23)
------------------------------------------------------------------------------------------
Analysis (C01)
QS (T01)	st/po/Hi/H2/i2p	st/po/Hi/H2/i2p	st/po/Hi/H2/i2p
PDLF (T11)	-		st/po/Hi/H2/i2p	-		-		-
PDLF (T19)	-								
PDLF (T21)	-		-		st/po/Hi/H2/i2p				
PDLF (T22)	-		-						
PDLF (T23)	-		-			
------------------------------------------------------------------------------------------
State-Feedback (C11)
QS (T01)			st/po/Hi/H2/i2p	st/po/Hi/H2/i2p
PDLF (T11)	-				-		-		-
PDLF (T19)	-								
PDLF (T21)	-		-						
PDLF (T22)	-		-						
PDLF (T23)	-		-						
------------------------------------------------------------------------------------------
State-Feedback with ellipsoids (C12)
QS (T01)					
PDLF (T11)	-				-		-		-
PDLF (T19)	-								
PDLF (T21)	-		-						
PDLF (T22)	-		-						
PDLF (T23)	-		-						
------------------------------------------------------------------------------------------
Full-Order Output-Feedback (C21)
QS (T01)					
PDLF (T11)	-				-		-		-
PDLF (T19)	-								
PDLF (T21)	-		-						
PDLF (T22)	-		-						
PDLF (T23)	-		-						
------------------------------------------------------------------------------------------
Full-Order Output-Feedback with ellipsoids (C22)
QS (T01)					
PDLF (T11)	-				-		-		-
PDLF (T19)	-								
PDLF (T21)	-		-						
PDLF (T22)	-		-						
PDLF (T23)	-		-		
------------------------------------------------------------------------------------------
Static Output-Feedback (C31)
QS (T01)					
PDLF (T11)	-				-		-		-
PDLF (T19)	-								
PDLF (T21)	-		-						
PDLF (T22)	-		-						
PDLF (T23)	-		-						
------------------------------------------------------------------------------------------
Static Output-Feedback with ellipsoids (C32)
QS (T01)					
PDLF (T11)	-				-		-		-
PDLF (T19)	-								
PDLF (T21)	-		-						
PDLF (T22)	-		-						
PDLF (T23)	-		-			
------------------------------------------------------------------------------------------
Fixed Order Output-Feedback (C41)
QS (T01)					
PDLF (T11)	-				-		-		-
PDLF (T19)	-								
PDLF (T21)	-		-						
PDLF (T22)	-		-						
PDLF (T23)	-		-						
------------------------------------------------------------------------------------------
Fixed Order Output-Feedback with ellipsoids (C42)
QS (T01)					
PDLF (T11)	-				-		-		-
PDLF (T19)	-								
PDLF (T21)	-		-						
PDLF (T22)	-		-						
PDLF (T23)	-		-						
		

%   This file is part of RoMulOC
%   Last Update 31-Jan-2005
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France
