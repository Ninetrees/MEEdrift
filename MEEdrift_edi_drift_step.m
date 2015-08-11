% MEEdrift_edi_drift_step
% 	disp 'entering edi_drift_step' % debug

% Find the S* in BPP, using BPP FV convergence
% preAlloc beamIntercepts based on nTargetBeams: (nTargetBeams - 1) * nTargetBeams / 2
% -~-~-~-~-~-~-~-~-~
nBeamIntercepts  = (nTargetBeams-1) * nTargetBeams / 2;
beamIntercepts   = zeros (2, nBeamIntercepts, 'double');
interceptWeights = zeros (1, nBeamIntercepts, 'double');

driftStep     = [NaN; NaN; NaN];
dUncertainty  = [NaN; NaN; NaN];
driftVelocity = [NaN; NaN; NaN];
drift_E       = [NaN; NaN; NaN];

% 	nBeamIntercepts  = 0;
dsQuality = 0;
if nTargetBeams > 1 % can't have an intersection with just 1 beam
nTargetBeams
	% find the intercepts for all beams
	nBeamIntercepts = 0;
	for i = 1: nTargetBeams-1
		for j = i+1: nTargetBeams
			XY = [ ...
				-S_star_beams_m_bpp(i) 1 ;
				-S_star_beams_m_bpp(j) 1 ];
			b = [ S_star_beams_b_bpp(i) ; S_star_beams_b_bpp(j) ];
			nBeamIntercepts = nBeamIntercepts + 1;
			beamIntercepts (:, nBeamIntercepts) = XY \ b;
		end
	end

	% Not determined as of ?? is what angles really get what weight.
	% We tested sin^2, and got some satisfaction, but we really want to let most beams
	% count, and sharply penalize beams that intersect at small angles.
	% Changed to sin^4.
	% The check for macroBeamCheckAngle, if implemented, removes intercepts from CALCS if the
	% intercept angle is less than macroBeamCheckAngle.

	macroBeamCheckAngle = atan(tand(5));
	nBeamIntercepts = 0;
	for i = 1: nTargetBeams-1
		for j = i+1: nTargetBeams
			nBeamIntercepts = nBeamIntercepts + 1;

			interceptAngle (nBeamIntercepts) = abs (atan ( ...
				(S_star_beams_m_bpp(j) - S_star_beams_m_bpp(i)) / ...
				(1.0 + S_star_beams_m_bpp(i) * S_star_beams_m_bpp(j)) ) );

			interceptWeights (1, nBeamIntercepts) = sin (interceptAngle (nBeamIntercepts))^4;
		end
	end


	% This test is only valid if NaN is implements above;
	% otherwise, this is always true.
	interceptWeightsSum = nansum (interceptWeights);
	if interceptWeightsSum > 0.0
		% We will check the upper bound, P0=84%, alpha=P1=0.16 ~> +- 0.08 (lower|upper),
		% so div by 2.0, and pass just the upper bound.
		P0 = 0.84;
		edi_stats_alpha = (1.0 - P0) / 2.0;

		% disp 'Two Grubbs tests: x and y'
		ZConfidenceBounds = norminv (1.0 - (1.0 - P0) / 2.0);
		[ GrubbsBeamInterceptMean(1,1), GrubbsBeamInterceptStdDev(1,1), GrubbsBeamIntercepts ] = ...
			MEEdrift_GrubbsTestForOutliers (beamIntercepts (1,:), interceptWeights, edi_stats_alpha);
		ibx = find (isnan (GrubbsBeamIntercepts));

		[ GrubbsBeamInterceptMean(2,1), GrubbsBeamInterceptStdDev(2,1), GrubbsBeamIntercepts ] = ...
			MEEdrift_GrubbsTestForOutliers (beamIntercepts (2,:), interceptWeights, edi_stats_alpha);
		iby = find (isnan (GrubbsBeamIntercepts));

		iIntersectXYOutliers = union (ibx, iby);
		GrubbsBeamIntercepts = beamIntercepts;
		GrubbsBeamIntercepts (:, iIntersectXYOutliers) = [];

		nGrubbsBeamIntercepts          = size (GrubbsBeamIntercepts, 2);
		GrubbsBeamInterceptMean_stdDev = GrubbsBeamInterceptStdDev / sqrt (nGrubbsBeamIntercepts); % x,y mean std dev

%{
		% now we need the drift step...
		virtualSource_bpp = [ GrubbsBeamInterceptMean(1); GrubbsBeamInterceptMean(2); 0.0 ];
		gyroFrequency = (q * B2n * nT2T) / e_mass; % (SI) (|q| is positive here.)
		gyroPeriod    = (twoPi / gyroFrequency);    % (SI) The result is usually on the order of a few ms

		% vE = v in direction of E; T = gyroPeriod
		% ( vE = d/T ) = ExB/|B|^2 ~> d / T * |B|^2 = ExB --- Pacshmann, 1998, 2001, EDI for Cluster
		% Cross from the left with B: B x [] = BxExB
		% where BxExB = E(B dot B) - B(E dot B)
		% The second term is zero because we are assuming E is perpendicular to B.
		% B x [ d/T * |B|^2 = E * |B|^2 ~> E = B x d/T

		% the virtual source S* is the negative of the real drift step; S* is an imaginary point
		% This should be E = B x v, but B, v are swapped here because we need the real drift step (drift velocity),
		% not the virtual source, S*. See relevant publications on Cluster drift step
		% and 'EDI_beams_and_virtual_source_demo_0101.m'.
		E_bpp = cross (virtualSource_bpp, B_bpp) * (1.0e-9 / gyroPeriod); % B_bpp is in nT, and all these calcs are in SI
		driftStep     = -(DMPA2BPP' * virtualSource_bpp);
		dUncertainty  = [ZConfidenceBounds*GrubbsBeamInterceptMean_stdDev; 0.0];
		% Possible future? dUncertainty  = (DMPA2BPP' * [ZConfidenceBounds*GrubbsBeamInterceptMean_stdDev; 0.0])
		driftVelocity = driftStep / gyroPeriod * 1.0e-3; % m/s ~> km/s, per MMS unit standards
		drift_E       = (DMPA2BPP' * E_bpp) * 1.0e3; % convert V/m -> mV/m
%}
		dsQualityWeight = interceptWeightsSum / nGrubbsBeamIntercepts;
		if dsQualityWeight > sinx_wt_Q_xovr(2)
			dsQuality = 3;
		else
			if dsQualityWeight > sinx_wt_Q_xovr(1)
				dsQuality = 2;
			else
				dsQuality = 1;
			end
		end

	end % nansum (interceptWeights) > 0.0
end %  nTargetBeams > 1
