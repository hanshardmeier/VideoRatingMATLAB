function varargout = StartWindow(varargin)
% STARTWINDOW MATLAB code for StartWindow.fig
%      STARTWINDOW, by itself, creates a new STARTWINDOW or raises the existing
%      singleton*.
%
%       StartWindow selects or create the File to be used for the session.
%       The file is defined by rater number, session number and patient
%       num.
%
%
%      H = STARTWINDOW returns the handle to a new STARTWINDOW or the handle to
%      the existing singleton*.
%
%      STARTWINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STARTWINDOW.M with the given input arguments.
%
%      STARTWINDOW('Property','Value',...) creates a new STARTWINDOW or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before StartWindow_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to StartWindow_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help StartWindow

% Last Modified by GUIDE v2.5 01-Oct-2018 20:41:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @StartWindow_OpeningFcn, ...
                   'gui_OutputFcn',  @StartWindow_OutputFcn, ...
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

% --- Executes just before StartWindow is made visible.
function StartWindow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to StartWindow (see VARARGIN)

% Center Window
movegui(hObject,'center');

% Set Data Object to Figure
if(not(isprop(hObject,'SessionData')))
    addprop(hObject,'SessionData');
end
data =SessionData();
hObject.SessionData = data;
data.OutputFolder=strcat(pwd,"/Reports/");

% Choose default command line output for StartWindow
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes StartWindow wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = StartWindow_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Create a new session window with the sessiondata given/loaded
function SessionWindow_Open(data)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
windowSession = SessionWindow(data);
assignin('base','windowSession',windowSession);

% --- Executes on button press in btn_loadSitzung.
% Read and parses the given CSV Filename into the SessionData and opens
% a new Session window with the session data.
function btn_loadSitzung_Callback(hObject, eventdata, handles)
% hObject    handle to btn_loadSitzung (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
window = gcf;
filepath=get(handles.txt_filepath, 'String');
window.SessionData.Parse(filepath);
SessionWindow_Open(window.SessionData)
close(window);

% --- Executes on button press in btn_createSitzung.
% Fetches the data from the fields, sets the values in the sessiondata 
% creates an empty csv file and open the session window.
function btn_createSitzung_Callback(hObject, eventdata, handles)
% hObject    handle to btn_createSitzung (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
window = gcf;
window.SessionData.PatientNum = ...
    str2double(get(handles.edit_patientNum,'String'));
window.SessionData.SessionNum = ...
    str2double(get(handles.edit_sitzungNum,'String'));

contents = cellstr(get(handles.edit_rater,'String'));
listEntry = contents{get(handles.edit_rater,'Value')};
window.SessionData.Rater = str2double(listEntry(1:1));

outputPath =window.SessionData.GetOutputFilePath();
csvwrite(outputPath,[]);
SessionWindow_Open(window.SessionData)
close(window);



% --- Executes on button press in btn_fileload.
% Only sets the filename to its text control
function btn_fileload_Callback(hObject, eventdata, handles)
% hObject    handle to btn_fileload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
window = gcf;

[file,path] = uigetfile(strcat(window.SessionData.OutputFolder,'*.csv'));
if isequal(file,0)
   disp('User selected Cancel');
else
   disp(['User selected ', fullfile(path,file)]);
   set(handles.txt_filepath, 'String',  fullfile(path,file));
end