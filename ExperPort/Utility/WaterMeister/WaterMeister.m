function varargout = WaterMeister(varargin)
%WATERMEISTER M-file for WaterMeister.fig
%      WATERMEISTER, by itself, creates a new WATERMEISTER or raises the existing
%      singleton*.
%
%      H = WATERMEISTER returns the handle to a new WATERMEISTER or the handle to
%      the existing singleton*.
%
%      WATERMEISTER('Property','Value',...) creates a new WATERMEISTER using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to WaterMeister_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      WATERMEISTER('CALLBACK') and WATERMEISTER('CALLBACK',hObject,...) call the
%      local function named CALLBACK in WATERMEISTER.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help WaterMeister

% Last Modified by GUIDE v2.5 20-Oct-2010 16:49:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @WaterMeister_OpeningFcn, ...
                   'gui_OutputFcn',  @WaterMeister_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end
global CLS running_timer
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
    if CLS ~= 0; if running_timer == 0; delete(CLS); CLS = 0; return; end; end
end
% End initialization code - DO NOT EDIT


% --- Executes just before WaterMeister is made visible.
function WaterMeister_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for WaterMeister
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes WaterMeister wait for user response (see UIRESUME)
% uiwait(handles.figure1);

set(handles.startstop_toggle,'enable','off');
handles.starttime = [nan nan nan nan nan nan nan];
handles.start     = zeros(1,7);
handles.buttons   = zeros(1,7);
handles.fontsize_ratname = 22;
handles.redraw_on_resize = 0;

C = get(gcf,'children');
P = get(gcf,'position');
for c = 1:length(C)
    handles.fontsize(c) = get(C(c),'fontsize');
end
handles.children = C;
handles.size = P(3:4);
handles.currsize = P(3:4);

try load('C:\ratter\ExperPort\Utility\WaterMeister\waittimes.mat');
catch; WT = [1800 1800 1800 1800 1800 1800]; %#ok<CTCH>
end
handles.waittime = WT;
handles.use_tables = 1;

global button_state comp CLS running_timer
button_state = zeros(1,8);
comp = zeros(1,7);
CLS = 0;
running_timer = 0;

if handles.use_tables == 1
    handles = init_check(handles);
end

set(handles.date_text,'string',datestr(now,29));

guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = WaterMeister_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in session1_toggle.
function session1_toggle_Callback(hObject, eventdata, handles)

global CLS running_timer
handles = session_button(1,handles);
if CLS ~= 0; delete(CLS); CLS = 0; running_timer = 0; return; end
guidata(hObject, handles);


% --- Executes on button press in session2_toggle.
function session2_toggle_Callback(hObject, eventdata, handles)

global CLS running_timer
handles = session_button(2,handles);
if CLS ~= 0; delete(CLS); CLS = 0; running_timer = 0; return; end
guidata(hObject, handles);

% --- Executes on button press in session3_toggle.
function session3_toggle_Callback(hObject, eventdata, handles)

global CLS running_timer
handles = session_button(3,handles);
if CLS ~= 0; delete(CLS); CLS = 0; running_timer = 0; return; end
guidata(hObject, handles);

% --- Executes on button press in session4_toggle.
function session4_toggle_Callback(hObject, eventdata, handles)

global CLS running_timer
handles = session_button(4,handles);
if CLS ~= 0; delete(CLS); CLS = 0; running_timer = 0; return; end
guidata(hObject, handles);


% --- Executes on button press in session5_toggle.
function session5_toggle_Callback(hObject, eventdata, handles)

global CLS running_timer
handles = session_button(5,handles);
if CLS ~= 0; delete(CLS); CLS = 0; running_timer = 0; return; end
guidata(hObject, handles);


% --- Executes on button press in session6_toggle.
function session6_toggle_Callback(hObject, eventdata, handles)

global CLS running_timer
handles = session_button(6,handles);
if CLS ~= 0; delete(CLS); CLS = 0; running_timer = 0; return; end
guidata(hObject, handles);


% --- Executes on button press in startstop_toggle.
function startstop_toggle_Callback(hObject, eventdata, handles)

set(handles.startstop_toggle,'enable','off');

