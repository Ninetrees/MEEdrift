% MEEdrift_create_figures

fEDP_plot  = 1;
fDMPA_plot = 2;
fBPP_plot  = 3;
fFFT_plot  = 4;

% [left, bottom, width, height]
fEDP_plot = figure ('Position', [ 0.05*ScreenWidth 0.55*ScreenHeight 0.9*ScreenWidth 0.375*ScreenHeight ]);
set (fEDP_plot, 'WindowStyle', 'normal')
set (fEDP_plot, 'DockControls', 'off')
set (gcf, 'name', 'MMS EDP Ex Ey (mV)', 'NumberTitle', 'off');

% hEDP_mainAxes = subplot ('Position', [0.05 0.20 0.65 0.70]);
hEDP_mainAxes = subplot ('Position', [0.05 0.10 0.65 0.80]);
hEDP_zoomedAxes = subplot ('Position', [0.74 0.10 0.25 0.80]);
% hEDP_zoomedAxes = subplot (1, 8, [6,8]);
% EDP_plotZoomPos = get (hEDP_zoomedAxes, 'position'); % [left,bottom,width,height]
% set (hEDP_zoomedAxes, 'position', ...
% 	[EDP_plotZoomPos(1)+0.03 EDP_plotZoomPos(2) EDP_plotZoomPos(3) EDP_plotZoomPos(4)]);
EDP_OffsetRange = 10.0;
EDPx_offset = 0.0;
EDPy_offset = 0.0;
EDPz_offset = 0.0;
% hEDPxSlider = uicontrol ( ...
% 	'Parent', fEDP_plot, 'Style', 'slider', 'Units', 'normalized', 'Position', [0.10 0.02 0.10 0.05], ...
% 	'Value', 0.0, 'Min', -EDP_OffsetRange, 'Max', EDP_OffsetRange);
%
% addlistener (hEDPxSlider, 'ContinuousValueChange', ...
% 	@(hObject, event) MEEdrift_set_EDP_offsets (hObject, event, 'x'));

fDMPA_plot = figure ('Position', [ 0.0*ScreenWidth 0.0*ScreenHeight 0.7*ScreenHeight 0.6*ScreenHeight ]);
set (fDMPA_plot, 'WindowStyle', 'normal')
set (fDMPA_plot, 'DockControls', 'off')
set (gcf, 'name', 'Spacecraft and beams in DMPA', 'NumberTitle', 'off');

fBPP_plot = figure ('Position', [ 0.5*ScreenWidth 0.0*ScreenHeight 0.7*ScreenHeight 0.6*ScreenHeight ]);
set (fBPP_plot, 'WindowStyle', 'normal')
set (fBPP_plot, 'DockControls', 'off')
set (gcf, 'name', 'Spacecraft and beams in BPP', 'NumberTitle', 'off');

