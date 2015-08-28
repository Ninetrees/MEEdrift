% MEEdrift_apply_EDP_offsets

clear edp_E3D_dsl
EDP_offset = [ EDPx_offset EDPy_offset EDPz_offset ];
edp_E3D_dsl = bsxfun (@plus, edp_E3D_dsl_r, EDP_offset); %  n x 3
edp_E3D_dsl = edp_E3D_dsl';

% call Smoothing to see if it needs to be smoothed
MEEdrift_smoothing
