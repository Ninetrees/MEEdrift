% MEEdrift_writeCurrentPlotData

format long g

PlotLogFileID = fopen ([ SavePlotFilename, '.txt'], 'w');

fprintf (PlotLogFileID, 'MEEdrift %s\n', dotVersion);

fprintf (PlotLogFileID, '%s\n', mms_ql__EDI__BdvE__dataFile);
fprintf (PlotLogFileID, '%s\n', mms_ql__EDP__dataFile);

fprintf (PlotLogFileID, 'Beam analysis data files "%s.*"\n', SavePlotFilename);

fprintf (PlotLogFileID, 'Beam record      : %d\n', iCenterBeam);
fprintf (PlotLogFileID, 'gd_beam_t2k      : %d\n', centerBeam_t2k);
strCenterBeam = datestr (centerBeam_dn, 'yyyy-mm-dd HH:MM:ss.fff');
fprintf (PlotLogFileID, 'Beam time        : %s\n', strCenterBeam);

fprintf (PlotLogFileID, 'edp_E_BPP        : %g %g %g\n', DMPA2BPP * edp_E_interp);
fprintf (PlotLogFileID, 'edp_E_BPP E.B=0  : %g %g %g\n', DMPA2BPP * edp_EdotB_dmpa); % 20150910, really dsl, not dmpa
fprintf (PlotLogFileID, 'B DMPA           : %g %g %g\n', centerBeamB);
fprintf (PlotLogFileID, 'B BPP            : %g %g %g\n', DMPA2BPP * centerBeamB);
fprintf (PlotLogFileID, '||B||            : %3.0f\n',    centerBeamB2n);

if S_star_dmpa (1) ~= -edi_d_dmpa_fillVal % S* is the negative of the drift step, so FILLVALs are negated, too
	fprintf (PlotLogFileID, 'S* BPP (bestarg) : %g %g %g\n', S_star_bpp);
else
	fprintf (PlotLogFileID, 'S* BPP (bestarg) : %g %g %g\n', -S_star_dmpa);
end
if PlotBeamConvergence
	fprintf (PlotLogFileID, 'S* BPP (converge): %g %g %g\n', bc_S_star_bpp);
end
fprintf (PlotLogFileID, 'S* BPP EDP E.B=0 : %g %g %g\n', edp_EdotB_S_star_bpp);

fprintf (PlotLogFileID, 'Gyrofreq, period : %g Hz %g s\n', gyroFrequency, gyroPeriod);
fprintf (PlotLogFileID, 'DMPA2BPP\n');
fprintf (PlotLogFileID, '%16.13f %16.13f %16.13f\n', DMPA2BPP);

fclose (PlotLogFileID);
disp (['Beam analysis data saved as "', SavePlotFilename, '.txt', '".'])
