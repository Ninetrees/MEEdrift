% MEEdrift
MEEdrift_header % Please see the header for important application notes and programming conventions

disp 'Initializing...'
clc             % clear the command window
clear variables
close all       % close all figures

global Project_;             Project_            = 'MMS_EDI_EDP_driftstep';
global dotVersion;           dotVersion          = 'v2.01.00';
global beamsWindow;          beamsWindow         = 4; % n, NOTE !!!! ± beamsWindow before|after center beam time
global beamWindowSecs;       beamWindowSecs      = 2; % (s), NOTE !!!! ± beamWindowSecs before|after center beam time
global ControlPanelActive;   ControlPanelActive  = false; % control panel can be open even if the main menu closes
global PlotBeamConvergence;  PlotBeamConvergence = false; % Calculate and plot S* from displayed beams
global PlotIntersectDots;    PlotIntersectDots   = false; % Calculate and plot S* from displayed beams
global PlotHoldOff;          PlotHoldOff         = true;  % Set to false to plot multiple beam data records on the same plot; true gets but 1
global PlotSubplots;         PlotSubplots        = false; % true=plot the data as it is read in; only works for read routines with embedded plot commands
global PlotView;             PlotView            = '2D';  % or 3D; the plot is always 3D, but this switches the initial plot display perspective
global ScrollData;           ScrollData          = true;
global UseFileOpenGUI;       UseFileOpenGUI      = true;
global Use_OCS_plot;         Use_OCS_plot        = false;
beamWindowDays = beamWindowSecs / 86400.0; % Convert from seconds to days; to compare with datenums
sinx_wt_Q_xovr_angles = [ 8.0 30 ];
global sinx_wt_Q_xovr;       sinx_wt_Q_xovr      = sind (sinx_wt_Q_xovr_angles).^4.0; % breakpoints for quality ranges for sin^x weighting

global EDPx_offset;          EDPx_offset         = -2.0; % mV, applied to EDP data to shift it
global EDPy_offset;          EDPy_offset         = 0.0;
global EDPz_offset;          EDPz_offset         = 0.0;

global EDPx_factor;          EDPx_factor         =  1.0/0.7; % Fahleson factor?
global EDPy_factor;          EDPy_factor         =  1.0/0.7;
global EDPz_factor;          EDPz_factor         = -1.0/0.7; % Fahleson factor? + flip sign of Ez

global SmoothData;           SmoothData          = false;
global UseSmoothedData;      UseSmoothedData     = false;
global SmoothingSpan;        SmoothingSpan       = 13; % Must be odd

global hEDP_mainAxes;
global hEDP_zoomedAxes;
global EDP_plot_ylim;        EDP_plot_ylim       = 99;
global OCS_BPP_axisMax;      OCS_BPP_axisMax     = 6;

TestMode = false; % true false

myLibAppConstants
% Constants used to calculate beam geometry
myLibScienceConstants

MEEdrift_create_figures

mmsRPM           = 3.0; % nominal, 1 spin ~20 s. 0.05 Hz
mmsSpinPeriod    = 20.0; % seconds, nominal
EDP_sampleFreq   = 128.0; % samples per second
EDP_samplePeriod = 1.0 / 128.0; % seconds per sample

% MMS Phase 1 orbits:
% HEO (Highly Elliptical Orbit) of 1.2 RE (perigee) x 12 RE (apogee),
% Perigee: 7645 km (1274 net) | Apogee: 76452 km (70080 net)
% Inclination: 28.77 deg | Flight Azimuth: 99.0 deg
% Note: 1 RE ~= 6371 km.
% MMS observatory mass at launch 1200 kg.
MMS_apogee  = 12.0 * Re;
MMS_perigee = 1.20 * Re;
% At apogee, we trade KE for PE, so v_apogee < v_perigee
MMS_speed_apogee  = sqrt ( (2 * GM * MMS_perigee) / (MMS_apogee * (MMS_apogee + MMS_perigee)) ); % ~ 973  m/s
MMS_speed_perigee = sqrt ( (2 * GM * MMS_apogee) / (MMS_perigee * (MMS_apogee + MMS_perigee)) ); % ~ 9736 m/s
% Distance spacecraft moves in gyroPeriod of 0.00023835 s
% apogee: ~= 0.232 m, perigee ~= 2.32 m

GDUz_loc = 0.0;

