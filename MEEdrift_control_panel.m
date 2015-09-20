function varargout = MEEdrift_control_panel (varargin)
% MEEdrift_main_menu MATLAB code for MEEdrift_main_menu.fig
%   MEEdrift_main_menu, by itself, creates a new MEEDRIFT_MAIN_MENU or raises
%   the existing singleton*.
%
%
%   MEEdrift_main_menu ('CALLBACK', hObject, eventData, handles, ...) calls the local
%   function named CALLBACK in MEEdrift_main_menu.m, with the given input arguments.
%
%   MEEdrift_main_menu ('Property', 'Value', ...) creates a new MEEdrift_main_menu or
%   raises the existing singleton*. Starting from the left, property value pairs are
%   applied to the GUI before MEEdrift_main_menu_OpeningFcn gets called.
%   An unrecognized property name or invalid value makes property application
%   stop. All inputs are passed to MEEdrift_main_menu_OpeningFcn via varargin.
%
%   ~~~~~~~~~~~~~~~~~~~
%   When MEEdrift_main_menu is created,
%   UIWAIT makes MEEdrift_main_menu wait for user response (see UIRESUME).
%   uiwait (handles.fig_MEEdrift_MainMenu);
%   MEEdrift_main_menu is in a while loop that contains logic similar to
%
%   while SomeTestIsTrue
%     MEEdrift_main_menu;
%     switch strMainMenu
%       case '< Beam <'
%         ...
%     end
%   end
%
%   A typical callback takes appropriate actions, and triggers uiresume.
%   function uic_pbBeamPrev_Callback (hObject, eventdata, handles)
%     global strMainMenu;
%     strMainMenu = '< Beam <';
%     uiresume (gcbf);
%   end
%
%   The logic that triggered MEEdrift_main_menu then takes appropriate action.
%
%   *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%   instance to run (singleton)".
%
%   In object functions below:
%   hObject    handle to uic_eOCS_BPP_axisOriginX (see GCBO)
%   eventdata  reserved - to be defined in a future version of MATLAB
%   handles    created //after all// CreateFcns called
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MEEdrift_control_panel

% Last Modified by GUIDE v2.5 20-Sep-2015 14:59:22

% Begin initialization code - DO NOT EDIT
	gui_Singleton = 1;
	gui_State = struct ('gui_Name',      mfilename, ...
	                   'gui_Singleton',  gui_Singleton, ...
	                   'gui_OpeningFcn', @MEEdrift_control_panel_OpeningFcn, ...
	                   'gui_OutputFcn',  @MEEdrift_control_panel_OutputFcn, ...
	                   'gui_LayoutFcn',  [] , ...
	                   'gui_Callback',   []);
	if nargin && ischar (varargin{1})
		gui_State.gui_Callback = str2func (varargin{1});
	end

	if nargout
	  [varargout{1:nargout}] = gui_mainfcn (gui_State, varargin{:});
	else
	  gui_mainfcn (gui_State, varargin{:});
	end
  % End initialization code - DO NOT EDIT
end

% --- Executes just before MEEdrift_control_panel is made visible.
function MEEdrift_control_panel_OpeningFcn (hObject, eventdata, handles, varargin)
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
	global SmoothData;
	global SmoothingSpan;
	global UseSmoothedData;
	global Use_OCS_plot;
	global EDPx_offset;
	global EDPy_offset;
	global EDPz_offset;
	global EDPx_factor;
  global EDPy_factor;
  global EDPz_factor;
	global EDP_plot_ylim;
	global OCS_BPP_axisOriginX;
	global OCS_BPP_axisOriginY;
	global OCS_BPP_axisOriginZ;
	global OCS_BPP_axisRange;

