function varargout = MEEdrift_main_menu(varargin)
% MEEDRIFT_MAIN_MENU MATLAB code for MEEdrift_main_menu.fig
%      MEEDRIFT_MAIN_MENU, by itself, creates a new MEEDRIFT_MAIN_MENU or raises the existing
%      singleton*.
%
%      H = MEEDRIFT_MAIN_MENU returns the handle to a new MEEDRIFT_MAIN_MENU or the handle to
%      the existing singleton*.
%
%      MEEDRIFT_MAIN_MENU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MEEDRIFT_MAIN_MENU.M with the given input arguments.
%
%      MEEDRIFT_MAIN_MENU('Property','Value',...) creates a new MEEDRIFT_MAIN_MENU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MEEdrift_main_menu_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MEEdrift_main_menu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MEEdrift_main_menu

% Last Modified by GUIDE v2.5 14-Aug-2015 12:24:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MEEdrift_main_menu_OpeningFcn, ...
                   'gui_OutputFcn',  @MEEdrift_main_menu_OutputFcn, ...
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

% --- Executes just before MEEdrift_main_menu is made visible.
function MEEdrift_main_menu_OpeningFcn(hObject, eventdata, handles, varargin)
	% This function has no output args, see OutputFcn.
	% hObject    handle to figure
	% varargin   command line arguments to MEEdrift_main_menu (see VARARGIN)

	% Choose default command line output for MEEdrift_main_menu
	handles.output = hObject;

	% Update handles structure
	guidata(hObject, handles);

	% !!! When editing externally, be SURE that the file is not open in MATLAB. !!!
	% If it is, MATLAB GUIDE will preferentially use THAT copy, and changes here will be lost. !!!
	global strMainMenu;
	global dotVersion;
	global fControlPanel;

% 	set (handles.uic_txtTitle, 'String', [ 'MEEdrift ' dotVersion ]);

	% UIWAIT makes MEEdrift_main_menu wait for user response (see UIRESUME)
	uiwait (handles.figure1);

% ~~~~~~~~~~~~~~~~~~~
% --- Outputs from this function are returned to the command line.
function varargout = MEEdrift_main_menu_OutputFcn(hObject, eventdata, handles)
	% varargout  cell array for returning output args (see VARARGOUT);
	% hObject    handle to figure
	% Get default command line output from handles structure
	varargout{1} = []; % handles.output;

% ~~~~~~~~~~~~~~~~~~~
function uic_pbBeamPrev_Callback(hObject, eventdata, handles)
	% hObject    handle to uic_pbBeamPrev (see GCBO)
	global strMainMenu;
	strMainMenu = '< Beam <';
	uiresume (gcbf);

% ~~~~~~~~~~~~~~~~~~~
function uic_pbBeamNext_Callback(hObject, eventdata, handles)
	% hObject    handle to uic_pbBeamNext (see GCBO)
	global strMainMenu;
	strMainMenu = '> Beam >';
	uiresume (gcbf);

% ~~~~~~~~~~~~~~~~~~~
function uic_pbSkipViaEDP_Callback(hObject, eventdata, handles)
	% hObject    handle to uic_pbSkipViaEDP (see GCBO)
	global strMainMenu;
	strMainMenu = 'Skip via EDP';
	uiresume (gcbf);

% ~~~~~~~~~~~~~~~~~~~
function uic_pbSavePlots_Callback(hObject, eventdata, handles)
	% hObject    handle to uic_pbSavePlots (see GCBO)
	global strMainMenu;
	strMainMenu = 'Save Plots';
	uiresume (gcbf);

% ~~~~~~~~~~~~~~~~~~~
function uic_pbSaveSnapshot_Callback(hObject, eventdata, handles)
	% hObject    handle to uic_pbSaveSnapshot (see GCBO)
	global strMainMenu;
	strMainMenu = 'Save Snapshot';
	uiresume (gcbf);

% ~~~~~~~~~~~~~~~~~~~
function uic_pbPlotFFT_Callback(hObject, eventdata, handles)
	% hObject    handle to uic_pbPlotFFT (see GCBO)
	global strMainMenu;
	strMainMenu = 'Plot EDP FFT x,y';
	uiresume (gcbf);

% ~~~~~~~~~~~~~~~~~~~
function uic_pbExit_Callback(hObject, eventdata, handles)
	% hObject    handle to uic_pbExit (see GCBO)
	global ControlPanelActive fControlPanel strMainMenu;
	strMainMenu = 'Exit';
	if ControlPanelActive
		close (fControlPanel);
	end
	uiresume (gcbf);
	close (gcf);

% ~~~~~~~~~~~~~~~~~~~
function uic_pbControlPanel_Callback(hObject, eventdata, handles)
	% hObject    handle to uic_pbControlPanel (see GCBO)
	global ControlPanelActive;
	ControlPanelActive  = true; % control panel can be open even if the main menu closes
	MEEdrift_control_panel
