% MEEdrift_plot_EDP_data

figure (fEDP_plot);
edp_plotStart = 1;
edp_plotEnd   = nEDP;

timeSeries {1} = edp_dn (edp_plotStart: edp_plotEnd);
EDP_DataSeries {1}  = edp_E3D_dsl (:, edp_plotStart: edp_plotEnd);

hold off
hEDP_plot = plot (hEDP_mainAxes, ...
	edp_dn, edp_E3D_dsl, ...
	'LineStyle', '-', 'Marker', '.', 'MarkerSize', 2);

hold on

set (gca, 'FontSize', 10);
grid on;

EDP_plot_index_line = edp_dn (5); % just pick one; it will be rewritten by the BPP plot, but needs to init here

hEDP_plot_index_line = line ( ...
	[EDP_plot_index_line EDP_plot_index_line], ...
	get (hEDP_mainAxes, 'YLim'), ...
	'Color', 'red' , 'LineStyle', '-' , 'LineWidth', 2);

DateStart = timeSeries {1} (1);
DateEnd   = timeSeries {1} (end);
xlim ([DateStart DateEnd]);
xTickData = linspace (DateStart, DateEnd, 5);
set (gca, 'XTick', xTickData);
datetick (hEDP_mainAxes, 'x', 'HH:MM:SS', 'keepticks', 'keeplimits');
ZoomDateTicks ('on');

hLegend = legend (hEDP_mainAxes, 'EDP E_x', 'EDP E_y', 'EDP E_z', 'Location', 'NorthEast');
hText = findobj (hLegend, 'type', 'text');
nhText = size (hText,1);
for i = 1: nhText
	set (hText (nhText-i+1), 'color', DefaultAxesColors (i,:)); % Believe it or not, hText is in reverse order!!
end

MEEdrift_plot_EDP_zoomed_region
