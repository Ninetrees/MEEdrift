% MEEdrift_apply_EDP_offsets

clear edp_E3D_dsl

% edp_E3D_dsl_r_v1 = edp_E3D_dsl_r(1,:) % V&V
EDP_offset = [ EDPx_offset EDPy_offset EDPz_offset ] % V&V

edp_E3D_dsl = bsxfun (@plus, edp_E3D_dsl_r, EDP_offset); %  n x 3
% edp_E3D_dsl_v1 = edp_E3D_dsl (1,:) % V&V

% Then scale by multiplication factor. Init as Fahleson factor of 1.0/0.7.
EDP_Xfactor = [ EDPx_factor EDPy_factor EDPz_factor ] % V&V
edp_E3D_dsl = bsxfun (@times, edp_E3D_dsl, EDP_Xfactor); %  n x 3
% edp_E3D_dsl_v1 = edp_E3D_dsl (1,:) % V&V

edp_E3D_dsl = edp_E3D_dsl';
% edp_E3D_dsl_v1 = edp_E3D_dsl (:,1) % V&V

% call Smoothing to see if it needs to be smoothed
MEEdrift_smoothing
MEEdrift_plot_EDP_data
