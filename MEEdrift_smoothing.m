% MEEdrift_smoothing
% disp 'MEEdrift_smoothing' % V&V

% RecursiveMovingAverageFilter: Filter size should be odd > 1
% RecursiveMovingAverageFilter: Expects a col of values, n x 1
% To see both raw and smoothed data on the same plot,
% be sure to assign the smoothed data to edp_E3D_dsl_s,
% and set PlotRawAndSmoothed = true below. To see only the smoothed data,
% simply assign it back to edp_E3D_dsl as above.

% You can choose to plot it and use it, or just display it.
UseSmoothedData = false; % triggers edp_E3D_dsl <> edp_E3D_dsl_s swap below

change edp data to edp_raw, and assign either edp_raw or edp_s (smoothed) to edp

if SmoothData
	% _r here is nx3, which works well for plotting and matrix searches
	edp_E3D_dsl_s (:,1) = RecursiveMovingAverageFilter (edp_E3D_dsl_r (:,1), 9); % filter
	edp_E3D_dsl_s (:,2) = RecursiveMovingAverageFilter (edp_E3D_dsl_r (:,2), 9); % filter
	edp_E3D_dsl_s (:,3) = RecursiveMovingAverageFilter (edp_E3D_dsl_r (:,3), 9); % filter

	if UseSmoothedData
		disp 'Using smoothed EDP data'
		edp_E3D_dsl  = edp_E3D_dsl_s'; % transpose it for math
	end
	% plot the smoothed data for comparison... done in plot_EDP_data and plot_EDP_zoomed_data
end

% Calculate ssm (seconds since midnight) from L2 epoch16, 2xn in Windows
% EFW_L2_epochAsIs_cdfread = spdfcdfread (MMS_edp_E3D_dsl_data, 'CombineRecords', true, 'KeepEpochAsIs', true, 'Variable', {MMS_timeTagsID});
% EFW_L2_epochAsIsDims = size (EFW_L2_epochAsIs_cdfread);  % debug workaround for Linux

% if (EFW_L2_epochAsIsDims (2) == 2)
% 	disp 'The Linux version of spdfcdfread has these transposed!'
% 	EFW_L2_epochAsIs_cdfread = EFW_L2_epochAsIs_cdfread';
% end
% EFW_L2_epochAsIs_cdfread (:, iFillVal) = [];
% 	EFW_L2_epochAsIs_cdfread (:, iFillVal) = NaN;

% EFW_L2_epochAsIs = EFW_L2_epochAsIs_cdfread (1, :) + (EFW_L2_epochAsIs_cdfread (2, :) * 1.0e-12); % Convert epoch16 > datenum
% EFW_L2_datenum = (EFW_L2_epochAsIs + 86400.0); % convert epoch to datenum base (almost: needs / 86400.0, but see * 86400.0 below)
% epochDay = datenum (YYYY, MM, DD, 00, 00, 00); % subtract start of sample day
% EFW_L2_ssm = (EFW_L2_datenum - epochDay * 86400.0); % datenum expressed as ssm

% dtEFW_L2_datenum = datetime (EFW_L2_datenum / 86400.0);
% dtEFW_L2_datenum.Format = ('HH:MM:SS');
% clear EFW_L2_epochAsIs EFW_L2_EpochDay EFW_L2_datenum
% returns MMS_dataPath, MMS_edp_E3D_dsl_dataFile, MMS_edp_E3D_dsl_data, edp_E3D_dsl_records, edp_E3D_dsl, EFW_L2_ssm

figure (fEDP_plot);
edp_plotStart = 1;
edp_plotEnd   = nEDP;
%   edp_E3D_dsl  (2,:) = edp_E3D_dsl  (1,:);
%   edp_E3D_dsl_s  (2,:) = edp_E3D_dsl_s  (1,:);
timeSeries {1}  = edp_dn (edp_plotStart: edp_plotEnd)';
MMS_DataSeries {1}  = edp_E3D_dsl  (:, edp_plotStart: edp_plotEnd);
if SmoothData
	dataSeriesf {1} = edp_E3D_dsl_s (:, edp_plotStart: edp_plotEnd);
