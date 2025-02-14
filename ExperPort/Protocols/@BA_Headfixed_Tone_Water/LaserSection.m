
function  [x, y, StimOrNot, OffDur, OnDur, OnEvent, OffEvent, OnTime, OffTime, ...
    OffDur_Mask, OnDur_Mask, OnEvent_Mask, OffEvent_Mask, OnTime_Mask, OffTime_Mask] ...
    =  LaserSection(obj,action, x,  y)

GetSoloFunctionArgs;

% Deals with sound generation and uploading to RTLSoundMachine

switch action,
    case 'init'
        ToggleParam(obj, 'ToggleLaserParam', 1, x, y, ...
            'OffString', 'LaserParams hidden', 'OnString', 'LaserParams showing');next_row(y);
        set_callback(ToggleLaserParam, {'LaserSection', 'toggle'});
        
        fig=gcf; %main figure of Masa_Wighholding protocol
        oldx=x; oldy=y;
        
        %new figure for beginner parameters for nose poke block
        x=1; y=1;
        SoloParamHandle(obj, 'myfig', 'value', figure, 'saveable',0);
        set(value(myfig),'Position',[300 100 830 200], ...
            'Visible', 'on', 'MenuBar', 'none', 'Name', 'LaserParams', ...
            'NumberTitle', 'off', 'CloseRequestFcn', ...
            ['LaserSection(' class(obj) ', ''hide_laser_params'')']);   
        
        NumeditParam(obj, 'Amplitude1',  5,  x, y);   next_row(y);       
        NumeditParam(obj, 'Frequency1',  20,  x, y);   next_row(y);
        NumeditParam(obj, 'PulseDur1',   0.005,  x, y);   next_row(y);
        NumeditParam(obj, 'OffTime_from_RefEvent1',   0,  x, y);   next_row(y);
        MenuParam(obj, 'Off_RefEvent1', {'TrialStart','CPokeIn','CPokeOut'}, 3, x, y);next_row(y);
        NumeditParam(obj, 'OnTime_from_RefEvent1',   .001,  x, y);   next_row(y);
        MenuParam(obj, 'On_RefEvent1', {'TrialStart','CPokeIn'}, 2, x, y);next_row(y);
        NumeditParam(obj, 'NumTrialInBlock1', 2, x, y);  next_row(y);
        SubheaderParam(obj, 'SubheaderStimParam1','Stim. Param. 1',x,y); next_row(y);
        DispParam(obj, 'StimProtocol', 'No Stim', x, y); next_row(y);
        
        next_column(x),y = 1;
        
        NumeditParam(obj, 'Amplitude2',  5,  x, y);   next_row(y);       
        NumeditParam(obj, 'Frequency2',  20,  x, y);   next_row(y);
        NumeditParam(obj, 'PulseDur2',   0.005,  x, y);   next_row(y);
        NumeditParam(obj, 'OffTime_from_RefEvent2',   0,  x, y);   next_row(y);
        MenuParam(obj, 'Off_RefEvent2', {'TrialStart','CPokeIn','CPokeOut'}, 3, x, y);next_row(y);
        NumeditParam(obj, 'OnTime_from_RefEvent2',   .45,  x, y);   next_row(y);
        MenuParam(obj, 'On_RefEvent2', {'TrialStart','CPokeIn'}, 2, x, y);next_row(y);
        NumeditParam(obj, 'NumTrialInBlock2', 2, x, y);  next_row(y);
        SubheaderParam(obj, 'SubheaderStimParam2','Stim. Param. 2',x,y); next_row(y);
        
        NumeditParam(obj, 'LaserBlock', 12, x, y);
                
        next_column(x),y = 1;
        
        NumeditParam(obj, 'Amplitude3',  5,  x, y);   next_row(y);       
        NumeditParam(obj, 'Frequency3',  20,  x, y);   next_row(y);
        NumeditParam(obj, 'PulseDur3',   0.005,  x, y);   next_row(y);
        NumeditParam(obj, 'OffTime_from_RefEvent3',   0,  x, y);   next_row(y);
        MenuParam(obj, 'Off_RefEvent3', {'TrialStart','CPokeIn','CPokeOut'}, 3, x, y);next_row(y);
        NumeditParam(obj, 'OnTime_from_RefEvent3',   0,  x, y);   next_row(y);
        MenuParam(obj, 'On_RefEvent3', {'TrialStart','CPokeIn'}, 2, x, y);next_row(y);
        NumeditParam(obj, 'NumTrialInBlock3', 2, x, y);  next_row(y);
        SubheaderParam(obj, 'SubheaderStimParam3','Stim. Param. 3',x,y); next_row(y);
        
        next_column(x),y = 1;
        
        next_row(y); %skip amplitude
        NumeditParam(obj, 'Frequency_Mask',  20,  x, y);   next_row(y);
        NumeditParam(obj, 'PulseDur_Mask',   0.005,  x, y);   next_row(y);
        NumeditParam(obj, 'OffTime_from_RefEvent_Mask',   0,  x, y);   next_row(y);
        MenuParam(obj, 'Off_RefEvent_Mask', {'TrialStart','CPokeIn','CPokeOut', 'TimeOut'}, 3, x, y);next_row(y);
        NumeditParam(obj, 'OnTime_from_RefEvent_Mask',   1,  x, y);   next_row(y);
        MenuParam(obj, 'On_RefEvent_Mask', {'TrialStart','CPokeIn'}, 2, x, y);next_row(y);
        next_row(y); %skip NumTrialInBlock
        SubheaderParam(obj, 'SubheaderStimParamMask','Mask. Param.',x,y); next_row(y);
                
        SoloParamHandle(obj, 'StimOrNot', 'value', 0); %0:Off; 1:On
        SoloParamHandle(obj, 'OffDur', 'value', 0.1);
        SoloParamHandle(obj, 'OnDur', 'value', 0.1);
        SoloParamHandle(obj, 'OnEvent', 'value', 'CenterPokeIn');
        SoloParamHandle(obj, 'OffEvent', 'value', 'CenterPokeOut');
        SoloParamHandle(obj, 'OnTime', 'value', 0);
        SoloParamHandle(obj, 'OffTime', 'value', 0);
        SoloParamHandle(obj, 'OffDur_Mask', 'value', 0.1);
        SoloParamHandle(obj, 'OnDur_Mask', 'value', 0.1);
        SoloParamHandle(obj, 'OnEvent_Mask', 'value', 'CenterPokeIn');
        SoloParamHandle(obj, 'OffEvent_Mask', 'value', 'CenterPokeOut');
        SoloParamHandle(obj, 'OnTime_Mask', 'value', 0);
        SoloParamHandle(obj, 'OffTime_Mask', 'value', 0);
        
        SoloParamHandle(obj, 'Counter', 'value', 1);
        SoloParamHandle(obj, 'BlockMatrix', 'value', randperm(value(LaserBlock)));
        
        set_callback({NumTrialInBlock1, NumTrialInBlock2, NumTrialInBlock3, LaserBlock}, ...
            {'LaserSection', 'reset_laser_block'});
        
        figure(fig);
        x = oldx; y = oldy;
        
        LaserSection(obj, 'prepare_next_trial');

    case 'prepare_next_trial'
        %%% stim %%%
        member1 = 1:value(NumTrialInBlock1);
        member2 = value(NumTrialInBlock1)+(1:value(NumTrialInBlock2));
        member3 = value(NumTrialInBlock1)+value(NumTrialInBlock2)+(1:value(NumTrialInBlock3));
        
        counter = value(Counter);
        block_matrix = value(BlockMatrix);
        
        if ismember(block_matrix(counter), member1)
            if value(Amplitude1)==0||value(Frequency1)==0||value(PulseDur1)==0
                StimOrNot.value =  0;
                StimProtocol.value = 'No stim';
            else
                StimOrNot.value =  1;
                StimProtocol.value = 'Stim 1';
                OffDur.value = 1/value(Frequency1)-value(PulseDur1);
                OnDur.value = value(PulseDur1);
                OnEvent.value = value(On_RefEvent1);
                OffEvent.value = value(Off_RefEvent1);
                OnTime.value = value(OnTime_from_RefEvent1);
                OffTime.value = value(OffTime_from_RefEvent1);
            end
        elseif ismember(block_matrix(counter), member2)
            if value(Amplitude2)==0||value(Frequency2)==0||value(PulseDur2)==0
                StimOrNot.value =  0;
                StimProtocol.value = 'No stim';
            else
                StimOrNot.value =  1;
                StimProtocol.value = 'Stim 2';
                OffDur.value = 1/value(Frequency2)-value(PulseDur2);
                OnDur.value = value(PulseDur2);
                OnEvent.value = value(On_RefEvent2);
                OffEvent.value = value(Off_RefEvent2);
                OnTime.value = value(OnTime_from_RefEvent2);
                OffTime.value = value(OffTime_from_RefEvent2);
            end
        elseif ismember(block_matrix(counter), member3)
            if value(Amplitude3)==0||value(Frequency3)==0||value(PulseDur3)==0
                StimOrNot.value =  0;
                StimProtocol.value = 'No stim';
            else
                StimOrNot.value =  1;
                StimProtocol.value = 'Stim 3';
                OffDur.value = 1/value(Frequency3)-value(PulseDur3);
                OnDur.value = value(PulseDur3);
                OnEvent.value = value(On_RefEvent3);
                OffEvent.value = value(Off_RefEvent3);
                OnTime.value = value(OnTime_from_RefEvent3);
                OffTime.value = value(OffTime_from_RefEvent3);
            end
        else
            StimOrNot.value =  0;
            StimProtocol.value = 'No stim';
        end
        
        Counter.value = counter+1;
        
        if value(Counter)>value(LaserBlock)
            BlockMatrix.value = randperm(value(LaserBlock));
            Counter.value = 1;
        end

        %%% Mask %%%
        OffDur_Mask.value = 1/value(Frequency_Mask)-value(PulseDur_Mask);
        OnDur_Mask.value = value(PulseDur_Mask);
        OnEvent_Mask.value = value(On_RefEvent_Mask);
        OffEvent_Mask.value = value(Off_RefEvent_Mask);
        OnTime_Mask.value = value(OnTime_from_RefEvent_Mask);
        OffTime_Mask.value = value(OffTime_from_RefEvent_Mask);
        

    case 'toggle'
        if value(ToggleLaserParam)==0
                set(value(myfig), 'Visible', 'off');
        elseif value(ToggleLaserParam)==1
                set(value(myfig), 'Visible', 'on');
        end;
        
    case 'hide_laser_params'
        set(value(myfig),'Visible','off');
        ToggleLaserParam.value = 0;
        
    case 'reset_laser_block'
        BlockMatrix.value = randperm(value(LaserBlock));
        Counter.value = 1;
        
    case 'close'
        if exist('myfig', 'var') && isa(myfig, 'SoloParamHandle') && ishandle(value(myfig)),
            delete(value(myfig));
        end;
        
    otherwise
        error(['Don''t know how to handle action ' action]);
end;

        value(StimOrNot)
        value(StimProtocol)
return;

