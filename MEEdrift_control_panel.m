function varargout = MEEdrift_control_panel(varargin)
% MEEDRIFT_CONTROL_PANEL MATLAB code for MEEdrift_control_panel.fig
%      MEEDRIFT_CONTROL_PANEL, by itself, creates a new MEEDRIFT_CONTROL_PANEL or raises the existing
%      singleton*.
%
%      H = MEEDRIFT_CONTROL_PANEL returns the handle to a new MEEDRIFT_CONTROL_PANEL or the handle to
%      the existing singleton*.
%
%      MEEDRIFT_CONTROL_PANEL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MEEDRIFT_CONTROL_PANEL.M with the given input arguments.
%
%      MEEDRIFT_CONTROL_PANEL('Property','Value',...) creates a new MEEDRIFT_CONTROL_PANEL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MEEdrift_control_panel_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MEEdrift_control_panel_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MEEdrift_control_panel

% Last Modified by GUIDE v2.5 14-Aug-2015 09:35:50

% Begin initialization code - DO NOT EDIT
	gui_Singleton = 1;
	gui_State = struct('gui_Name',       mfilename, ...
	                   'gui_Singleton',  gui_Singleton, ...
	                   'gui_OpeningFcn', @MEEdrift_control_panel_OpeningFcn, ...
	                   'gui_OutputFcn',  @MEEdrift_control_panel_OutputFcn, ...
	                   'gui_LayoutFcn',  [] , ...
	                   'gui_Callback',   []);
	if nargin && ischar(varargin{1})
	    gui_State.gui_Callback = str2func(varargin{1});
	end

	if nargout
	    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
	else
	    gui_mainfcn(gui_State, varargin{:});
	end
% End initialization code - DO NOT EDIT


% --- Executes just before MEEdrift_control_panel is made visible.
function MEEdrift_control_panel_OpeningFcn(hObject, eventdata, handles, varargin)
	% This function has no output args, see OutputFcn.
	% varargin   command line arguments to MEEdrift_control_panel (see VARARGIN)

	% Choose default command line output for MEEdrift_control_panel
	handles.output = hObject;

	% Update handles structure
	guidata (hObject, handles);

	% !!! When editing externally, be SURE that the file is not open in MATLAB. !!!
	% If it is, MATLAB GUIDE will preferentially use THAT copy, and changes here will be lost. !!!
	global fControlPanel;
	global dotVersion;
	global beamsWindow;
	global beamWindowSecs;
	global PlotBeamConvergence;
	global PlotIntersectDots;
	global Reentrant;
	global SmoothData;
	global SmoothingSpan;
	global UseSmoothedData;
	global Use_OCS_plot;

	fControlPanel = hObject;
	set (handles.uic_txtTitle, 'String', [ 'MEEdrift ' dotVersion ]);
	set (handles.uic_eBeamsWindow, 'String', num2str (beamsWindow));
	set (handles.uic_eBeamWindowSecs, 'String', num2str (beamWindowSecs));
	set (handles.uic_cbPlotBeamConvergence, 'Value', PlotBeamConvergence);
	set (handles.uic_cbPlotIntersectDots, 'Value', PlotIntersectDots);
	set (handles.uic_cbReentrant, 'Value', Reentrant);
	set (handles.uic_cbSmoothData, 'Value', SmoothData);
	set (handles.uic_eSmoothingSpan, 'String', num2str (SmoothingSpan));
	set (handles.uic_cbUseSmoothedData, 'Value', UseSmoothedData);
	set (handles.uic_cbUse_OCS_plot, 'Value', Use_OCS_plot);

	% UIWAIT makes MEEdrift_control_panel wait for user response (see UIRESUME)
	% uiwait(handles.figure1);

% ~~~~~~~~~~~~~~~~~~~
% --- Outputs from this function are returned to the command line.
function varargout = MEEdrift_control_panel_OutputFcn(hObject, eventdata, handles)
	% varargout  cell array for returning output args (see VARARGOUT);
	% Get default command line output from handles structure
	varargout{1} = handles.output;

% ~~~~~~~~~~~~~~~~~~~
function uic_pbClose_Callback (hObject, eventdata, handles)
	% hObject    handle to uic_pbClose (see GCBO)
	global ControlPanelActive;
	ControlPanelActive = false;
	close (gcf);

% ~~~~~~~~~~~~~~~~~~~
function uic_cbReentrant_Callback (hObject, eventdata, handles)
	% hObject    handle to uic_cbReentrant (see GCBO)
	% Hint: get(hObject,'Value') returns toggle state of uic_cbReentrant
	global Reentrant;
	Reentrant = ~Reentrant;
	set (handles.uic_cbReentrant, 'Value', Reentrant);

% ~~~~~~~~~~~~~~~~~~~
function uic_cbPlotBeamConvergence_Callback (hObject, eventdata, handles)
	% hObject    handle to uic_cbPlotBeamConvergence (see GCBO)
	% Hint: get(hObject,'Value') returns toggle state of uic_cbPlotBeamConvergence
	global PlotBeamConvergence;
	PlotBeamConvergence = ~PlotBeamConvergence;
	set (handles.uic_cbPlotBeamConvergence, 'Value', PlotBeamConvergence);