else
	dataSeriesf {1} = edp_E3D_dsl (:, edp_plotStart: edp_plotEnd);
end

hold on
% 	if PlotRawAndSmoothed % 'LineStyle', 'none'
% 		plot (timeSeries {1}, MMS_DataSeries {1}, timeSeries {1}, dataSeriesf {1}, 'LineStyle', '-', 'Marker', '.', 'MarkerSize', 2);
hEDP_plot_mainAxes = subplot (1, 8, [1, 5]);
plot (...
	timeSeries {1}, MMS_DataSeries {1},...
	timeSeries {1}, dataSeriesf {1},...
	'LineStyle', '-', 'Marker', '.', 'MarkerSize', 2);
% 	timeSeries {1}, EFW_L2_Equality,...

%  	hEFWplotAxes = axes;
% 	else
% 		plot (timeSeries {1}, MMS_DataSeries {1}, 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 2);
% 	end
set (gca, 'FontSize', 10);
grid on;

EDP_plot_index_line = edp_dn (5); % just pick one; it will be rewritten by the BPP plot, but needs to init here
% 	hEDP_plot_index_line = line ( [EDP_plot_index_line EDP_plot_index_line], get (hEFWplotAxes, 'YLim'), 'Color', 'red' , 'LineStyle', '-' , 'LineWidth', 2);
hEDP_plot_index_line = line ( [EDP_plot_index_line EDP_plot_index_line], get (hEDP_plot_mainAxes, 'YLim'), 'Color', 'red' , 'LineStyle', '-' , 'LineWidth', 2);
% 	dtEFW_L2_datenumPlotIndexLine = dtEFW_L2_datenum (5); % just pick one; it will be rewritten by the BPP plot, but needs to init here
% 	hEDP_plot_index_line = line ( [dtEFW_L2_datenumPlotIndexLine dtEFW_L2_datenumPlotIndexLine], get (hEFWplotAxes, 'YLim'), 'Color', 'red' , 'LineStyle', '-' , 'LineWidth', 2);

DateStart = timeSeries {1} (1);
DateEnd   = timeSeries {1} (end);
xlim ([DateStart DateEnd]);
xTickData = linspace (DateStart, DateEnd, 11);
set (gca, 'XTick', xTickData);
datetick ('x', 'HH:MM:SS','keepticks', 'keeplimits');
ZoomDateTicks ('on');
hLegend = legend (hEDP_plot_mainAxes, 'EFW Ex', 'EFW Ey', 'EFW Exf', 'EFW Eyf', 'Location', 'NorthEast');
hText = findobj (hLegend, 'type', 'text');
nhText = size (hText,1);
for i = 1: nhText
	set (hText (nhText-i+1), 'color', DefaultAxesColors (i,:)); % Believe it or not, hText is in reverse order!!
end

MEEdrift_plot_EDP_zoomed_region

TightFig;
% hLegend = legend (hEDP_plot_mainAxes, 'EFW E_x', 'EFW E_y', 'EFW E_x_f', 'EFW E_y_f', 'Quality', 'Location', 'NorthEast');
hLegend = legend (hEDP_plot_mainAxes, 'EFW E_x', 'EFW E_y', 'EFW E_x_f', 'EFW E_y_f', 'Location', 'NorthEast');

%      d=0.02; %distance between images
%      moon = imread('moon.tif');
%      s1=subplot(121);
%      imshow(moon);
%      s2=subplot(122);
%      imshow(moon);
%      set(s1,'position',[d 0 0.5-2*d 1])
%      set(s2,'position',[0.5+d 0 0.5-2*d 1])
%
%    d=0.05; %distance between images
%    moon = imread('moon.tif');
%    s1=subplot(121);
%    imshow(moon);
%    s2=subplot(122);
%    imshow(moon);
%    g1=get(s1,'position');
%    set(s1,'position',[0 0 0.5 1])
%    g2=get(s2,'position');
%    set(s2,'position',[g1(1)+g1(3)+d 0 0.5 1])