% EDP_offset = [ EDPx_offset EDPy_offset EDPz_offset ]
% EDP_offset = [ 1.0 1.0 1.0 ]
% num2str (EDPx_offset)
% EDP_Xfactor = [ EDPx_factor EDPy_factor EDPz_factor ]

	fControlPanel = hObject;
	set (handles.uic_txtTitle, 'String', [ 'MEEdrift ' dotVersion ]);
	set (handles.uic_eBeamsWindow, 'String', num2str (beamsWindow));
	set (handles.uic_eBeamWindowSecs, 'String', num2str (beamWindowSecs));

	set (handles.uic_cbPlotBeamConvergence, 'Value', PlotBeamConvergence);
	set (handles.uic_cbPlotIntersectDots, 'Value', PlotIntersectDots);

	set (handles.uic_cbSmoothData, 'Value', SmoothData);
	set (handles.uic_eSmoothingSpan, 'String', num2str (SmoothingSpan));
	set (handles.uic_cbUseSmoothedData, 'Value', UseSmoothedData);

	set (handles.uic_cbUse_OCS_plot, 'Value', Use_OCS_plot);

	set (handles.uic_eEDPx_offset, 'String', num2str (EDPx_offset));
	set (handles.uic_eEDPy_offset, 'String', num2str (EDPy_offset));
	set (handles.uic_eEDPz_offset, 'String', num2str (EDPz_offset));

	set (handles.uic_eEDPx_XFactor, 'String', num2str (EDPx_factor));
	set (handles.uic_eEDPy_XFactor, 'String', num2str (EDPy_factor));
	set (handles.uic_eEDPz_XFactor, 'String', num2str (EDPz_factor));

	set (handles.uic_eEDP_plot_ylim, 'String', num2str (EDP_plot_ylim));
	set (handles.uic_eOCS_BPP_axisOriginX, 'String', num2str (OCS_BPP_axisOriginX));
	set (handles.uic_eOCS_BPP_axisOriginY, 'String', num2str (OCS_BPP_axisOriginY));
	set (handles.uic_eOCS_BPP_axisOriginZ, 'String', num2str (OCS_BPP_axisOriginZ));
	set (handles.uic_eOCS_BPP_axisRange, 'String', num2str (OCS_BPP_axisRange));

	% UIWAIT makes MEEdrift_control_panel wait for user response (see UIRESUME)
	% uiwait (handles.figure1);
end

% ~~~~~~~~~~~~~~~~~~~
% --- Outputs from this function are returned to the command line.
function varargout = MEEdrift_control_panel_OutputFcn (hObject, eventdata, handles)
	% varargout  cell array for returning output args (see VARARGOUT);
	% Get default command line output from handles structure
	varargout{1} = handles.output;
end

% ~~~~~~~~~~~~~~~~~~~
function uic_eBeamsWindow_Callback (hObject, eventdata, handles)
	% Hints: get (hObject, 'String') returns contents of uic_eBeamsWindow as text
	%        str2double (get (hObject, 'String')) returns contents of uic_eBeamsWindow as a double
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
end

% ~~~~~~~~~~~~~~~~~~~
% --- Executes during object creation, after setting all properties.
function uic_eBeamsWindow_CreateFcn (hObject, eventdata, handles)
	if ispc && isequal (get (hObject, 'BackgroundColor'), get (0, 'defaultUicontrolBackgroundColor'))
	    set (hObject, 'BackgroundColor', 'white');
	end
end

% ~~~~~~~~~~~~~~~~~~~
function uic_eBeamWindowSecs_Callback (hObject, eventdata, handles)
	% Hints: get (hObject, 'String') returns contents of uic_eBeamWindowSecs as text
	%        str2double (get (hObject, 'String')) returns contents of uic_eBeamWindowSecs as a double
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
end

% ~~~~~~~~~~~~~~~~~~~
% --- Executes during object creation, after setting all properties.
function uic_eBeamWindowSecs_CreateFcn (hObject, eventdata, handles)
	if ispc && isequal (get (hObject, 'BackgroundColor'), get (0, 'defaultUicontrolBackgroundColor'))
	    set (hObject, 'BackgroundColor', 'white');
	end
end

% ~~~~~~~~~~~~~~~~~~~
function uic_pbClose_Callback (hObject, eventdata, handles)
	global ControlPanelActive;
	ControlPanelActive = false;
	close (gcf);
