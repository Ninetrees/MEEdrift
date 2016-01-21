% EDI_beams_and_virtual_source_demo_0200.m
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
% detected, the plot zooms in to show the real and virtual observatories
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
% 2015-10-19 ~ v02.00.00:
% ~ Implement motion in direction of drift
% ~ Change to MMS-specific geometry and EDI parameters
%
% 2015-07-15 ~ v01.00.00: Origin
%

clc             % clear the command window
clf             % clear the plot window; don't use this unless you have plots -,--,:,-.
clear classes
clear variables % clear all variables
format compact
format short g  % +, bank, hex, long, rat, short, short g, short eng

myLibAppConstants
myLibScienceConstants

mmsRPM        = 3.0; % nominal, 1 spin ~20 s. 0.05 Hz
mmsSpinPeriod = 20.0; % seconds, nominal
MMS_apogee    = 12.0 * Re;
MMS_perigee   = 1.20 * Re;
% At apogee, we trade KE for PE, so v_apogee < v_perigee
MMS_speed_apogee  = sqrt ( (2.0 * GM * MMS_perigee) / (MMS_apogee * (MMS_apogee + MMS_perigee)) ); % ~ 973  m/s
MMS_speed_perigee = sqrt ( (2.0 * GM * MMS_apogee) / (MMS_perigee * (MMS_apogee + MMS_perigee)) ); % ~ 9736 m/s
% Distance spacecraft moves in gyroPeriod of 0.00011614 s
% apogee: ~= 0.11 m, perigee ~= 1.13 m
EDI1gunLoc = [ -1.45598,  1.11837, 0.0 ]; % EDI2 gun atan2(-1.11837, 1.45598)*180/pi ~> -37.52865°
EDI1detLoc = [ -1.35885,  1.03395, 0.0 ]; % EDI2 det atan2(-1.03395, 1.35885)*180/pi ~> -37.26753°
EDI2gunLoc = [  1.45598, -1.11837, 0.0 ]; % EDI1detLoc:EDI1gunLoc angle = atan2(1.11837-1.03395, -1.45598+1.35885)*180/pi ~> -40.995°
EDI2detLoc = [  1.35885, -1.03395, 0.0 ]; % norm(EDI1gunLoc-EDI1detLoc,2) = 0.128689
mmsEDI_VirtualRadius = norm (EDI1gunLoc-EDI2detLoc, 2);
mmsEDI_Radius = mmsEDI_VirtualRadius / 2.0;

% Original B, E values based on Cluster data, C3_CP_EFW_L2_E__20010608_053000_20010608_054000
Bz = 307.603e-9    % magnetic field strength (in the z-direction), nT > T, org: 307.603e-9
Ey = 7.87177e-3    % electric field strength (in the GDU1_beamY-direction), mV/m > V/m, org: 0.787177e-3

GDU1y = -mmsEDI_Radius; % GDU 1 (0, -r)
GDU2y = +mmsEDI_Radius; % GDU 2 (0, +r)

gyroPeriod = (twoPi * mass_e) / (q * Bz) % Bz = 307.603e-9 ~> 0.00011614 s
% Introduction to Plasma Physics and Controlled Fusion Plasma Physics 2E. Chen.pdf
% [2-11] to [2-16]
% If E lies in the B-perp plane, E + v x B = 0
% ExB = B x (v x B) = vb^2 - B(v.B) ... note sign change on RHS from B x, rather than x B.
% Assume v.B = 0 ~> ExB = vb^2 ~> v_perp = (ExB)/b^2
driftVelocity = cross ([ 0.0; Ey; 0.0 ], [ 0.0; 0.0; Bz ]) / (Bz*Bz); % vector, Chen [2-15]
% driftStep (m) = v_perp (m/s) * gyroPeriod (s)
driftStep = driftVelocity * gyroPeriod % vector
% Note also the sign of the charge in Chen [2-11].

t          =  (0: 0.00001: 1.001) * gyroPeriod;  % time range, finer detail gives better results
% Cluster s/c radius = 2.9 m; GDUs increase that to 3.2 m, for a radius of 1.6 m.
% scRadius   = 1.6;
vd_x       = Ey/Bz;            % drift velocity 2.559068e3 m/s; specifically in x for this case
ve         = v_500eV_electron;
w          = -q * Bz / mass_e; % gyrofrequency (note, can be negative for electron)
zeroTol    = 0.05;             % guess a reasonable threshold for intersection determination

