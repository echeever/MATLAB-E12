function varargout = FourierSeriesPulseGUI(varargin)
% FOURIERSERIESPULSEGUI M-file for FourierSeriesPulseGUI.fig
%      FOURIERSERIESPULSEGUI, by itself, creates a new FOURIERSERIESPULSEGUI or raises the existing
%      singleton*.
%
%      H = FOURIERSERIESPULSEGUI returns the handle to a new FOURIERSERIESPULSEGUI or the handle to
%      the existing singleton*.
%
%      FOURIERSERIESPULSEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FOURIERSERIESPULSEGUI.M with the given input arguments.
%
%      FOURIERSERIESPULSEGUI('Property','Value',...) creates a new FOURIERSERIESPULSEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FourierSeriesPulseGUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FourierSeriesPulseGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FourierSeriesPulseGUI

% Last Modified by GUIDE v2.5 16-Apr-2006 20:10:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @FourierSeriesPulseGUI_OpeningFcn, ...
    'gui_OutputFcn',  @FourierSeriesPulseGUI_OutputFcn, ...
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


% --- Executes just before FourierSeriesPulseGUI is made visible.
function FourierSeriesPulseGUI_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
handles.T=2*pi;
handles.Tp=pi;
handles.TpoverT=handles.Tp/handles.T;
set(handles.T_tag,'String',num2str(handles.T,'%3.2f'));
set(handles.Tp_tag,'String',num2str(handles.Tp,'%3.2f'));
set(handles.TpoverT_tag,'String',num2str(handles.TpoverT,'%3.2f'));
w0=2*pi/handles.T;
set(handles.LockRatio_tag,'Value',0);
set(handles.Normalize_tag,'Value',0);
set(handles.VsOmega_tag,'Value',0);
DrawPlots(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FourierSeriesPulseGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FourierSeriesPulseGUI_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;


function T_tag_Callback(hObject, eventdata, handles)
handles.T=str2double(get(hObject,'String'));
if handles.T<handles.Tp
    handles.T=handles.Tp
end
if handles.T>100
    handles.T=100;
end
if handles.T<1 then
    handles.T=1;
end
set(handles.T_tag,'String',num2str(handles.T,'%3.2f'));
if get(handles.LockRatio_tag,'Value')==1,
    handles.Tp=handles.T*handles.TpoverT;
    set(handles.Tp_tag,'String',num2str(handles.Tp,'%3.2f'));
else
    handles.TpoverT=handles.Tp/handles.T;
    set(handles.TpoverT_tag,'String',num2str(handles.TpoverT,'%3.2f'));
end
guidata(hObject, handles);	% Update handles structure
DrawPlots(handles)


function Tp_tag_Callback(hObject, eventdata, handles)
handles.Tp=str2double(get(hObject,'String'));
if handles.Tp>handles.T
    handles.Tp=handles.T;
    set(handles.Tp_tag,'String',num2str(handles.Tp,'%3.2f'));
end
if get(handles.LockRatio_tag,'Value')==1,
    handles.T=handles.Tp/handles.TpoverT;
    set(handles.T_tag,'String',num2str(handles.T,'%3.2f'));
else
    handles.TpoverT=handles.Tp/handles.T;
    set(handles.TpoverT_tag,'String',num2str(handles.TpoverT,'%3.2f'));
end
guidata(hObject, handles);	% Update handles structure
DrawPlots(handles)


function TpoverT_tag_Callback(hObject, eventdata, handles)
handles.TpOverT=str2double(get(hObject,'String'));
handles.Tp=handles.T*handles.TpOverT;
set(handles.Tp_tag,'String',num2str(handles.Tp,'%3.2f'));
guidata(hObject, handles);	% Update handles structure
DrawPlots(handles)


% --- Executes on button press in LockRatio_tag.
function LockRatio_tag_Callback(hObject, eventdata, handles)

% --- Executes on button press in Normalize_tag.
function Normalize_tag_Callback(hObject, eventdata, handles)
DrawPlots(handles);

% --- Executes on button press in ConstantWidth_Tag.
function VsOmega_tag_Callback(hObject, eventdata, handles)
DrawPlots(handles);


function DrawPlots(handles)
axes(handles.TimeDomain_tag);  cla;
T=handles.T;  Tp=handles.Tp;  MaxT=10;
ncycles=round(MaxT/T)+1;
for n=-ncycles:ncycles,
    plot([n*T-Tp/2 n*T-Tp/2 n*T+Tp/2 n*T+Tp/2],[0 1 1 0],'Linewidth',2);
    hold on;
    plot([n*T+Tp/2 (n+1)*T-Tp/2],[0 0],'Linewidth',2);
end
axis([-10 10 -0.25 1.25]);
xlabel('Time');  ylabel('Pulse function');  title('Time Domain Function');
grid on

axes(handles.Fourier_tag);  cla;
if get(handles.VsOmega_tag,'Value')==1,
    krange=max(round(6*T/Tp),12);
else
    krange=12;
end
k=(-krange:krange)+0.001;  %range of k, add small number to avoid 0/0 situation.
kp=linspace(-krange,krange);
a=(Tp/T)*sin(pi*k*Tp/T)./(pi*k*Tp/T);
akp=(Tp/T)*sin(pi*kp*Tp/T)./(pi*kp*Tp/T);

if get(handles.Normalize_tag,'Value')==1,
    a=a*T/Tp;
    akp=akp*T/Tp;
end
w0=2*pi/T;
if get(handles.VsOmega_tag,'Value')==1,
    stem(k*w0,a,'Linewidth',2);
    xlabel('\omega'); ylabel('c_k (\omega=k\cdot\omega_0)');
    title(['Fourier Series Coefs vs. \omega, ' ...
        '\omega_0=' num2str(w0,'%4.2f')]);
    axis([-krange*w0 krange*w0 -0.25 1.25]);
    hold on
    plot(kp*w0,akp,'r:','Linewidth',1.5);
else
    stem(k,a,'Linewidth',2);
    xlabel('k');  ylabel('c_k');
    title(['Fourier Series Coefs vs. k, '...
        '\omega_0=' num2str(w0,'%4.2f')]);
    axis([-krange krange -0.25 1.25]);
    hold on
    plot(kp,akp,'r:','Linewidth',1.5);
end
grid on


% --- Executes during object creation, after setting all properties.
function TpoverT_tag_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function T_tag_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Tp_tag_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
