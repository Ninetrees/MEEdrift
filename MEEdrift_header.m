%{
	Name: MEEdrift
	Description: Compare EDP E-field measurements with calculated EDI E-fields

	2015-09-20 ~ v02.02.00:
	 ~ Update test mode logic.
	 ~ Enhance MEEdrift_writeCurrentPlotData report.
	 ~ Correct saved beam plot series filename root, based on EDP ql file name.
	 ~ Replace OCS|BPP plot zoom range with origin (x,y,z)+range.
	 ~ Add Replot button.
	 ~ Add BC S* to legend if selected.

	2015-09-06 ~ v02.01.00:
	 ~ Multiply each EDP component by the Fahleson factor, 1.0/0.7.
	   Provide EDP multiplication factors for xyz.
	 ~ Remove a 2 mV/m sunward offset from Ex. Use existing EDPxyz offsets.
	 ~ Multiply Ez by -1. Use existing EDP multiplication factors.
	 ~ Add check box for displaying E.B=0 ~> S* = cross (centerBeamB, edp_EdotB_dmpa).
	 ~ Add OCS, BPP axes max field to control panel.

	2015-08-28 ~ v02.00.00:
	 ~ Remove reentrancy.
	 ~ Add EDP smoothing.
	 ~ Add EDP Y-axis plot scale.
	 ~ Test SPDF PatchVersion: '3.6.0.6' wrt new spdfcdfinfo enhancements.
	   See, for example, mms_ql_EDI_fileInfo = spdfcdfinfo (mms_ql__EDI__BdvE__data)
	   and subsequent processing. (MEEdrift_read_ql__EDI__B__EDP_data.m)
	   See spdfcdfinfo.m header for important notes about usage.
	 ~ Add EDPxyz offset (mV) boxes to Control Panel
	   to add|subtract some offset from EDP data, and redisplay.
	 ~ Add EDPxyz offset button to Main Menu.
	 ~ Add Smoothing button to Main Menu.
	 ~ Always use smoothed EDP data if smoothing has been applied.
	 ~ Check smoothing after applying EPDxyz offsets.

	2015-08-14 ~ v01.02.00:
	 ~ Some code files were getting too busy. Split off logical code blocks.
	 ~ Implemented smoothing: implemented edp_E3D_dsl, edp_E3D_dsl_r, edp_E3D_dsl_s.
	   See code notes for usage.
	 ~ Add GUI panel for main menu, replacing listbox.
	 ~ Add GUI panel for global options: Reentrant, PlotConvergence, etc.,
	   replacing need to edit program before each run, and eliminating need for
	   configuration files.

	2015-08-12 ~ v01.01.00:
	 ~ MEEdrift plots S* from the EDI data file. Add S* plot from selected beams.
	   Make it menu-selectable.
	 ~ Import production EDI drift step code, including Grubbs outliers code.
	 ~ Update 7zip and Git pkg files.

	2015-08-09 ~ v01.00.00:
	 ~ Uses special EDI, B, EDP extracts from commissioning data for initial dev
	   MMS2: May 9, 2015  16:08 - 16:13
	   MMS4: May 6, 2015  15:30 - 15:35
	 ~ Prepare MEEdrift for git, GitHub version control system

	Important !!! notes about variable naming conventions
	iVarName is an index to VarName
	iiVarName is an index to an index to VarName; e.g., VarName (iVarName (iiVarName))
	nVarName is the number of elements in VarName
	_mdcs is MMS despun coord system. It stands for any that is useful.
	_dn  indicates a MATLAB datenum variable
	_t2k indicates a CDF TT2000 variable
	u or _u is a unit vector; _u used for clarity when needed
	2n indicates a 2-norm result.

	MATLAB datenum does not include leap seconds as of 2015-07-28, so...
	the chioces are tt2000 or tt2000~>ssm (seconds since midnight).
	ssm has the advantage of already being in seconds, where so many calcs are done,
	but doesn't cross midnight without handling at each calc.
	tt2000 handles leap seconds and midnight, but requires handling in some cases;
	e.g., if abs ((edp_t2k (iEDP_t2kHI) - gd_beam_t2k (iBeam)) < 1.0e8),
	rather than if abs ((edp_ssm (iEDP_t2kHI) - edi_gd_beam_ssm (iBeam)) < 0.1s).
	In this cose, note the uniform conversion from tt2k in ns to some other time
	simply by using the relationship tt2k * 1e9 = seconds.

	A note about MATLAB & matrices in MEEdrift:
	!!! Matrices are row vectors for efficiency 'find'ing, plotting !!!
	!!! but all math is with col vectors for linear algebra consistency !!!
	!!! This means that when vectors are filled from row vector matrices, they are transposed. !!!
	In MATLAB, a vector is a one-dimensional array and a matrix is a two-dimensional array.
	MDAa are created by extending 2D arrays; e.g., [:, :, n, ...].
		For example: (3, 2, 5, nEDP) =
			a 3D vector, for each of 2 intersecting beams, for up to 5 matches, for each EDP event
	MEEdrift 1D row or col vectors are addressed simply by V (i).
	MEEdrift 2D & 3D vectors are considered column vectors; e.g., V = [ v1 v2 ...], where each vector is v1 = [ v11; v12; ... ],
	unless noted.
	MEEdrift rotation matrices are 3x3 matrices of 3D vectors; arrays of them are 3x3xn.
	spdfcdfread places data into row vectors, so matrices returned as n x 2 (for example), but we typically use 2 x n.

	For efficiency, matrices are pre-allocated using syntax similar to: M = zeros (1, n_records, 'double'),
	UNLESS routines such as textread or spdfcdfread allocate space during the read process.

	For clarification, variables are cleared when no longer needed.
	Generally, variables beginning with 'i' are indices, 'n' are counts.

	Assume
	~ 1° degree knowledge of beam firing direction
	~ Time of flight of the electrons with a resolution better than 1 us

	Viewed from +GSEz, the MMS spacecraft rotate CCW, and spacecraft coords are GSE-like;
	i.e., DBCS ~= DMPA ~= DSL, and all 3 are close to GSE.

	!!! CDF record numbers are zer0-based !!! MATLAB records numbers are 1-based. Adjust accordingly.

	mms2_edi_slow_ql_efield_20150509_v0.1.4.cdf implements a 1:many record cross-reference twixt
	mms2_edi_recnum:mms2_edi_recnum_gd12|mms2_edi_recnum_gd21. These xrefs are used to link EDI records to
	B(dvE) records.
%}
