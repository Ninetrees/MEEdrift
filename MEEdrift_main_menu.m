function varargout = MEEdrift_main_menu (varargin)
% MEEdrift_main_menu MATLAB code for MEEdrift_main_menu.fig
%   MEEdrift_main_menu, by itself, creates a new MEEDRIFT_MAIN_MENU or raises
%   the existing singleton*.
%
%   H = MEEdrift_main_menu returns the handle to a new MEEdrift_main_menu or
%   the handle to the existing singleton*.
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
%   hObject    handle to uic_eOCS_BPP_axisMax (see GCBO)
%   eventdata  reserved - to be defined in a future version of MATLAB
%   handles    created //after all// CreateFcns called
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MEEdrift_main_menu

% Last Modified by GUIDE v2.5 28-Aug-2015 11:09:35

% Begin initialization code - DO NOT EDIT
	gui_Singleton = 1;
	gui_State = struct ('gui_Name',      mfilename, ...
	                   'gui_Singleton',  gui_Singleton, ...
	                   'gui_OpeningFcn', @MEEdrift_main_menu_OpeningFcn, ...
	                   'gui_OutputFcn',  @MEEdrift_main_menu_OutputFcn, ...
	                   'gui_LayoutFcn',  [] , ...
	                   'gui_Callback',   []);
	nArgsIn   = nargin;
	nVarArgin = length (varargin);
	nArgsOut  = nargout;

	if nArgsIn && ischar (varargin{1})
    gui_State.gui_Callback = str2func (varargin{1});
	end

	if nArgsOut
	  [varargout{1:nArgsOut}] = gui_mainfcn (gui_State, varargin{:});
	else
	  gui_mainfcn (gui_State, varargin{:});
	end
	% End initialization code - DO NOT EDIT
end

% --- Executes just before MEEdrift_main_menu is made visible.
function MEEdrift_main_menu_OpeningFcn (hObject, eventdata, handles, varargin)
	% This function has no output args; see OutputFcn.
	% hObject    handle to figure
	% varargin   command line arguments to MEEdrift_main_menu (see VARARGIN)

	% Choose default command line output for MEEdrift_main_menu
	handles.output = hObject;

	% Update handles structure
	guidata (hObject, handles);

	% !!! When editing externally, be SURE that the file is not open in MATLAB. !!!
	% If it is, MATLAB GUIDE will preferentially use THAT copy, and changes here will be lost. !!!
	global strMainMenu;
	global dotVersion;
	global fControlPanel;

	% 	set (handles.uic_txtTitle, 'String', [ 'MEEdrift ' dotVersion ]);

	% UIWAIT makes MEEdrift_main_menu wait for user response (see UIRESUME)
	uiwait (handles.fig_MEEdrift_MainMenu);
end

% ~~~~~~~~~~~~~~~~~~~
% --- Outputs from this function are returned to the command line.
function varargout = MEEdrift_main_menu_OutputFcn (hObject, eventdata, handles)
	% varargout  cell array for returning output args (see VARARGOUT);
	% hObject    handle to figure
	% Get default command line output from handles structure
	varargout{1} = []; % handles.output;
end

% ~~~~~~~~~~~~~~~~~~~
function uic_pbApplyEDP_offsets_Callback (hObject, eventdata, handles)
	% hObject    handle to uic_pbApplyEDP_offsets (see GCBO)
	global strMainMenu;
	strMainMenu = 'Apply EDP Offsets';
	uiresume (gcbf);
end

% ~~~~~~~~~~~~~~~~~~~
function uic_pbBeamNext_Callback (hObject, eventdata, handles)
	% hObject    handle to uic_pbBeamNext (see GCBO)
	global strMainMenu;
	strMainMenu = '> Beam >';
	uiresume (gcbf);
end

% ~~~~~~~~~~~~~~~~~~~
function uic_pbBeamPrev_Callback (hObject, eventdata, handles)
	% hObject    handle to uic_pbBeamPrev (see GCBO)
	global strMainMenu;
	strMainMenu = '< Beam <';
	uiresume (gcbf);
end

% ~~~~~~~~~~~~~~~~~~~
function uic_pbControlPanel_Callback (hObject, eventdata, handles)
	% hObject    handle to uic_pbControlPanel (see GCBO)
	global ControlPanelActive;
	ControlPanelActive = true; % control panel can be open even if the main menu closes
	MEEdrift_control_panel % (hEDP_mainAxes, hEDP_zoomedAxes)
end

% ~~~~~~~~~~~~~~~~~~~
function uic_pbExit_Callback (hObject, eventdata, handles)
	% hObject    handle to uic_pbExit (see GCBO)
	global ControlPanelActive fControlPanel strMainMenu;
	strMainMenu = 'Exit';
	if ControlPanelActive
		close (fControlPanel);
	end
	uiresume (gcbf);
	close (gcf);
end

% ~~~~~~~~~~~~~~~~~~~
function uic_pbPlotFFT_Callback (hObject, eventdata, handles)
	% hObject    handle to uic_pbPlotFFT (see GCBO)
	global strMainMenu;
	strMainMenu = 'Plot EDP FFT x,y';
	uiresume (gcbf);
end

% ~~~~~~~~~~~~~~~~~~~
function uic_pbSavePlots_Callback (hObject, eventdata, handles)
	% hObject    handle to uic_pbSavePlots (see GCBO)
	global strMainMenu;
	strMainMenu = 'Save Plots';
	uiresume (gcbf);
end

% ~~~~~~~~~~~~~~~~~~~
function uic_pbSaveSnapshot_Callback (hObject, eventdata, handles)
	% hObject    handle to uic_pbSaveSnapshot (see GCBO)
	global strMainMenu;
	strMainMenu = 'Save Snapshot';
	uiresume (gcbf);
end

% ~~~~~~~~~~~~~~~~~~~
function uic_pbSkipViaEDP_Callback (hObject, eventdata, handles)
	% hObject    handle to uic_pbSkipViaEDP (see GCBO)
	global strMainMenu;
	strMainMenu = 'Skip via EDP';
	uiresume (gcbf);
end


% --- Executes on button press in uic_pbSmoothEDP.
function uic_pbSmoothEDP_Callback (hObject, eventdata, handles)
	% hObject    handle to uic_pbSmoothEDP (see GCBO)
	global strMainMenu;
	strMainMenu = 'Smooth EDP';
	uiresume (gcbf);
end