end

% ~~~~~~~~~~~~~~~~~~~
function uic_cbPlotBeamConvergence_Callback (hObject, eventdata, handles)
	% Hint: get (hObject, 'Value') returns toggle state of uic_cbPlotBeamConvergence
	global PlotBeamConvergence;
	PlotBeamConvergence = ~PlotBeamConvergence;
	set (handles.uic_cbPlotBeamConvergence, 'Value', PlotBeamConvergence);
end

% ~~~~~~~~~~~~~~~~~~~
function uic_cbPlotIntersectDots_Callback (hObject, eventdata, handles)
	% Hint: get (hObject, 'Value') returns toggle state of uic_cbPlotIntersectDots
	global PlotIntersectDots;
	PlotIntersectDots = ~PlotIntersectDots;
	set (handles.uic_cbPlotIntersectDots, 'Value', PlotIntersectDots);
end

% ~~~~~~~~~~~~~~~~~~~
function uic_cbSmoothData_Callback (hObject, eventdata, handles)
	% Hint: get (hObject, 'Value') returns toggle state of uic_cbSmoothData
	global SmoothData;
	global UseSmoothedData;
	SmoothData = ~SmoothData;
	UseSmoothedData = SmoothData;
	set (handles.uic_cbSmoothData, 'Value', SmoothData);
	set (handles.uic_cbUseSmoothedData, 'Value', UseSmoothedData);
end

% ~~~~~~~~~~~~~~~~~~~
function uic_cbUse_OCS_plot_Callback (hObject, eventdata, handles)
	% Hint: get (hObject, 'Value') returns toggle state of uic_cbUse_OCS_plot
	global Use_OCS_plot;
	Use_OCS_plot = ~Use_OCS_plot;
	set (handles.uic_cbUse_OCS_plot, 'Value', Use_OCS_plot);
end

% ~~~~~~~~~~~~~~~~~~~
function uic_cbUseSmoothedData_Callback (hObject, eventdata, handles)
	% Hint: get (hObject, 'Value') returns toggle state of uic_cbUseSmoothedData
	global UseSmoothedData;
	UseSmoothedData = ~UseSmoothedData;
	set (handles.uic_cbUseSmoothedData, 'Value', UseSmoothedData);
end

% ~~~~~~~~~~~~~~~~~~~
function uic_eSmoothingSpan_Callback (hObject, eventdata, handles)
	% Hints: get (hObject, 'String') returns contents of uic_eSmoothingSpan as text
	%        str2double (get (hObject, 'String')) returns contents of uic_eSmoothingSpan as a double
	global SmoothingSpan;
	span = str2double (get (hObject, 'String'));
	if ~isnan (span)
		if (mod (span, 2) == 1) && (span > 9) && (span < 100) % must be odd
			SmoothingSpan = span;
			set (hObject, 'String', num2str (span));
		else
			warndlg ('Smoothing span must be [9 .. 99] and ODD.');
		end
	end
end

% ~~~~~~~~~~~~~~~~~~~
% --- Executes during object creation, after setting all properties.
function uic_eSmoothingSpan_CreateFcn (hObject, eventdata, handles)
	if ispc && isequal (get (hObject, 'BackgroundColor'), get (0, 'defaultUicontrolBackgroundColor'))
	    set (hObject, 'BackgroundColor', 'white');
	end
end

% ~~~~~~~~~~~~~~~~~~~
function uic_eEDPx_offset_Callback (hObject, eventdata, handles)
	% Hints: get (hObject, 'String') returns contents of uic_eEDP_xOffset as text
	%        str2double (get (hObject, 'String')) returns contents of uic_eEDP_xOffset as a double
	global EDPx_offset;
	offset = str2double (get (hObject, 'String'));
	if ~isnan (offset)
		if (offset > -100) && (offset < 100) % arbitrary limits
			EDPx_offset = offset;
			set (hObject, 'String', num2str (offset));
		else
			warndlg ('EDPx_offset must be [-99 .. 99].');
		end
	end
