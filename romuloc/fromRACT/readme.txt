
************************************************
Readme file for the UNIF_GEN package:
************************************************


gen_vec.m
	algorithm for the generation of uniform (real or complex) 
	vectors in l_p norm-balls.

gen_mat.m
	algorithm for the generation of uniform (real or complex) 
	matrices in induced l_p norm-balls. In particular, this is the file
	to use for uniform generation in the spectral norm-ball.

gen_sig.m
	kernel algorithm for singular value generation, called by gen_mat.m.

gen_haar.m
	kernel algorithm for unitary or orthogonal matrix generation, 
	called by gen_mat.m.
	
gen_math.m
	algorithm for the generation of uniform (real or complex) 
	matrices in Hilbert-Schmidt l_p norm-balls. 
		
Fpoly.m; gamrnd.m; rndcheck.m
	auxiliary files.


Warning: The package uses the function c05adf.m from the MATLAB NAG Toolbox.	
			If the NAG Toolbox is not available, the user may check file
			gen_sig.m at line 91.


References:
[1] G. Calafiore, F. Dabbene, R. Tempo. 
		``Randomized Algorithms for Probabilistic Robustness with Real and Complex 
		Structured Uncertainty." Report N. CENS-1999-02. Submitted for publication.
[2] G. Calafiore, F. Dabbene, R. Tempo. 
		``Uniform Sample Generation in $\ell_p$ Balls for Probabilistic Robustness Analysis.'' 
		Proceedings of CDC 1998, Tampa, Florida, Dec. 1998.
[3] G. Calafiore, F. Dabbene, R. Tempo. 
		``Radial and Uniform Distributions in Vector and Matrix Spaces for 
		Probabilistic Robustness.'' In Recent Advances in Control, (Eds. D. Miller and L. Qiu), 
		Springer-Verlag, New York, 1999.