instrPlaneBCS = zeros (3, 361, 'double');
for theta = 0:1:360
	instrPlaneBCS (:, theta+1) = mmsEDI_Radius * [ cosd(theta); sind(theta); 0.0 ];
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
set (hGDU1_E_vxB_beam_plot, 'position', [ figLocSize(1) figLocSize(2) figLocSize(3) figLocSize(4) ])
set (hGDU1_E_vxB_beam_plot, 'WindowStyle', 'normal')
set (hGDU1_E_vxB_beam_plot, 'DockControls', 'off')
set (gcf, 'name', 'Lorentz electron beam tracks and runner intersections in E and B fields', 'NumberTitle', 'off');

hICS_plotElements (1) = plot3 (instrPlaneBCS (1,:), instrPlaneBCS (2,:), instrPlaneBCS (3,:),...
	'LineStyle', '-', 'LineWidth', 1.0, 'Color', myDarkGreen);
hold on
hICS_plotElements (2) = plot3 (2.0*instrPlaneBCS (1,:), 2.0*instrPlaneBCS (2,:), 2.0*instrPlaneBCS (3,:),...
	'LineStyle', '--', 'LineWidth', 1.0, 'Color', myDarkGreen);

view ( [ 0.0 90.0 ] )
axisMax = 2000.0;
axis ( [ -axisMax axisMax -axisMax axisMax -0.1 0.1] );
axis equal
axis manual
grid on
zoom on
set (gca, 'nextplot', 'replacechildren');
set (gca, 'Fontname', 'Times')
hold on

% Move the platform
platformDisplacement_x = MMS_speed_perigee * gyroPeriod ;
% Platform rotation is neglible during gyroPeriod, being gyroPeriod / mmsSpinPeriod * twoPi
% gyroPeriodRotation = gyroPeriod / mmsSpinPeriod * 360.0
hICS_plotElements (3) = plot3 ( ...
	instrPlaneBCS (1,:) +  platformDisplacement_x, ...
	instrPlaneBCS (2,:), ...
	instrPlaneBCS (3,:), ...
	'LineStyle', '-', 'LineWidth', 1.0, 'Color', myGold);

hICS_plotElements (4) = plot3 ( ...
	2.0*instrPlaneBCS (1,:) + platformDisplacement_x, ...
	2.0*instrPlaneBCS (2,:), ...
	2.0*instrPlaneBCS (3,:), ...
	'LineStyle', '--', 'LineWidth', 1.0, 'Color', myGold);

strAngles = 'EDI intersection angles: ';
strTitle = { ...
	[ 'Click to step through drift step demo' ];
	[ 'For B=(+z), E=(+y), drift in (+x)' ];
	[strAngles] };
title (strTitle, 'Fontname', 'Times', 'FontSize', 14, 'FontWeight', 'bold');
xlabel ('GDU1 beamX (m)')
ylabel ('GDU1 beamY (m)')
TightFig;

GDU1_lastAngle = 0.0; % initialize so that loop works first time through

% GDU1 is @ (0,-1.6), so the firing angles start @ 180°, and sweep CCW away from the obs
for GDU1_firingAngle = 170.0: 370.0
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
	ix = find (abs(GDU1_beamX(iOffset:end) - platformDisplacement_x) < zeroTol); % Find when detected by GDU1
	iy = find (abs(GDU1_beamY(iOffset:end) - GDU2y)                  < zeroTol);

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
			for GDU2_firingAngle = -10.0: 190.0 %nAngles
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

				ix = find (abs (GDU2_beamX (iOffset:end) - platformDisplacement_x) < zeroTol); % Find when detected by GDU2
				iy = find (abs (GDU2_beamY (iOffset:end) - GDU1y)                  < zeroTol);

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

						x = -4.0: 0.01: 4.0; % virtualSourceBeam x-values
						% y = mx + b
						m1 = tand (GDU1_firingAngle);
						px = platformDisplacement_x;
						py = -mmsEDI_VirtualRadius;
						b1 = py - m1 * px;
						line (x, m1 * x + b1, 'Color', myOrange)

						m2 = tand (GDU2_firingAngle);
						px = platformDisplacement_x;
						py = mmsEDI_VirtualRadius;
						b2 = py - m2 * px;
						line (x, m2 * x + b2, 'Color', myOrange)

						% Find S*: y1 = y2 ~> m1 x + b1 = m2 x + b2. x = (b2 - b1) / (m1 - m2). y = mx + b.
						x12 = (b2 - b1) / (m1 - m2);
						y12 = m1 * x12 +b1;
						% When we double the diamater of the real obs to create the virtual obs,
						% we must account for twice the platform displacement, because the
						% geometry is scaled up by 2X.
						disp 'drift step x,y        S* x,y              ||S*||'
						disp (sprintf ('%g    ', driftStep(1), 0.0, ...
							2.0 * platformDisplacement_x - x12, y12, ...
							norm ([(2.0 * platformDisplacement_x - x12), y12], 2) ))
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