% ~~~~~~~~~~~~~~~~~~~
function uic_cbSmoothData_Callback (hObject, eventdata, handles)
	% hObject    handle to uic_cbSmoothData (see GCBO)
	% Hint: get(hObject,'Value') returns toggle state of uic_cbSmoothData
	global SmoothData;
	SmoothData = ~SmoothData;
	set (handles.uic_cbSmoothData, 'Value', SmoothData);

% ~~~~~~~~~~~~~~~~~~~
function uic_cbUseSmoothedData_Callback (hObject, eventdata, handles)
	% hObject    handle to uic_cbUseSmoothedData (see GCBO)
	% Hint: get(hObject,'Value') returns toggle state of uic_cbUseSmoothedData
	global UseSmoothedData;
	UseSmoothedData = ~UseSmoothedData;
	set (handles.uic_cbUseSmoothedData, 'Value', UseSmoothedData);

% ~~~~~~~~~~~~~~~~~~~
function uic_eBeamsWindow_Callback (hObject, eventdata, handles)
	% hObject    handle to uic_eBeamsWindow (see GCBO)
	% Hints: get(hObject,'String') returns contents of uic_eBeamsWindow as text
%        str2double(get(hObject,'String')) returns contents of uic_eBeamsWindow as a double
	str = get (hObject, 'String');
	if ismember (str, '45678')
		n = str2double (str)
		if (n < 9) % could be 45, 567, etc.
			beamsWindow = n;
			set (handles.uic_eBeamsWindow, 'String', num2str (n));
		else
			warndlg ('Beam Window count must be [4-8].');
		end
	end

% ~~~~~~~~~~~~~~~~~~~
% --- Executes during object creation, after setting all properties.
function uic_eBeamsWindow_CreateFcn(hObject, eventdata, handles)
	% hObject    handle to uic_eBeamsWindow (see GCBO)
	%       See ISPC and COMPUTER.
	if ispc && isequal (get (hObject, 'BackgroundColor'), get (0, 'defaultUicontrolBackgroundColor'))
	    set (hObject, 'BackgroundColor', 'white');
	end

% ~~~~~~~~~~~~~~~~~~~
function uic_eBeamWindowSecs_Callback (hObject, eventdata, handles)
	% hObject    handle to uic_eBeamWindowSecs (see GCBO)
	% Hints: get(hObject,'String') returns contents of uic_eBeamWindowSecs as text
	%        str2double(get(hObject,'String')) returns contents of uic_eBeamWindowSecs as a double
	str = get (hObject, 'String');
	if ismember (str, '1234')
		n = str2double (str)
		if (n < 5) % could be 12, 234, etc.
			beamsWindow = n;
			set (handles.uic_eBeamsWindow, 'String', num2str (n));
		else
			warndlg ('Beam Window seconds must be [1-4].');
		end
	end

% ~~~~~~~~~~~~~~~~~~~
% --- Executes during object creation, after setting all properties.
function uic_eBeamWindowSecs_CreateFcn(hObject, eventdata, handles)
	% hObject    handle to uic_eBeamWindowSecs (see GCBO)
	%       See ISPC and COMPUTER.
	if ispc && isequal (get (hObject, 'BackgroundColor'), get (0, 'defaultUicontrolBackgroundColor'))
	    set (hObject, 'BackgroundColor', 'white');
	end

% ~~~~~~~~~~~~~~~~~~~
function uic_cbUse_OCS_plot_Callback(hObject, eventdata, handles)
	% hObject    handle to uic_cbUse_OCS_plot (see GCBO)
	% Hint: get(hObject,'Value') returns toggle state of uic_cbUse_OCS_plot
	global Use_OCS_plot;
	Use_OCS_plot = ~Use_OCS_plot;
	set (handles.uic_cbUse_OCS_plot, 'Value', Use_OCS_plot);

% ~~~~~~~~~~~~~~~~~~~
function uic_cbPlotIntersectDots_Callback(hObject, eventdata, handles)
	% hObject    handle to uic_cbPlotIntersectDots (see GCBO)
	% Hint: get (hObject,'Value') returns toggle state of uic_cbPlotIntersectDots
	global PlotIntersectDots;
	PlotIntersectDots = ~PlotIntersectDots;
	set (handles.uic_cbPlotIntersectDots, 'Value', PlotIntersectDots);

% ~~~~~~~~~~~~~~~~~~~
function uic_eSmoothingSpan_Callback(hObject, eventdata, handles)
	% hObject    handle to uic_eSmoothingSpan (see GCBO)
	% Hints: get(hObject,'String') returns contents of uic_eSmoothingSpan as text
	%        str2double(get(hObject,'String')) returns contents of uic_eSmoothingSpan as a double
	global SmoothingSpan;
	span = str2double (get (hObject, 'String'));
	if ~isnan (span)
		if (mod(span, 2) == 1) && (span > 9) && (span < 100) % must be odd
			SmoothingSpan = span;
			set (hObject, 'String', num2str (span));
		else
			warndlg ('Smoothing span must be [9 - 99] and ODD.');
		end
	end

% --- Executes during object creation, after setting all properties.
function uic_eSmoothingSpan_CreateFcn(hObject, eventdata, handles)
	% hObject    handle to uic_eSmoothingSpan (see GCBO)
	%       See ISPC and COMPUTER.
	if ispc && isequal (get (hObject, 'BackgroundColor'), get (0, 'defaultUicontrolBackgroundColor'))
	    set (hObject, 'BackgroundColor', 'white');
	end
