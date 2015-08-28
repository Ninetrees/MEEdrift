% MEEdrift_plot_EDP_zoomed_region
% disp 'MEEdrift_plot_EDP_zoomed_region' % V&V

% if ~exist ('hEDP_zoomedAxes')
% 	hEDP_zoomedAxes = subplot (1, 8, [6,8]);
% 	EDP_plotZoomPos = get (hEDP_zoomedAxes, 'position'); % [left,bottom,width,height]
% 	set (hEDP_zoomedAxes, 'position', ...
% 		[EDP_plotZoomPos(1)+0.03 EDP_plotZoomPos(2) EDP_plotZoomPos(3) EDP_plotZoomPos(4)]);
% else
	axes (hEDP_zoomedAxes);
if exist ('hEDP_zoomedPlot')
	delete (hEDP_zoomedPlot);
end

zoomTimeSeries {1} = edp_dn (edp_zoomStart: edp_zoomEnd);
zoomDataSeries {1} = edp_E3D_dsl (:, edp_zoomStart: edp_zoomEnd);
% if SmoothData
% 	zoomDataSeriesf {1} = edp_E3D_dsl_s (:, edp_zoomStart: edp_zoomEnd);
% else
% 	zoomDataSeriesf {1} = edp_E3D_dsl (:, edp_zoomStart: edp_zoomEnd);
% end

hEDP_zoomedPlot = plot (hEDP_zoomedAxes, ...
	zoomTimeSeries {1}, zoomDataSeries {1}, ...
	'LineStyle', '-', 'Marker', '.', 'MarkerSize', 2);
% 	zoomTimeSeries {1}, zoomDataSeriesf {1}, ...

zoom_dateStart = zoomTimeSeries {1} (1);
zoom_dateEnd   = zoomTimeSeries {1} (200);
xlim ([zoom_dateStart zoom_dateEnd]);
xTickData = linspace (zoom_dateStart, zoom_dateEnd, 5);
set (gca, 'XTick', xTickData);
datetick (hEDP_zoomedAxes, 'x', 'MM:SS', 'keepticks', 'keeplimits');
ZoomDateTicks ('on');
