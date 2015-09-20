% EDI_beams_and_virtual_source_demo_0101.m
%
% Purpose
% Demonstrate how beams are fired from either of two MMS Electron Drift
% Instrument (EDI) gun-dectector units (GDU) and detected by the other.
% Show how the intersection of the beams relates to the electric field 
% drift step. Show how the virtual observatory relates to the real
% observatory, and how the intersection of fired beams at the virtual
% source S* is the negative drift step vector in the B-field Perpendicular
% Plane (BPP).
%
% First one gun fires a sweeping beam until it hits the other GDU's detector.
% Then the other gun fires a sweeping beam umtil it hits the first GDU's
% detector. The plot is originally zoomed out to show actual beam paths based
% on real plasma values recorded by observatories. After two beams are
% detected, the plot zooms in to show the real and virtual observatories in
% scaled to show the real and virtual observatories and S*.
%
% Clicking on the plot advances the demo. It eventually finds several sets of
% firing vector combinations from both GDUs that result in a virtual beam
% intersection at S*, an estimate of the drift step.
%
% Calling Sequence
%   None
%
% Parameters
%   None
%
% MATLAB release(s) MATLAB 8.3.0.532 (R2014a)
% Required Products None
%
% History:
%   2015-07-15      V0100: Origin
%

clc             % clear the command window
clf             % clear the plot window; don't use this unless you have plots -,--,:,-.
clear classes
clear variables % clear all variables
format compact
format short g  % +, bank, hex, long, rat, short, short g, short eng

myLibAppConstants
myLibScienceConstants

% Original B, E values based on Cluster data, C3_CP_EFW_L2_E__20010608_053000_20010608_054000
Bz = 307.603e-9    % magnetic field strength (in the z-direction), nT > T, org: 307.603e-9
Ey = 7.87177e-3    % electric field strength (in the GDU1_beamY-direction), mV/m > V/m, org: 0.787177e-3

GDU1y = -1.6;
GDU2y = +1.6;

gyroPeriod = (twoPi * mass_e) / (q * Bz)
% Introduction to Plasma Physics and Controlled Fusion Plasma Physics 2E. Chen.pdf
% [2-13] to [2-16]
% If E lies in the B-perp plane, E + v x B = 0
% ExB = B x (v x B) = vb^2 - B(v.B) ... note sign change on RHS from B x, rather then x B.
% Assume v.B = 0 ~> ExB = vb^2 ~> v_perp = (ExB)/b^2
driftVelocity = cross ([ 0.0; Ey; 0.0 ], [ 0.0; 0.0; Bz ]) / Bz^2; % vector
% driftStep (m) = v_perp (m/s) * gyroPeriod (s)
driftStep = driftVelocity * gyroPeriod % vector
% Note also the sign of the charge in Chen [2-24].

t          =  (0: 0.00001: 1.001) * gyroPeriod;  % time range, finer detail gives better results
% Cluster s/c radius = 2.9 m; GDUs increase that to 3.2 m, for a radius of 1.6 m.
scRadius   = 1.6;
vd_x       = Ey/Bz;            % drift velocity 2.559068e3 m/s; specifically in x for this case
ve         = v_1keV_electron;
w          = -q * Bz / mass_e; % gyrofrequency (note, can be negative for electron)
zeroTol    = 0.05;             % guess a reasonable threshold for intersection determination

GDU_planeInICS = zeros (3, 361, 'double');
for theta = 0:1:360
	GDU_planeInICS (:, theta+1) = scRadius * [ cosd(theta); sind(theta); 0.0 ];
end

disp 'For F = ma = q (E + vxB):'
disp 'If B is out of plane (+z), a +POSitively-charged particle will be seen to rotate'
disp 'clockwise (RHR); a NEGatively charged particle, counterclockwise (LHR).'
disp 'Assigning an initial velocity in (+y) results in vxB pointing in (+x) for +q'
disp 'and (-x) for -q.'
disp ' '
disp 'This motion is not to be confused with charged particle DRIFT, where'
disp 'vd = (ExB) / B^2. Particle trajectories are cycloids in the E, vd plane.'
disp ' '
disp 'Continuing with this example, with B out of plane (+z), and adding E in (+y),'
disp 'particle drift will be in (+x) for both POSitively- and NEGatively-charged'
disp 'particles, in the x-y plane. Here ExB is always evaluated according to the RHR,'
disp 'as q does not enter the picture.'
disp ' '
disp 'For B=(0,0,+z), E=(0,+y,0), drift in (+x,0,0), this program calculates'
disp 'the path of an electron using F = q (E + vxB). The particle moves as'
disp 'though it were a spot on a the rim of a wheel, rolling in x at speed v.'
disp 'If E=(0,0,0), the motion is purely circular (gyro rotation),'
disp 'but the E-field (0,+y,0) causes the electron to trace a cycloidal path'
disp 'in the x-y plane. The time for the electron to return to y=0 is known'
disp 'as the gyro period, and is the same whether the E-field is zero or not.'
disp 'When the E-field is zero, the electron returns to its starting point,'
disp '(0,0,0), after each complete 2 pi revolution. This demo begins with the'
disp 'electron fired at (+x,0,0), and returning to y=0 after each complete'
disp 'revolution, but at changing values of x. This makes it clear that the'
disp 'gyro period includes the time between intersections of the electron path,'
disp 'subsequently displayed in red, PLUS twice the time it takes for the'
disp 'electron to move from its firing position to the point of intersection.'
disp 'This holds true for multirunners, too; the gyro period includes the time'
disp 'between intersections PLUS twice the time it takes for the electron to'
disp 'move from its firing position to the point of intersection, both of which'
disp 'increase with the order of multirunner.'