% See 'MMS Hardware and Data Processing notes.txt'
EDI1gunLoc = [ -1.45598,  1.11837, 0.0 ]; % EDI2 gun atan2(-1.11837, 1.45598)*180/pi ~> -37.52865°
EDI1detLoc = [ -1.35885,  1.03395, 0.0 ]; % EDI2 det atan2(-1.03395, 1.35885)*180/pi ~> -37.26753°
EDI2gunLoc = [  1.45598, -1.11837, 0.0 ]; % EDI1detLoc:EDI1gunLoc angle = atan2(1.11837-1.03395, -1.45598+1.35885)*180/pi ~> -40.995°
EDI2detLoc = [  1.35885, -1.03395, 0.0 ]; % norm(EDI1gunLoc-EDI1detLoc,2) = 0.128689
mmsEDI_VirtualRadius = norm (EDI1gunLoc-EDI2detLoc, 2);

instrPlaneDMPA    = zeros (3, 361, 'double');
for theta = 0:1:360
	instrPlaneDMPA (:, theta+1) = mmsEDI_VirtualRadius * [ cosd(theta); sind(theta); 0.0 ];
end

BeamCoordsX = -8: 0.01: 8;
Beam_z      = zeros (1, size (BeamCoordsX, 2), 'double');

% default 1; ii = index into index, a doubly-dereferenced pointer
% iiSorted_beam_t2k is used to scroll through iSorted_beam_t2k in linear
% order, and iSorted_beam_t2k is an index of time-sorted pointers into *beam_t2k
iiSorted_beam_t2k = uint32 (1);
FFTplotted = false;

disp (['Starting MEEdrift ' dotVersion])

ButtonReply = '';
DialogPos = [ 600 500 ];
[ButtonReply, DialogPos] = MEEdrift_questDlg_uitools (DialogPos, ...
	'Load Saved or Process New Data', 'Data Options', 'Load Saved', 'Process New', 'Process New'); % limit 3 buttons

switch ButtonReply
	case 'Load Saved'
		% ==================================== Choose your time period and spacecraft
		[eventFile, eventPath] = uigetfile ('MEEdrift*.mat', 'Select date, spacecraft, time to analyze');
		if isequal (eventFile,  0) % then no valid file selected
			msgbox ('No valid MEEdrift event file selected.');
			ValidDataLoaded = false;
		else
			load ([eventPath, eventFile])
		end
		LoadEvent = true;
		SaveEvent = false;
	case 'Process New'
		LoadEvent = false;
		SaveEvent = false;
end

if LoadEvent
else
	if TestMode
		beamsWindow = 8;
		UseFileOpenGUI = false;

		mms_ql_dataPath = 'D:\MMS\MATLAB\MEEdrift';

		mms_ql__EDI__BdvE__dataFile = 'mms2_edi_slow_ql_efield_20150509_v0.1.4.cdf';
		mms_ql__EDI__BdvE__dataFile = 'mms2_edi_srvy_ql_efield_20150509_v0.1.5.cdf';
		mms_ql__EDI__BdvE__data = [mms_ql_dataPath cFileSep mms_ql__EDI__BdvE__dataFile];

		mms_ql__EDP__dataFile = 'mms2_edp_comm_ql_dce2d_20150509120000_v0.1.0.cdf';
		mms_ql__EDP_data = [mms_ql_dataPath cFileSep mms_ql__EDP__dataFile];

		Event = mms_ql__EDI__BdvE__dataFile (1:24); % An event label used to indentify this analysis
		Event = ['MEEdrift_', dotVersion, '_', Event];
	else
		ValidDataLoaded = false;
		UseFileOpenGUI = true;
	end

	MEEdrift_read_ql__EDI__B__EDP_data
end

ButtonReply  = '';
DSI_view3D = true;
Selection = 2;
plotBeamDots = false;
strSelection    = '> Beam >';
strPlotBeamDots = 'Plot Beam Dots is OFF';

global strMainMenu; strMainMenu = '> Beam >'; % 1.02: begin using GUI menu

