function varargout = SessionWindow(varargin)
% SESSIONWINDOW MATLAB code for SessionWindow.fig
%      SESSIONWINDOW, by itself, creates a new SESSIONWINDOW or raises the existing
%      singleton*.
%
%      SessionWindow is the window to rate the phases.
%
%      H = SESSIONWINDOW returns the handle to a new SESSIONWINDOW or the handle to
%      the existing singleton*.
%
%      SESSIONWINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SESSIONWINDOW.M with the given input arguments.
%
%      SESSIONWINDOW('Property','Value',...) creates a new SESSIONWINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SessionWindow_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SessionWindow_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SessionWindow

% Last Modified by GUIDE v2.5 02-Oct-2018 17:35:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SessionWindow_OpeningFcn, ...
                   'gui_OutputFcn',  @SessionWindow_OutputFcn, ...
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


% --- Executes just before SessionWindow is made visible.
function SessionWindow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SessionWindow (see VARARGIN)

% Center Window
movegui(hObject,'center');

% Set Data Object to Figure
if(not(isprop(hObject,'ContentHandler')))
    addprop(hObject,'ContentHandler');
end

dbHandler = DatabaseHandler(varargin{1},handles);
hObject.ContentHandler = ContentHandler(handles,dbHandler);

% Choose default command line output for SessionWindow
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

hObject.ContentHandler.ShowFirstPage();

% UIWAIT makes SessionWindow wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = SessionWindow_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
windowSession=gcf;
windowSession.ContentHandler.MyDefaultTimer.stop();
delete(hObject);

% --- Executes on button press in btn_next.
% Callback for Next Button
function btn_next_Callback(hObject, eventdata, handles)
% hObject    handle to btn_next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
windowSession=gcf;
windowSession.ContentHandler.NextIfPossible();