initials = get(handles.initials_edit,'string');
if isempty(initials)
    initials = inputdlg('Enter Your Initials:','',1);
    if isempty(initials) || isempty(initials{1}); set(handles.startstop_toggle,'value',~get(handles.startstop_toggle,'value')); return; end
    set(handles.initials_edit,'string',initials{1});
    initials = initials{1};
end

global button_state comp CLS running_timer
running_timer = 0;
set(handles.print_button','enable','on');
S = find(button_state(1:7) == 1);
button_state(8) = get(handles.startstop_toggle,'value');
button_local = button_state;
comp_local   = comp;
    
str3 = 'BackgroundColor'; %#ok<NASGU>
if get(handles.startstop_toggle,'value') == 1
    if S < 7
        handles.start(S) = 1;

        st = handles.starttime(S);
        if isnan(st); handles.starttime(S) = now; end
        st = handles.starttime(S);
        guidata(hObject, handles);

        timewait = (now - st) * 3600 * 24; %str2num(datestr(now - st,'SS')); %#ok<ST2NM>
        set(handles.startstop_toggle,'fontsize',calcfontsize(12,handles),'BackgroundColor',[1 1 0]);
        eval(['set(handles.session',num2str(S),'_toggle,str3,[1 1 0]);']);
        WT = handles.waittime(S);
    else
        st = now; 
    end
    
    pause(0.1);
    if handles.use_tables == 1
        for r = 1:length(handles.rats)
            mym(bdata,'INSERT INTO ratinfo.water (date, rat, tech, starttime, stoptime) values ("{S}","{S}","{S}","{S}","{S}")',...
                datestr(st,29),handles.rats{r},initials,datestr(st,13),datestr(st,13));
        end
    end
    if S == 7
        comp(S) = 1;
        set(handles.startstop_toggle,'fontsize',calcfontsize(20,handles),'BackgroundColor',[0 1 1],'string','Complete','enable','off');
        eval(['set(handles.session',num2str(S),'_toggle,str3,[0 1 1]);']);
        return
    end
    
    terminate = 0;
    while timewait < WT
        running_timer = 1; %#ok<NASGU>
        set(handles.print_button','enable','off');
        if any(button_local ~= button_state) || any(comp_local ~= comp) || CLS ~= 0; terminate = 1; break; end
        
        timewait = (now - st) * 3600 * 24; %str2num(datestr(now - st,'SS')); %#ok<ST2NM>
        set(handles.startstop_toggle,'string',['Stop in: ',timeremstr(timewait,handles.waittime(S))],'fontsize',calcfontsize(12,handles));
        pause(1);
    end
    set(handles.print_button','enable','on');
    running_timer = 0;
    if terminate == 0
        set(handles.startstop_toggle,'fontsize',calcfontsize(16,handles),'BackgroundColor',[1 0 0],'string','Stop Now');
    end
    if CLS ~= 0
        delete(CLS); CLS = 0; running_timer = 0;
        pause(5);
        set(handles.startstop_toggle,'enable','on');
        return;
    end
else
    handles.start(S) = 0;
    comp(S)  = 1;
    set(handles.startstop_toggle,'fontsize',calcfontsize(20,handles),'BackgroundColor',[0 1 1],'string','Complete','enable','off');
    eval(['set(handles.session',num2str(S),'_toggle,str3,[0 1 1]);']);
    pause(0.1);
    if handles.use_tables == 1
        stoptime = datestr(now,13);
        for r = 1:length(handles.rats)
            mym(bdata,'call ratinfo.update_water_tbl ("{S}","{S}","{S}")',...
                handles.rats{r},datestr(handles.starttime(S),29),stoptime);
        end
    end
end

pause(5);
set(handles.startstop_toggle,'enable','on');

guidata(hObject, handles);


function initials_edit_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function initials_edit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in session7_toggle.
function session7_toggle_Callback(hObject, eventdata, handles)

global CLS running_timer
handles = session_button(7,handles);
if CLS ~= 0; delete(CLS); CLS = 0; running_timer = 0; return; end
guidata(hObject, handles);


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)

try %#ok<TRYNC>
    global button_state CLS running_timer %#ok<TLEV>
    
    P = get(gcf,'position');
    %C = get(gcf,'children');
    C = handles.children;
    tempR = P(3:4) ./ handles.size;
    
    R = tempR(find(abs(log(tempR)) == min(abs(log(tempR))),1,'first'));

    if find(tempR == R) == 2
        set(handles.axes1,'ylim',[0 75]);
        temp = (100 * (max(tempR) / min(tempR))) - 100;
        set(handles.axes1,'xlim',[-temp/2, 100+(temp/2)]);
    else
        set(handles.axes1,'xlim',[0 100]);
        temp = (75 * (max(tempR) / min(tempR))) - 75;
        set(handles.axes1,'ylim',[-temp/2, 75+(temp/2)]);
    end

    for c = 1:length(C)
        if strcmp(get(C(c),'tag'),'startstop_toggle')
            str = get(C(c),'string');
            if     strcmp(str,     'Start');    set(C(c),'fontsize',36*R);
            elseif strcmp(str(1:8),'Stop in:'); set(C(c),'fontsize',12*R);
            elseif strcmp(str(1:8),'Stop Now'); set(C(c),'fontsize',16*R);
            elseif strcmp(str(1:8),'Complete'); set(C(c),'fontsize',20*R);    
            end
        else
            set(C(c),'fontsize',handles.fontsize(c)*R);
        end
    end
    C = get(handles.axes1,'children');
    for c = 1:length(C)
        try set(C(c),'fontsize',handles.fontsize_ratname*R); end %#ok<TRYNC>
    end

    handles.currsize = P(3:4);
    guidata(hObject, handles);
    
    if isfield(handles,'redraw_on_resize') && handles.redraw_on_resize == 1
        temp = find(button_state(1:7) == 1,1,'first');
        if ~isempty(temp); handles = session_button(temp,handles); end
        if CLS ~= 0; delete(CLS); CLS = 0; running_timer = 0; return; end
        guidata(hObject, handles);
    end
end

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)

global CLS
CLS = handles.figure1;



% --- Executes on button press in print_button.
function print_button_Callback(hObject, eventdata, handles)

cp_old = get(gcf,'position');
size_old = handles.size;
set(gcf,'paperunits','inches');
set(gcf,'paperposition',[0.25 0.25 10.5 8]);
set(gcf,'units','points','paperunits','points')
cp = get(gcf,'position');
pp = get(gcf,'paperposition');

handles.currsize = cp(3:4);
handles.size = handles.size * (cp(3) / cp_old(3));
handles.redraw_on_resize = 1;
guidata(hObject, handles);

pause(0.1);
set(gcf,'position',[20 20 pp(3) pp(4)]);
orient landscape

saveas(gcf,'C:\WaterMeisterFigure_temp.fig'); pause(0.1);
!matlab -r "print_WM_figure"

set(gcf,'units','pixels','paperunits','inches');
cp = get(gcf,'position');
handles.currsize = cp(3:4);
handles.size = size_old;

guidata(hObject, handles);
pause(0.1);
set(gcf,'position',cp_old);
pause(0.1);
handles.redraw_on_resize = 0;
guidata(hObject, handles);




% --- Executes on button press in watertime_button.
function watertime_button_Callback(hObject, eventdata, handles) %#ok<DEFNU,INUSL>

global button_state
S = find(button_state(1:6) == 1);
if ~isempty(S)
    wt = handles.waittime(S);
    h = floor(wt / 3600); wt = wt - (3600 * h);
    m = floor(wt / 60);
    
    nwt = inputdlg({'Water Duration Hours:','Water Duration Minutes:'},...
        ['Session ',num2str(S)],1,{num2str(h),num2str(m)});
    if isempty(nwt); return; end
    wt = (str2num(nwt{1}) * 3600) + (str2num(nwt{2}) * 60); %#ok<ST2NM>
    handles.waittime(S) = wt;
    
    WT = handles.waittime; %#ok<NASGU>
    try
        save('C:\ratter\ExperPort\Utility\WaterMeister\waittimes.mat','WT');
    catch
        disp('Could not save new water duration...');
    end
    guidata(hObject, handles);
end