if ScrollData
	while ValidDataLoaded && ~strcmp (strMainMenu, 'Exit')
		if ~isempty (strfind ([ ...
			'< Beam <', ...
			'> Beam >', ...
			'Skip via EDP' ], ...
			strSelection)) % or if plot dots
			MEEdrift_plot_beams
		end

		MEEdrift_main_menu

		switch strMainMenu
			case 'Apply EDP Offsets'
				MEEdrift_apply_EDP_offsets

		  case '< Beam <'
				iiSorted_beam_t2k = max (1, iiSorted_beam_t2k-1);

			case '> Beam >'
				iiSorted_beam_t2k = min (nBeams, iiSorted_beam_t2k+1);

			case 'Skip via EDP'
				figure (fEDP_plot);
				[edp_timeIndex, mV] = ginput (1); % time axis is in datenum, E-field in mV
				last_iiSorted_beam_t2k = iiSorted_beam_t2k;
				if ~isempty (edp_timeIndex)
					% Go to the nearest EDI record that is in the neighborhood of this EDP record
					% Note the switch from EDP to EDI here
					% disp ( sprintf ('Skip via EDP: edp_timeIndex: s%', datestr (edp_timeIndex, 'yyyy-mm-dd HH:MM:ss.fff') ) ) % V&V
					iedi_timeIndex = find (gd_beam_dn > edp_timeIndex, 1);
					% disp ( sprintf ('Skip via EDP: gd_beam_dn %s', datestr (gd_beam_dn (iedi_timeIndex), 'yyyy-mm-dd HH:MM:ss.fff') ) ) % V&V

					if ~isempty (iedi_timeIndex)
						iiSorted_beam_t2k = find (iSorted_beam_t2k == iedi_timeIndex, 1);
					else
						disp 'Warning!!! No beam data found for this EDP point!'
						iiSorted_beam_t2k = last_iiSorted_beam_t2k;
					end
				end

			% sample filename: 'MEEdrift_1.00.00_M2_20010305_060419.217@20150108.224134*'
			% mms2_edi_slow_ql_efield_20150509_v0.1.4.cdf
			case 'Save Plots'
				SavePlotFilename = [ ...
					'.' cFileSep 'MEEdrift_', dotVersion, ...
					'_M', obsID, mms_ql__EDP__dataFile(23:31), '_', ...
					strBeamTime(12:13), strBeamTime(15:16), strBeamTime(18:23), '_', ...
					datestr(now, '@yyyymmdd_HHMMSS')];

				figure (fEDP_plot);
				set (gcf, 'PaperUnits', 'inches');
				set (gcf, 'PaperPosition', [0 0 12 3]); % x_width, y_width, NOT position; aim for 4:1
				saveas (fEDP_plot,  [ SavePlotFilename, 'a.png' ], 'png');

				if Use_OCS_plot
					saveas (fDMPA_plot, [ SavePlotFilename, 'b.png' ], 'png');
				end

				saveas (fBPP_plot,  [ SavePlotFilename, 'c.png' ], 'png');

				if FFTplotted
					saveas (fFFT_plot, [ SavePlotFilename, 'd.png' ], 'png');
				end

				disp (['Images saved as     "', SavePlotFilename, '[a|b|c|d].png', '".'])
				MEEdrift_writeCurrentPlotData

			case 'Save Snapshot'
			  disp ([ 'Event: ', Event ])
				if exist (Event, 'file')
					[status, attribs] = fileattrib ([Event,'.mat'])
					WriteMatFileOK = ~attribs.UserRead
				else
					WriteMatFileOK = true;
				end
				if WriteMatFileOK
					save (Event)
				else
					% 			warndlg (['Cannot save: ', Event, '.mat is Read Only.'], '!! Warning !!', 'modal') % does not work as modal r2014a
					% 			errordlg (['Cannot save: ', Event, '.mat is Read Only.'], '!! Warning !!', 'modal') % does not work as modal r2014a
					questdlg (['Cannot save: ', Event, '.mat is Read Only.'], 'Warning', 'OK', 'Cancel', 'OK'); % limit 3 buttons
				end

		  case 'Smooth EDP'
				MEEdrift_smoothing

			case 'Toggle DMPA <> BPP'
				DSI_view3D = ~DSI_view3D;
				if DSI_view3D
					if Use_OCS_plot
						figure (fDMPA_plot);
						view ([ 115 20 ]); % Azimuth, Elevation in degrees, 3D view
					end
				else % 2D view of BPP
					% Azimuth, Elevation in degrees, 3D view, based on B DMPA vector
					figure (fBPP_plot);
					view ([   0 90 ]); % Azimuth, Elevation in degrees, std x-y plot
					% view ([ 42 58 ])
					%	view ([ atand(abs(centerBeamB_u(2)/centerBeamB_u(1))) acosd(centerBeamB_u(3))-90.0 ]);
				end

			case 'Plot EDP FFT x,y'
				MEEdrift_FFT_MMS_EFW_data

		end % switch strSelection
	end % while ValidDataLoaded && ~strcmp (strSelection, 'Quit')

	hold off
	% clear gyroFrequency GyroPeriod_SI BavgBPP d_PredExB;
else % if ScrollData; else batch process
	MEEdrift_batch_process
end

disp (['MEEdrift ' dotVersion ' ended'])

MEEdrift_references