end

% ~~~~~~~~~~~~~~~~~~~
% --- Executes during object creation, after setting all properties.
function uic_eEDPx_offset_CreateFcn (hObject, eventdata, handles)
	if ispc && isequal (get (hObject, 'BackgroundColor'), get (0, 'defaultUicontrolBackgroundColor'))
		set (hObject, 'BackgroundColor', 'white');
	end
end

% ~~~~~~~~~~~~~~~~~~~
function uic_eEDPy_offset_Callback (hObject, eventdata, handles)
	% Hints: get (hObject, 'String') returns contents of uic_eEDP_yOffset as text
	%        str2double (get (hObject, 'String')) returns contents of uic_eEDP_yOffset as a double
	global EDPy_offset;
	offset = str2double (get (hObject, 'String'));
	if ~isnan (offset)
		if (offset > -100) && (offset < 100) % arbitrary limits
			EDPy_offset = offset;
			set (hObject, 'String', num2str (offset));
		else
			warndlg ('EDPy_offset must be [-99 .. 99].');
		end
	end
end

% ~~~~~~~~~~~~~~~~~~~
% --- Executes during object creation, after setting all properties.
function uic_eEDPy_offset_CreateFcn (hObject, eventdata, handles)
	if ispc && isequal (get (hObject, 'BackgroundColor'), get (0, 'defaultUicontrolBackgroundColor'))
	  set (hObject, 'BackgroundColor', 'white');
	end
end

% ~~~~~~~~~~~~~~~~~~~
function uic_eEDPz_offset_Callback (hObject, eventdata, handles)
	% Hints: get (hObject, 'String') returns contents of uic_eEDP_zOffset as text
	%        str2double (get (hObject, 'String')) returns contents of uic_eEDP_zOffset as a double
	global EDPz_offset;
	offset = str2double (get (hObject, 'String'));
	if ~isnan (offset)
		if (offset > -100) && (offset < 100) % arbitrary limits
			EDPz_offset = offset;
			set (hObject, 'String', num2str (offset));
		else
			warndlg ('EDPz_offset must be [-99 .. 99].');
		end
	end
end

% ~~~~~~~~~~~~~~~~~~~
function uic_eEDPz_offset_CreateFcn (hObject, eventdata, handles)
	if ispc && isequal (get (hObject, 'BackgroundColor'), get (0, 'defaultUicontrolBackgroundColor'))
		set (hObject, 'BackgroundColor', 'white');
	end
end

% ~~~~~~~~~~~~~~~~~~~
function uic_eEDP_plot_ylim_Callback (hObject, eventdata, handles)
	% Hints: get(hObject,'String') returns contents of uic_eEDP_plot_ylim as text
	%        str2double(get(hObject,'String')) returns contents of uic_eEDP_plot_ylim as a double

	global hEDP_mainAxes;
	global hEDP_zoomedAxes;
	global EDP_plot_ylim;

	ylim_ = str2double (get (hObject, 'String'));
	if ~isnan (ylim_)
		if (ylim_ > 4) && (ylim_ < 1000) % arbitrary limits
			EDP_plot_ylim = ylim_;
			set (hObject, 'String', num2str (ylim_));
			ylim (hEDP_mainAxes, [ -EDP_plot_ylim EDP_plot_ylim ] );
			ylim (hEDP_mainAxes, 'manual');
			ylim (hEDP_zoomedAxes, [ -EDP_plot_ylim EDP_plot_ylim ] );
			ylim (hEDP_zoomedAxes, 'manual');
		else
			warndlg ('EDP plot Y-axis limit must be [5 .. 999].');
		end
	end
end

% ~~~~~~~~~~~~~~~~~~~
function uic_eEDP_plot_ylim_CreateFcn (hObject, eventdata, handles)
	if ispc && isequal (get (hObject, 'BackgroundColor'), get (0, 'defaultUicontrolBackgroundColor'))
		set (hObject, 'BackgroundColor', 'white');
	end
