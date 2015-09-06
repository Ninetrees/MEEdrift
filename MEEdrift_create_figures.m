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

hEDP_mainAxes   = subplot ('Position', [0.05 0.10 0.65 0.80]);
hEDP_zoomedAxes = subplot ('Position', [0.74 0.10 0.25 0.80]);

fDMPA_plot = figure ('Position', [ 0.0*ScreenWidth 0.0*ScreenHeight 0.7*ScreenHeight 0.6*ScreenHeight ]);
set (fDMPA_plot, 'WindowStyle', 'normal')
set (fDMPA_plot, 'DockControls', 'off')
set (gcf, 'name', 'Spacecraft and beams in DMPA', 'NumberTitle', 'off');

fBPP_plot = figure ('Position', [ 0.5*ScreenWidth 0.0*ScreenHeight 0.7*ScreenHeight 0.6*ScreenHeight ]);
set (fBPP_plot, 'WindowStyle', 'normal')
set (fBPP_plot, 'DockControls', 'off')
set (gcf, 'name', 'Spacecraft and beams in BPP', 'NumberTitle', 'off');