% --- Executes on button press in btn_before.
% Callback for Before Button
function btn_before_Callback(hObject, eventdata, handles)
% hObject    handle to btn_before (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

windowSession =gcf;
windowSession.ContentHandler.BeforeIfPossible(); 


% --- Executes on button press in btn_close.
% Callback for Close button
function btn_close_Callback(hObject, eventdata, handles)
% hObject    handle to btn_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close();


% --- Executes when selected object is changed in Grp_P2_PosAffekt.
function Grp_P2_PosAffekt_SelectionChangedFcn(rbtn_handle, eventdata, handles)
% hObject    handle to the selected object in Grp_P2_PosAffekt 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
windowSession = gcf;
value = get_value(rbtn_handle);
windowSession.ContentHandler.SetValue(handles.Grp_P2_PosAffekt,value);

% --- Executes when selected object is changed in Grp_P2_NegAffekt.
function Grp_P2_NegAffekt_SelectionChangedFcn(rbtn_handle, eventdata, handles)
% hObject    handle to the selected object in Grp_P2_NegAffekt 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
windowSession = gcf;
value = get_value(rbtn_handle);
windowSession.ContentHandler.SetValue(handles.Grp_P2_NegAffekt,value);


% --- Executes when selected object is changed in Grp_A2_Inhalt.
function Grp_A2_Inhalt_SelectionChangedFcn(rbtn_handle, eventdata, handles)
% hObject    handle to the selected object in Grp_A2_Inhalt 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
windowSession = gcf;
value = get_value(rbtn_handle);
windowSession.ContentHandler.SetValue(handles.Grp_A2_Inhalt,value);

% --- Executes on button press in ChkBox_A2_PersF.
function ChkBox_A2_PersF_Callback(hObject, eventdata, handles)
% hObject    handle to ChkBox_A2_PersF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

windowSession = gcf;
value = get(hObject,'Value');
windowSession.ContentHandler.SetValue(handles.ChkBox_A2_PersF,value);


% --- Executes on button press in ChkBox_A2_PosG.
function ChkBox_A2_PosG_Callback(hObject, eventdata, handles)
% hObject    handle to ChkBox_A2_PosG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

windowSession = gcf;
value = get(hObject,'Value');
windowSession.ContentHandler.SetValue(handles.ChkBox_A2_PosG,value);


% --- Executes on button press in ChkBox_A2_PosInt.
function ChkBox_A2_PosInt_Callback(hObject, eventdata, handles)
% hObject    handle to ChkBox_A2_PosInt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

windowSession = gcf;
value = get(hObject,'Value');
windowSession.ContentHandler.SetValue(handles.ChkBox_A2_PosInt,value);


% --- Executes on button press in ChkBox_B1_Ziele.
function ChkBox_B1_Ziele_Callback(hObject, eventdata, handles)
% hObject    handle to ChkBox_B1_Ziele (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

windowSession = gcf;
value = get(hObject,'Value');
windowSession.ContentHandler.SetValue(handles.ChkBox_B1_Ziele,value);


% --- Executes on button press in ChkBox_B1_Los.
function ChkBox_B1_Los_Callback(hObject, eventdata, handles)
% hObject    handle to ChkBox_B1_Los (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
windowSession = gcf;
value = get(hObject,'Value');
windowSession.ContentHandler.SetValue(handles.ChkBox_B1_Los,value);


% --- Executes on button press in ChkBox_B1_Wahl.
function ChkBox_B1_Wahl_Callback(hObject, eventdata, handles)
% hObject    handle to ChkBox_B1_Wahl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
windowSession = gcf;
value = get(hObject,'Value');
windowSession.ContentHandler.SetValue(handles.ChkBox_B1_Wahl,value);


% --- Executes when selected object is changed in Grp_B1_Inhalt.
function Grp_B1_Inhalt_SelectionChangedFcn(rbtn_handle, eventdata, handles)
% hObject    handle to the selected object in Grp_B1_Inhalt 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
windowSession = gcf;
value = get_value(rbtn_handle);
windowSession.ContentHandler.SetValue(handles.Grp_B1_Inhalt,value);


% --- Executes on button press in ChkBox_C1_Met.
function ChkBox_C1_Met_Callback(hObject, eventdata, handles)
% hObject    handle to ChkBox_C1_Met (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
windowSession = gcf;
value = get(hObject,'Value');
windowSession.ContentHandler.SetValue(handles.ChkBox_C1_Met,value);


% --- Executes on button press in ChkBox_C1_Aus.
function ChkBox_C1_Aus_Callback(hObject, eventdata, handles)
% hObject    handle to ChkBox_C1_Aus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
windowSession = gcf;
value = get(hObject,'Value');
windowSession.ContentHandler.SetValue(handles.ChkBox_C1_Aus,value);


% --- Executes on button press in ChkBox_C1_Abw.
function ChkBox_C1_Abw_Callback(hObject, eventdata, handles)
% hObject    handle to ChkBox_C1_Abw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
windowSession = gcf;
value = get(hObject,'Value');
windowSession.ContentHandler.SetValue(handles.ChkBox_C1_Abw,value);


% --- Executes when selected object is changed in Grp_C1_Inhalt.
function Grp_C1_Inhalt_SelectionChangedFcn(rbtn_handle, eventdata, handles)
% hObject    handle to the selected object in Grp_C1_Inhalt 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
windowSession = gcf;
value = get_value(rbtn_handle);
windowSession.ContentHandler.SetValue(handles.Grp_C1_Inhalt,value);


% --- Executes when selected object is changed in Grp_G3_Res.
function Grp_G3_Res_SelectionChangedFcn(rbtn_handle, eventdata, handles)
% hObject    handle to the selected object in Grp_G3_Res 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
windowSession = gcf;
value = get_value(rbtn_handle);
windowSession.ContentHandler.SetValue(handles.Grp_G3_Res,value);


% --- Executes when selected object is changed in Grp_A_tiefe.
function Grp_A_tiefe_SelectionChangedFcn(rbtn_handle, eventdata, handles)
% hObject    handle to the selected object in Grp_A_tiefe 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
windowSession = gcf;
value = get_value(rbtn_handle);
windowSession.ContentHandler.SetValue(handles.Grp_A_tiefe,value);


% --- Executes when selected object is changed in Grp_B_Therapie.
function Grp_B_Therapie_SelectionChangedFcn(rbtn_handle, eventdata, handles)
% hObject    handle to the selected object in Grp_B_Therapie 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
windowSession = gcf;
value = get_value(rbtn_handle);
windowSession.ContentHandler.SetValue(handles.Grp_B_Therapie,value);

%--- Method to get int value of RadioButtonGroup
function value = get_value(rbtn_handle)
rbtn_tag = char(get(rbtn_handle,'Tag'));
value = str2double(rbtn_tag(end:end));
if(isnan(value))
    value = str2double("-"+rbtn_tag(end-1:end-1));
end