end

% ~~~~~~~~~~~~~~~~~~~
function uic_eEDPx_XFactor_Callback (hObject, eventdata, handles)
	% Hints: get(hObject,'String') returns contents of uic_eEDPx_XFactor as text
	%        str2double(get(hObject,'String')) returns contents of uic_eEDPx_XFactor as a double
	global EDPx_factor;
	factor = str2double (get (hObject, 'String'));
	if ~isnan (factor)
		if (factor > -2.0) && (factor < 2.0) % arbitrary limits
			EDPx_factor = factor;
			set (hObject, 'String', num2str (factor));
		else
			warndlg ('EDPz_factor must be [-2.0 .. 2.0].');
		end
	end
end

% ~~~~~~~~~~~~~~~~~~~
% --- Executes during object creation, after setting all properties.
function uic_eEDPx_XFactor_CreateFcn (hObject, eventdata, handles)
	% Hint: edit controls usually have a white background on Windows.
	%       See ISPC and COMPUTER.
	if ispc && isequal (get (hObject, 'BackgroundColor'), get (0, 'defaultUicontrolBackgroundColor'))
		set (hObject, 'BackgroundColor', 'white');
	end
end

% ~~~~~~~~~~~~~~~~~~~
function uic_eEDPy_XFactor_Callback (hObject, eventdata, handles)
	% Hints: get(hObject,'String') returns contents of uic_eEDPy_XFactor as text
	%        str2double(get(hObject,'String')) returns contents of uic_eEDPy_XFactor as a double
	global EDPy_factor;
	factor = str2double (get (hObject, 'String'));
	if ~isnan (factor)
		if (factor > -2.0) && (factor < 2.0) % arbitrary limits
			EDPy_factor = factor;
			set (hObject, 'String', num2str (factor));
		else
			warndlg ('EDPz_factor must be [-2.0 .. 2.0].');
		end
	end
end

% ~~~~~~~~~~~~~~~~~~~
% --- Executes during object creation, after setting all properties.
function uic_eEDPy_XFactor_CreateFcn (hObject, eventdata, handles)
	% Hint: edit controls usually have a white background on Windows.
	%       See ISPC and COMPUTER.
	if ispc && isequal (get (hObject, 'BackgroundColor'), get (0, 'defaultUicontrolBackgroundColor'))
		set (hObject, 'BackgroundColor', 'white');
	end
end

% ~~~~~~~~~~~~~~~~~~~
function uic_eEDPz_XFactor_Callback (hObject, eventdata, handles)
	% Hints: get(hObject,'String') returns contents of uic_eEDPz_XFactor as text
	%        str2double(get(hObject,'String')) returns contents of uic_eEDPz_XFactor as a double
	global EDPz_factor;
	factor = str2double (get (hObject, 'String'));
	if ~isnan (factor)
		if (factor > -2.0) && (factor < 2.0) % arbitrary limits
			EDPz_factor = factor;
			set (hObject, 'String', num2str (factor));
		else
			warndlg ('EDPz_factor must be [-2.0 .. 2.0].');
		end
	end
end

% ~~~~~~~~~~~~~~~~~~~
% --- Executes during object creation, after setting all properties.
function uic_eEDPz_XFactor_CreateFcn (hObject, eventdata, handles)
	% Hint: edit controls usually have a white background on Windows.
	%       See ISPC and COMPUTER.
	if ispc && isequal (get (hObject, 'BackgroundColor'), get (0, 'defaultUicontrolBackgroundColor'))
		set (hObject, 'BackgroundColor', 'white');
	end
end

