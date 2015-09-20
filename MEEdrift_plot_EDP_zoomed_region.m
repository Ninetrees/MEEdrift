% MEEdrift_plot_EDP_zoomed_region
% disp 'MEEdrift_plot_EDP_zoomed_region' % V&V

axes (hEDP_zoomedAxes);
if exist ('hEDP_zoomedPlot')
	delete (hEDP_zoomedPlot);
end

zoomTimeSeries {1} = edp_dn (edp_zoomStart: edp_zoomEnd);
zoomDataSeries {1} = edp_E3D_dsl (:, edp_zoomStart: edp_zoomEnd);
% edp_E3D_dsl_zoomStart = edp_E3D_dsl (:, edp_zoomStart); % V&V

hEDP_zoomedPlot = plot (hEDP_zoomedAxes, ...
	zoomTimeSeries {1}, zoomDataSeries {1}, ...
	'LineStyle', '-', 'Marker', '.', 'MarkerSize', 2);

hZoomedLegend = legend (hEDP_zoomedAxes, 'EDP E_x', 'EDP E_y', 'EDP E_z', 'Location', 'NorthEast');
hText = findobj (hZoomedLegend, 'type', 'text');
nhText = size (hText,1);
for i = 1: nhText
	set (hText (nhText-i+1), 'color', DefaultAxesColors (i,:)); % Believe it or not, hText is in reverse order!!
end

zoom_dateStart = zoomTimeSeries {1} (1);
zoom_dateEnd   = zoomTimeSeries {1} (200);
xlim ([zoom_dateStart zoom_dateEnd]);
xTickData = linspace (zoom_dateStart, zoom_dateEnd, 5);
set (gca, 'XTick', xTickData);
datetick (hEDP_zoomedAxes, 'x', 'MM:SS', 'keepticks', 'keeplimits');
ZoomDateTicks ('on');
