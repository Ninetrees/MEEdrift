% MEEdrift_FFT_MMS_EDP_data

% It is difficult to identify signal frequency components by looking at the original
% signal. A common use of Fourier transforms (here, fast Fourier transform (FFT))
% is to convert to the frequency domain to find the frequency components of a signal
% buried in a noisy time domain signal.

% Cluster EFW is just that sort of data, and, due to the rotation of the spacecraft,
% the data is susceptible to aliasing with low-frequency components.

% The main reason for so many frequencies is because of the noise.
% Ather reason is finite signal length. Larger nSamples will produce
% much better approximations of the average.

%  fft: time domain -> frequency domain
% ifft: frequency domain -> time domain

% Plot amplitude spectrum.
fFFT_plot = figure ('Position', [ 0.0*ScreenWidth 0.5*ScreenHeight 0.7*ScreenWidth 0.375*ScreenHeight ]);
set (fFFT_plot, 'WindowStyle', 'normal')
set (fFFT_plot, 'DockControls', 'off')
set (fFFT_plot, 'units', 'pixel'); % for screen
set (0, 'CurrentFigure', fFFT_plot) % hFFT_plotElements
clf
set (gcf, 'name', 'EFW FFT of largest 2^n samples', 'NumberTitle', 'off');


%parameters for figure and panel size, pixels
canvasWidth  = 0.7*ScreenWidth;
canvasHeight = 0.375*ScreenHeight;
nPlotCols    = 1;
nPlotRows    = 2;
leftMargin   = 60; % ??ide plot
rightMargin  = 20;
topMargin    = 50; % could be calculated?
bottomMargin = 30;
horizPlotSep =  0;
vertPlotSep  = 20;

subplotPositions = CanvasSubplotAxesPositions (canvasWidth, canvasHeight, nPlotCols, nPlotRows, leftMargin, rightMargin, topMargin, bottomMargin, horizPlotSep, vertPlotSep);

% expect the data as 1xn samples
nRecords = length (EFW_L2_E2D);

% we'll analyze each dimension. Cluster has two: x and y.
freqBins       = 2.0 ^ round (log2 (nRecords)); % Choose some power of 2 that is smaller than length (data)
samplingFreq   = EDP_sampleFreq;         % Sampling frequency, Hz
sampleInterval = 1.0 / samplingFreq;     % Sample time, s, 25 Hz -> 0.04 s

% +++++++++++ EFWx
fullFFT   = fft (EFW_L2_E2D (1: freqBins), freqBins) / freqBins; % real and complex values; scale values arbitrarily
% FFT is symmetric, throw away 2nd half
freqDist  = fullFFT (1: freqBins/2);
freqDist  = abs (freqDist); % the FFT returns a complex number
freqRange = (0: freqBins/2 - 1) * (samplingFreq / freqBins);
% kill the useless FFT ending values
freqDist (1:4)       = 0.0;
freqDist (end-3:end) = 0.0;

fontsize = 8;
FFTx_axis = axes ('position', subplotPositions {1, 2}, 'XGrid', 'off', 'XMinorGrid', 'off', 'FontSize', fontsize, 'Box', 'on', 'Layer', 'top');
plot (freqRange, freqDist)
% hold on
xlim ([ 0.0 14.0 ]);
% ylim ([ 0.0 1.0 ]);
set (gca, 'Xtick', 0.0: 0.5: 14.0)
title ('Cluster EFW FFT')
set (FFTx_axis, 'xticklabel', [])
ylabel ('EFW_x FFT')

% +++++++++++ EFWy
freqDist  = fft (EFW_L2_E2D (2: freqBins), freqBins) / freqBins; % real and complex values; scale values arbitrarily
% FFT is symmetric, throw away 2nd half
freqDist  = freqDist (1: freqBins/2);
freqDist  = abs (freqDist); % the FFT returns a complex number
freqDist (1)   = 0.0;
freqDist (end) = 0.0;

FFTy_axis = axes ('position', subplotPositions {1, 1}, 'XGrid', 'off', 'XMinorGrid', 'off', 'FontSize', fontsize, 'Box', 'on', 'Layer', 'top');
plot (freqRange, freqDist, 'Color', myDarkGreen)
xlim ([ 0 14 ]);
% ylim ([ 0.0 1.0 ]);
set (gca, 'Xtick', 0.0: 0.5: 14.0)
xlabel ('Frequency (Hz)')
ylabel ('EFW_y FFT')
figure (fFFT_plot);
FFTplotted = true;

TightFig;

%{
iLowFreq = find (freqDist > 0.02);
iHiFreq  = iLowFreq;
HzPerBin = freqRange (end) / size (freqRange, 2);
% iLowFreq (iLowFreq > (100.0 / HzPerBin)) = []; % Toss the hi; keep the low freq component
iHiFreq (iHiFreq < (100.0 / HzPerBin)) = [];     % Toss the lo; keep the hi  freq component
% replace the low freq bins with average values, effectively killing the low freq
% freqDist (iLowFreq) = (...
% 	mean (freqDist ((iLowFreq (1) - 20): (iLowFreq (end) - 1))) +...
% 	mean (freqDist ((iLowFreq (end) + 1): (iLowFreq (end) + 20)))...
% 	) / 2.0;
% OR, create a new dist with just the desired freqs
freqDist2 = zeros (1, length (freqDist));
% create a frequency domain matrix containing only the hi freqs
freqDist2 (iHiFreq) = freqDist (iHiFreq);
freqDist2r = [ freqDist2 fliplr(freqDist2)];

figure
plot (freqRange, freqDist2)
xlim ([ 0 500]); % We want to see just the frequencies we started with
title ('Real Amplitude Spectrum of dirtySignalsSum(t) minus 2 Hz frequency')
xlabel ('Frequency (Hz)')
ylabel ('|freqDist(freqRange)|')

timeDomainFiltered = ifft (freqDist2, length (freqDist2r));
timeDomainFiltered = real (timeDomainFiltered);
figure
plot (samplingFreq * t(1: 500), clean120Hz(1: 500))
hold on
% plot (2 * samplingFreq * t(1: 250), 10000.0 * timeDomainFiltered (1: 250))
plot (samplingFreq * t(1: 500), 10000.0 * timeDomainFiltered (1: 500))
grid on
ylim ( [ -2.0 2.0 ]);
title ('Signal After Filter Removes 2Hz Component')
xlabel ([ 'time (' num2str(sampleInterval) ' ms per channel)' ])
%}

%{
% Sample data to compare w my Mathcad tutorial
m= 7;
N = 2^m;
i = 0: N-1;
tmax = N/2;
ti = i * tmax / N;
fs = N / tmax;
D = 2.0 * sin (0.1 * (2*pi*ti)) + 1.0 * sin (0.25* (2*pi*ti)) + 1.0 * (rand(1) - 0.5);

fullFFT   = fft (D (1: N), N); % real and complex values
freqDist  = fullFFT (1: N/2);
freqDist  = abs (freqDist); % the FFT returns a complex number
freqRange = (0: N/2 - 1) * (fs / N);

plot (freqRange, freqDist, 'r-o')
% comment out EFWy plot lines
% after running, close all, nf = figure, plot...
%}