% ~~~~~~~~~~~~~~~~~~~
function uic_eOCS_BPP_axisOriginX_Callback (hObject, eventdata, handles)
	% Hints: get(hObject,'String') returns contents of uic_eOCS_BPP_axisOriginX as text
	%        str2double(get(hObject,'String')) returns contents of uic_eOCS_BPP_axisOriginX as a double
	global OCS_BPP_axisOriginX;
	axisOrigin = str2double (get (hObject, 'String'));
	if ~isnan (axisOrigin)
		if (axisOrigin > -20.001) && (axisOrigin < 20.001) % arbitrary limits
			OCS_BPP_axisOriginX = axisOrigin;
			set (hObject, 'String', num2str (axisOrigin));
		else
			warndlg ('OCS & BPP axis origin must be [-20 .. 20].');
		end
	end
end

% ~~~~~~~~~~~~~~~~~~~
% --- Executes during object creation, after setting all properties.
function uic_eOCS_BPP_axisOriginX_CreateFcn (hObject, eventdata, handles)
	% Hint: edit controls usually have a white background on Windows.
	%       See ISPC and COMPUTER.
	if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
	    set(hObject,'BackgroundColor','white');
	end
end

% ~~~~~~~~~~~~~~~~~~~
function uic_eOCS_BPP_axisOriginY_Callback (hObject, eventdata, handles)
	% Hints: get(hObject,'String') returns contents of uic_eOCS_BPP_axisOriginY as text
	%        str2double(get(hObject,'String')) returns contents of uic_eOCS_BPP_axisOriginY as a double
	global OCS_BPP_axisOriginY;
	axisOrigin = str2double (get (hObject, 'String'));
	if ~isnan (axisOrigin)
		if (axisOrigin > -20.001) && (axisOrigin < 20.001) % arbitrary limits
			OCS_BPP_axisOriginY = axisOrigin;
			set (hObject, 'String', num2str (axisOrigin));
		else
			warndlg ('OCS & BPP axis origin must be [-20 .. 20].');
		end
	end
end

% ~~~~~~~~~~~~~~~~~~~
% --- Executes during object creation, after setting all properties.
function uic_eOCS_BPP_axisOriginY_CreateFcn (hObject, eventdata, handles)
	if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
		set(hObject,'BackgroundColor','white');
	end
end


% ~~~~~~~~~~~~~~~~~~~
function uic_eOCS_BPP_axisOriginZ_Callback (hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of uic_eOCS_BPP_axisOriginZ as text
%        str2double(get(hObject,'String')) returns contents of uic_eOCS_BPP_axisOriginZ as a double
	global OCS_BPP_axisOriginZ;
	axisOrigin = str2double (get (hObject, 'String'));
	if ~isnan (axisOrigin)
		if (axisOrigin > -20.001) && (axisOrigin < 20.001) % arbitrary limits
			OCS_BPP_axisOriginZ = axisOrigin;
			set (hObject, 'String', num2str (axisOrigin));
		else
			warndlg ('OCS & BPP axis origin must be [-20 .. 20].');
		end
	end
end

% ~~~~~~~~~~~~~~~~~~~
% --- Executes during object creation, after setting all properties.
function uic_eOCS_BPP_axisOriginZ_CreateFcn (hObject, eventdata, handles)
	if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
		set(hObject,'BackgroundColor','white');
	end
end
% ~~~~~~~~~~~~~~~~~~~
function uic_eOCS_BPP_axisRange_Callback (hObject, eventdata, handles)
	% Hints: get(hObject,'String') returns contents of uic_eOCS_BPP_axisRange as text
	%        str2double(get(hObject,'String')) returns contents of uic_eOCS_BPP_axisRange as a double
	global OCS_BPP_axisRange;
	axisRange = str2double (get (hObject, 'String'));
	if ~isnan (axisRange)
		if (axisRange > 0.999) && (axisRange < 20.001) % arbitrary limits
			OCS_BPP_axisRange = axisRange;
			set (hObject, 'String', num2str (axisRange));
		else
			warndlg ('OCS & BPP axis range must be (1 .. 20).');
		end
	end
end

% ~~~~~~~~~~~~~~~~~~~
% --- Executes during object creation, after setting all properties.
function uic_eOCS_BPP_axisRange_CreateFcn (hObject, eventdata, handles)
	if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
		set(hObject,'BackgroundColor','white');
	end
end