hGDU1_E_vxB_beam_plot = 1;
figure (hGDU1_E_vxB_beam_plot);
figLocSize = [ 400+DisplayOffset(1)  100+DisplayOffset(2)  800  600 ]; % left, bottom, width, height
set (hGDU1_E_vxB_beam_plot, 'Position', [ figLocSize(1) figLocSize(2) figLocSize(3) figLocSize(4) ])
set (hGDU1_E_vxB_beam_plot, 'WindowStyle', 'normal')
set (hGDU1_E_vxB_beam_plot, 'DockControls', 'off')
set (gcf, 'name', 'Lorentz electron beam tracks and runner intersections in E and B fields', 'NumberTitle', 'off');

axisMax = 2000.0;
axis ( [ -axisMax axisMax -axisMax axisMax ] );
axis equal
axis manual
grid on
zoom on
set (gca, 'nextplot', 'replacechildren');
set (gca, 'Fontname', 'Times')

hICS_plotElements (1) = plot3 (GDU_planeInICS (1,:), GDU_planeInICS (2,:), GDU_planeInICS (3,:),...
	'LineStyle', '-', 'LineWidth', 1.0, 'Color', myDarkGreen);

hICS_plotElements (2) = plot3 (2.0*GDU_planeInICS (1,:), 2.0*GDU_planeInICS (2,:), 2.0*GDU_planeInICS (3,:),...
	'LineStyle', '--', 'LineWidth', 1.0, 'Color', myDarkBlue);

strAngles = 'EDI intersection angles: ';
strTitle = { ...
	[ 'Click to step through drift step demo' ];
	[ 'For B=(+z), E=(+y), drift in (+x)' ];
	[strAngles] };
title (strTitle, 'Fontname', 'Times', 'FontSize', 14, 'FontWeight', 'bold');
xlabel ('GDU1 beamX (m)')
ylabel ('GDU1 beamY (m)')
TightFig;
hold on

GDU1_lastAngle = 0.0; % initialize so that loop works first time through

