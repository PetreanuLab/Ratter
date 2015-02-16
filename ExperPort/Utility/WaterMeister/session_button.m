function handles = session_button(S,handles)

global button_state comp CLS running_timer
running_timer = 0;
set(handles.print_button','enable','on');
temp = get(handles.axes1,'children');
for c = 1:length(temp); 
    try delete(temp(c)); end %#ok<TRYNC>
end

set(handles.startstop_toggle,'value',handles.start(S));

button_state(1:7) = 0;

str1 = 'value'; str2 = 'value'; str3 = 'BackgroundColor';%#ok<NASGU>
if eval(['get(handles.session',num2str(S),'_toggle,str1)']) == 1
    button_state(S) = 1;
    eval(['set(handles.marker',num2str(S),',str3,[0 0 0])']);
    button_local    = button_state;
    comp_local      = comp;
    for s = 1:7
        if s ~= S
            eval(['set(handles.session',num2str(s),'_toggle,str2,0);']);
            eval(['set(handles.marker',num2str(s),',str3,[1 1 1])']);
        end
    end
    
    st = handles.starttime(S);
    handles.rats = WM_rat_water_list(S,handles);
    
    if comp(S) == 0
        set(handles.startstop_toggle,'enable','on');

        if ~isnan(st)

            timewait = (now-st)*3600*24; %str2num(datestr(now - st,'SS'));  %#ok<ST2NM>
            set(handles.startstop_toggle,'fontsize',calcfontsize(12,handles),'BackgroundColor',[1 1 0]);
            eval(['set(handles.session',num2str(S),'_toggle,str3,[1 1 0]);']);

            terminate = 0;
            while timewait < handles.waittime(S)
                if any(button_local ~= button_state) || any(comp_local ~= comp) || CLS ~= 0; terminate = 1; break; end
                running_timer = 1; %#ok<NASGU>
                timewait = (now-st)*3600*24; %str2num(datestr(now - st,'SS'));  %#ok<ST2NM>
                set(handles.print_button','enable','off');
                set(handles.startstop_toggle,'string',['Stop in: ',timeremstr(timewait,handles.waittime(S))],'fontsize',calcfontsize(12,handles));
                pause(1);
            end
            set(handles.print_button','enable','on');
            running_timer = 0;
            if terminate == 0
                set(handles.startstop_toggle,'fontsize',calcfontsize(16,handles),'BackgroundColor',[1 0 0],'string','Stop Now');
            end
        else
            if S == 7; set(handles.startstop_toggle,'string','Confirm','fontsize',calcfontsize(22,handles),'BackgroundColor',[0 1 0]);
            else       set(handles.startstop_toggle,'string','Start',  'fontsize',calcfontsize(36,handles),'BackgroundColor',[0 1 0]);
            end
        end
    else
        set(handles.startstop_toggle,'enable','off','fontsize',calcfontsize(20,handles),'BackgroundColor',[0 1 1],'string','Complete');
        eval(['set(handles.session',num2str(S),'_toggle,str3,[0 1 1]);']);
    end
        
else
    button_state(S) = 0;
    eval(['set(handles.marker',num2str(S),',str3,[1 1 1])']);
    set(handles.startstop_toggle,'enable','off','string','Start','fontsize',calcfontsize(36,handles),'BackgroundColor',[0 1 0]);
end

handles.buttons = button_state;
