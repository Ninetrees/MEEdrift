% MEEdrift_smoothing
% disp 'MEEdrift_smoothing' % V&V

% RecursiveMovingAverageFilter: Filter size should be odd > 1
% RecursiveMovingAverageFilter: Expects a col of values, n x 1
% To see both raw and smoothed data on the same plot,
% be sure to assign the smoothed data to edp_E3D_dsl_s,
% and set PlotRawAndSmoothed = true below. To see only the smoothed data,
% simply assign it back to edp_E3D_dsl as above.

if SmoothData
	% _dsl here is 3xn; matrix processing is faster in cols ~> nx3
	edp_E3D_dsl_s (:,1) = RecursiveMovingAverageFilter (edp_E3D_dsl (1,:)', 9);
	edp_E3D_dsl_s (:,2) = RecursiveMovingAverageFilter (edp_E3D_dsl (2,:)', 9);
	edp_E3D_dsl_s (:,3) = RecursiveMovingAverageFilter (edp_E3D_dsl (3,:)', 9);

	disp 'Using smoothed EDP data'
	edp_E3D_dsl = edp_E3D_dsl_s'; % transpose it for math
	% plot the smoothed data for comparison... done in plot_EDP_data and plot_EDP_zoomed_data
end