% GDU1 is @ (0,-1.6), so the firing angles start @ 180°, and sweep CCW away from the obs
for GDU1_firingAngle = 180.0: 360.0
	vx = ve * cosd (GDU1_firingAngle); % initial vx for this firing angle
	vy = ve * sind (GDU1_firingAngle); % initial vy

	% Parametric equations of motion (Griffiths, Intro to Electrodynamics, 3E, (5.6)
	% Messeder, 2015, Parametric equations of charged particle motionin E and B fields v3.pdf
	% These equations are solved with variable firing angles and x,y velocities in mind.
	% Solve x(t=0)  =        C1 cos wt +  C2 sin wt + vd_x t + C3 ~> 0 = C1 + C3 ~> C3 = -C1
	% Solve x'(t=0) = vx = -wC1 sin wt + wC2 cos wt + vd_x ~> vx = wC2 + vd_x ~> C2 = (vx-vd_x)/w
	C2 = -vd_x / w;
	% Solve y(t=0)  =   C2 cos wt -  C1 sin wt + C4 ~> 0 = C2 + C4 ~> C4 = -C2
	C4 = -C2;
	% Solve y’(t=0) = -wC1 cos wt - wC2 sin wt - wC3 ~> 0 = -wC1 -wC3 ~?> C1=C3=0
	C1 = -vy/w; C3 = -C1;
	C2 = C2 + vx/w; C4 = -C2;

	% The sign of the charge determines the sense of rotation of the particle motion:
	% For an ion, q > 0, w > 0, and the rotation is right-handed;
	% for an electron, q < 0, w < 0, and the rotation is left-handed.
	GDU1_beamX = C1 * cos (w*t) + C2 * sin (w*t) + vd_x*t + C3;
	GDU1_beamY = C2 * cos (w*t) - C1 * sin (w*t) + C4 + GDU1y;

	hGDU1_E_vxB = plot (GDU1_beamX, GDU1_beamY, 'LineStyle', '-', 'Marker', '.', 'MarkerSize', 2, 'Color', myDarkBlue);

	hGDU1_firingDir = ... % GDU firing direction
		plot ([ 0.0 0.5*cosd(GDU1_firingAngle) ], [ 0.0 0.5*sind(GDU1_firingAngle) ] + GDU1y,...
			'LineStyle', '-', 'LineWidth', 3.0, 'Marker', '.', 'MarkerSize', 1, 'Color', myDarkGreen);
	if GDU1_firingAngle == 180.0
		dummy = waitforbuttonpress;
	end

	pause (0.005)
	iOffset = 50;
	% ix = find (abs(GDU1_beamX(iOffset:end)) < zeroTol); % these are for finding hits on the same GDU
	% iy = find (abs(GDU1_beamY(iOffset:end) + 1.6) < zeroTol);
	ix = find (abs(GDU1_beamX(iOffset:end)) < zeroTol); % Find when detected by GDU1
	iy = find (abs(GDU1_beamY(iOffset:end) - GDU2y) < zeroTol);             % GDU1_firingAngles: GDU1 =  129°, 309.5°, GDU2 = 51°, 230.5°

	% [xMin, ix] = min (abs(GDU1_beamX(iOffset:end))) % there are too many very small values
	% [yMin, iy] = min (abs(GDU1_beamY(iOffset:end))) % and xMin and yMin don't have to occur at the same point
	iIntersect = intersect (ix, iy);

	if ~isempty (iIntersect) & (min (iIntersect) > 100)
		if (GDU1_firingAngle - GDU1_lastAngle) > 0.5
			iIntersect = iIntersect(1) + iOffset - 1; % the filter starts at iOffset, so GDU1_beamX(iOffset:end) starts @ iOffset, not 1
			hGDU1_IntersectPath = plot (GDU1_beamX (1: iIntersect), GDU1_beamY (1: iIntersect),...
				'LineStyle', '-', 'LineWidth', 2.0, 'Marker', '.', 'MarkerSize', 1, 'Color', myDarkRed);
			strAngles = [ strAngles, num2str( mod (GDU1_firingAngle, 360.0), 3), '° '];
			strTitle = { ...
				[ 'Click to step through drift step demo' ];
				[ 'For B=(+z), E=(+y), drift in (+x)' ];
				[strAngles] };
			title (strTitle, 'FontSize', 14, 'FontWeight', 'bold', 'Color', myDarkRed);
			disp (strAngles)
			%	[ gyroPeriod, t(iIntersect(1))/t(end)*gyroPeriod, gyroPeriod-t(iIntersect(1))/t(end)*gyroPeriod, GDU1_beamX(iIntersect(1)), GDU1_beamY(iIntersect(1)), norm([ GDU1_beamX(iIntersect(1)) ; GDU1_beamY(iIntersect(1)) ]) ]
			% keyboard % dbquit
			dummy = waitforbuttonpress;

			% PlotGDU2
			GDU2_lastAngle = 0.0;

			% GDU2 is @ (0,+1.6), so the firing angles start @ 0°, and sweep CCW away from the obs
			for GDU2_firingAngle = 0.0: 180.0 %nAngles
				vx = ve * cosd (GDU2_firingAngle);
				vy = ve * sind (GDU2_firingAngle);

				% Parametric equations of motion (Griffiths, Intro to Electrodynamics, 3E, (5.6):
				C1 = -vy/w; C3 = -C1;
				C2 = (vx-vd_x)/w; C4 = -C2;
				GDU2_beamX = C1 * cos (w*t) + C2 * sin (w*t) + vd_x*t + C3;
				GDU2_beamY = C2 * cos (w*t) - C1 * sin (w*t) + C4 + GDU2y;

				hGDU2_E_vxB = plot (GDU2_beamX, GDU2_beamY, 'LineStyle', '-', 'Marker', '.', 'MarkerSize', 2, 'Color', myDarkBlue);

				hGDU2_firingDir = ... % GDU firing direction
				plot ([ 0.0 0.5*cosd(GDU2_firingAngle) ], [ 0.0 0.5*sind(GDU2_firingAngle) ] + GDU2y,...
					'LineStyle', '-', 'LineWidth', 3.0, 'Marker', '.', 'MarkerSize', 1, 'Color', myDarkGreen);

				pause (0.005)
				iOffset = 50;

				ix = find (abs (GDU2_beamX (iOffset:end)) < zeroTol); % Find when detected by GDU1
				iy = find (abs (GDU2_beamY (iOffset:end) - GDU1y) < zeroTol);

				iIntersect = intersect (ix, iy);

				if ~isempty (iIntersect) & (min (iIntersect) > 100)
					ToF = iIntersect (1) * 0.00001 * gyroPeriod; % This depends on step size of t
					disp ( sprintf ('gyroPeriod, ToF: %g, %g s', gyroPeriod, ToF) )

					if (GDU2_firingAngle - GDU2_lastAngle) > 0.5
						iIntersect = iIntersect(1) + iOffset - 1; % the filter starts at iOffset, so GDU2_beamX(iOffset:end) starts @ iOffset, not 1
						hGDU2_IntersectPath = plot (GDU2_beamX (1: iIntersect), GDU2_beamY (1: iIntersect),...
							'LineStyle', '-', 'LineWidth', 2.0, 'Marker', '.', 'MarkerSize', 1, 'Color', myDarkRed);

						strAngles = [ strAngles, num2str( mod (GDU2_firingAngle, 360.0), 3), '° '];
						strTitle = { ...
							[ 'Click to step through drift step demo' ];
							[ 'For B=(+z), E=(+y), drift in (+x)' ];
							[strAngles] };
						title (strTitle, 'FontSize', 14, 'FontWeight', 'bold', 'Color', myDarkRed);
						disp (strAngles)

						iOffset = 50;

						ix = find (abs (GDU1_beamX (iOffset:end) - driftStep(1)) < zeroTol);
						iTargetx = ix + iOffset -1;
						iTargetx (iTargetx < 90000) = [];
						iTargetx (iTargetx > 100000) = [];
						iy = find (abs (GDU1_beamY (iOffset:end)) < zeroTol);
						iTargety = iy + iOffset -1;
						iTargety (iTargety < 90000) = [];
						iTargety (iTargety > 100000) = [];

						ix = find (abs (GDU2_beamX (iOffset:end) - driftStep(1)) < zeroTol);
						iTargetx = ix + iOffset -1;
						iTargetx (iTargetx < 90000) = [];
						iTargetx (iTargetx > 100000) = [];
						iy = find (abs (GDU2_beamY (iOffset:end)) < zeroTol);
						iTargety = iy + iOffset -1;
						iTargety (iTargety < 90000) = [];
						iTargety (iTargety > 100000) = [];
						% keyboard % dbquit % uncomment to pause and print|save plot
						dummy = waitforbuttonpress;

						xlim ([ -8.0 8.0 ])
						ylim ([ -8.0 8.0 ])

						x = -4.0:4.0; % virtualSourceBeam x-values
						% y = mx + b
						m1 = tand (GDU1_firingAngle);
						px = 0.0;
						py = -3.2;
						b1 = py - m1 * px;
						line (x, m1 * x + b1)

						m2 = tand (GDU2_firingAngle);
						px = 0.0;
						py = 3.2;
						b2 = py - m2 * px;
						line (x, m2 * x + b2)

						% Find S*: y1 = y2 ~> m1 x + b1 = m2 x + b2. x = (b2 - b1) / (m1 - m2). y = mx + b.
						x12 = (b2 - b1) / (m1 - m2);
						y12 = m1 * x12 +b1;
						disp 'drift step x,y        S* x,y'
						disp (sprintf ('%g    ', driftStep(1), 0.0, x12, y12))
						dummy = waitforbuttonpress;
						axis ( [ -axisMax axisMax -axisMax axisMax ] );

						delete (hGDU2_IntersectPath);
						GDU2_lastAngle = GDU2_firingAngle;
					end
				end
				delete (hGDU2_E_vxB);      % delete the electron track of F = ma = q (E + v GDU2_beamX B)
				delete (hGDU2_firingDir);  % delete the firing direction indicator
			end

			delete (hGDU1_IntersectPath);
			GDU1_lastAngle = GDU1_firingAngle;
		end
	end
	delete (hGDU1_E_vxB);      % delete the electron track of F = ma = q (E + v GDU1_beamX B)
	delete (hGDU1_firingDir);  % delete the firing direction indicator
end

% deleted earlier in loop; replot for final display
hGDU1_E_vxB = plot (GDU1_beamX, GDU1_beamY, 'LineStyle', '-', 'Marker', '.', 'MarkerSize', 2, 'Color', myDarkBlue);
hGDU1_firingDir = plot ([ 0.0 0.5*cos(GDU1_firingAngle) ], [ 0.0 0.5*sin(GDU1_firingAngle) ] + GDU1y,...
	'LineStyle', '-', 'LineWidth', 3.0, 'Marker', '.', 'MarkerSize', 4, 'Color', myDarkGreen);
