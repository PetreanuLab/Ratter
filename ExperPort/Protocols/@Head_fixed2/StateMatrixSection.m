
%function [ output_args ] = StateMatrixSection_comented( input_args )
%STATEMATRIXSECTION_COMENTED Summary of this function goes here
%   Detailed explanation goes here

% Typical section code-- this file may be used as a template to be added
% on to. The code below stores the current figure and initial position when
% the action is 'init'; and, upon 'reinit', deletes all SoloParamHandles
% belonging to this section, then calls 'init' at the proper GUI position
% again.


% [x, y] = YOUR_SECTION_NAME(obj, action, x, y)
%
% Section that takes care of YOUR HELP DESCRIPTION
%
% PARAMETERS:
% -----------
%
% obj      Default object argument.
%
% action   One of:
%            'init'      To initialise the section and set up the GUI
%                        for it
%
%            'reinit'    Delete all of this section's GUIs and data,
%                        and reinit, at the same position on the same
%                        figure as the original section GUI was placed.
%
% x, y     Relevant to action = 'init'; they indicate the initial
%          position to place the GUI at, in the current figure window
%
% RETURNS:
% --------
%
% [x, y]   When action == 'init', returns x and y, pixel positions on
%          the current figure, updated after placing of this section's GUI.
%


function sma = StateMatrixSection(obj, action)

%declare here the globals that you want the stateMatrixSection
%to have access to, usually these are declared in the Settings_Custom.conf
%Declare var's in Protocol file as globals and initialize them,
%the%GetSoloFunctionArgs should get them!!
% stimulation coordinates
persistent lastz;
persistent rnum
if isempty( lastz),   lastz = 0; end % initialization
if isempty( rnum),   lastz = 1; end % initialization

% coord = [1 2; % coord in mm  +X is LEFt + Y is Anterior, +Z is up
%          0 0] ;
% coordz = [1 2 -1.0;
%     0 0 3;]
% 108428	53000	-66256
coord = [0 0; 0 2.5;] ;
coordz = [0 0 0; 0 2.5 -1.3];
bScientifica = 1;
% coord = [9 8;] ;
% coordz = [9 8 2;];
GetSoloFunctionArgs;
global id
 


switch action
    % % %----INIT----------------------------------------------------------------%
    case 'init',
        
        
        StateMatrixSection(obj, 'next_trial');
        % % %----NEXT TRIAL----------------------------------------------------------------%
    case 'next_trial',
        
        if bScientifica
            % % Move Scientifica
            rnum = randi(size(coord,1));
            %         if rnum==1, rnum = 2, else rnum = 1; end
            thistrial_coord = coord(rnum,:) ;
            thistrial_coordz = coordz(rnum,:) ;
            
            if lastz > thistrial_coordz(3) % make sure
                setCoord_SCI(id,thistrial_coord);
            else
                setCoord_SCI(id,thistrial_coordz);
            end
        else
            thistrial_coord = [NaN NaN NaN];
            thistrial_coordz = [NaN NaN NaN];
        end
        %Declare != state matrixs here!! if something, this sma, if something else
        %then this other, if even somthing else, use this sma, while somthing, for
        %something, etc etc etc you get the pic.

        sma = StateMachineAssembler('full_trial_structure');




        % If using scheduled waves, they have to be declared here, before the
        % states
        % IMPORTANT: the first state declared is state_0.
        % Default inputs: Lin: left line in; Lout: left line out; Rin, Rout;
        % Cin; Cout; Tup;
        %------------------------------schedule waves----------------------
        fsm_rate = 6000;


        %-----------------------------------------------
        %--- STATE MATRIX VARIABLES --------------------
        %-----------------------------------------------
        %-----------------------------------------------

        %odor variables
        SoloParamHandle(obj, 'odor_bank_C', 'value', 'OlfBankC');
        SoloParamHandle(obj, 'odor_bank_H', 'value', 'OlfBankH');


        %BRING OLFACTOMETER INFO TO STATE MATRIX
        %-------------------------------------------------------------------------%
        sma = add_olf_bank(sma, 'name', 'OlfBankC', 'ip',...
            value(OLF_IP), 'bank', ['Bank' num2str(value(olf_bank_C_ID))]);
        sma = add_olf_bank(sma, 'name', 'OlfBankH', 'ip',...
            value(OLF_IP), 'bank', ['Bank' num2str(value(olf_bank_H_ID))]);
        %-------------------------------------------------------------------------%

        sma = add_scheduled_wave(sma, 'name', 'dio_trial_start', 'preamble', 0, 'sustain', ...
            0.1, 'DOut', Settings('get', 'DIOLINES','olf_acute_dio'));

        sma = add_scheduled_wave(sma, 'name', 'dio_poke_led', 'preamble', 0, 'sustain',0.2,'DOut', Settings('get', 'DIOLINES','HF1led'));

        odor_list(n_done_trials+1:n_done_trials+10)
        curr_odor=odor_list(n_done_trials+1);
        eval(strcat('curr_trial=','odorType',num2str(curr_odor)));

        odor_delay=value(timeToOdorMin)+(value(timeToOdorMax)-value(timeToOdorMin))*rand;
        odor_dur=value(odorDur);
        wait_dur=value(timeAfterOdor);
        ITI_dur=value(timeITI)+randn*value(SDITI);
        ITI_dur= min(max(abs(ITI_dur),3),10);% BA rectify(ITI_dur,3,10);

         photostimulationCoordX.value=double(thistrial_coord(1));
         photostimulationCoordY.value=double(thistrial_coord(2));
         photostimulationCoordZ.value=double(thistrial_coordz(3));

%l
        switch curr_trial
            case 'neutral'
                after_wait_dur=value(NeutralMeanTime)+randn*value(NeutralSDTime);
                after_wait_dur=min(max(abs(after_wait_dur),0.1),8);% rectify(after_wait_dur,0.1,8);
                light_amp=value(Neutral_light_amplitude);
                light_freq=value(Neutral_light_frequency);
                light_pulse_dur=value(Neutral_light_pulse_duration);
                light_IPI=1/light_freq-light_pulse_dur;
                light_train_dur=value(Neutral_light_train_duration);
                light_train_delay=value(Neutral_light_train_delay);
                light_flag=value(Neutral_light_prob)>rand;
                if ~light_flag;light_amp=0;end
                starting_state=value(Neutral_start_state);
                if strcmp(starting_state,'random');
                    Neutral_start_state.value=round(rand)+1;
                    starting_state=value(Neutral_start_state);
                    Neutral_start_state.value=3;
                end
            case 'go'
                timeToLick=value(GoMeanTime)+randn*value(GoSDTime);
                timeToLick=min(max(abs(timeToLick),0.1),8);%rectify(timeToLick,0.1,8);
                water_dur=value(GoWaterValve);
                light_amp=value(Go_light_amplitude);
                light_freq=value(Go_light_frequency);
                light_pulse_dur=value(Go_light_pulse_duration);
                light_IPI=1/light_freq-light_pulse_dur;
                light_train_dur=value(Go_light_train_duration);
                light_train_delay=value(Go_light_train_delay);
                light_flag=value(Go_light_prob)>rand;
                if ~light_flag;light_amp=0;end
                starting_state=value(Go_start_state);
                if strcmp(starting_state,'random');
                    Go_start_state.value=round(rand)+1
                    starting_state=value(Go_start_state);
                    Go_start_state.value=3;
                end
            case 'nogo'
                timeToAvoidLicking=value(NoGoMeanTime)+randn*value(NoGoSDTime);
                timeToAvoidLicking= min(max(abs(timeToAvoidLicking),0.1),8);% rectify(timeToAvoidLicking,0.1,8);
                tone_dur=value(NoGoSoundDur);
                puff_dur=value(NoGoPuffDur);
                light_amp=value(NoGo_light_amplitude);
                light_freq=value(NoGo_light_frequency);
                light_pulse_dur=value(NoGo_light_pulse_duration);
                light_IPI=1/light_freq-light_pulse_dur;
                light_train_dur=value(NoGo_light_train_duration);
                light_train_delay=value(NoGo_light_train_delay);
                light_flag=value(NoGo_light_prob)>rand;
                
                if ~light_flag;light_amp=0;end
                starting_state=value(NoGo_start_state);
                if strcmp(starting_state,'random');
                    NoGo_start_state.value=round(rand)+1
                    starting_state=value(NoGo_start_state);
                    NoGo_start_state.value=3;
                end
            case 'wait'
                timeToAvoidLicking=value(WaitingMeanTime)+randn*value(WaitingSDTime);
                timeToAvoidLicking=min(max(abs(timeToAvoidLicking),0.1),8);
                water_dur=value(WaitingWaterValve);
                light_amp=value(Wait_light_amplitude);
                light_freq=value(Wait_light_frequency);
                light_pulse_dur=value(Wait_light_pulse_duration);
                light_IPI=1/light_freq-light_pulse_dur;
                light_train_dur=value(Wait_light_train_duration);
                light_train_delay=value(Wait_light_train_delay);
                light_flag=value(Wait_light_prob)>rand;
                if ~light_flag;light_amp=0;end
                starting_state=value(Wait_start_state);
                if strcmp(starting_state,'random');
                    Wait_start_state.value=round(rand)+1;
                    starting_state=value(Wait_start_state);
                    Wait_start_state.value=3;
                end
            case 'active avoid'
                timeToLick=value(AAMeanTime)+randn*value(AASDTime);
                timeToLick=min(max(abs(timeToLick),0.1),8);
                tone_dur=value(AASoundDur);
                puff_dur=value(AAPuffDur);
                light_amp=value(AA_light_amplitude);
                light_freq=value(AA_light_frequency);
                light_pulse_dur=value(AA_light_pulse_duration);
                light_IPI=1/light_freq-light_pulse_dur;
                light_train_dur=value(AA_light_train_duration);
                light_train_delay=value(AA_light_train_delay);
                light_flag=value(AA_light_prob)>rand;
                if ~light_flag;light_amp=0;end
                starting_state=value(AA_start_state);
                if strcmp(starting_state,'random');
                    AA_start_state.value=round(rand)+1;
                    starting_state=value(AA_start_state);
                    AA_start_state.value=3;
                end
        end
        
        switch starting_state
            case 'wait_4_odor'
                light_delay=0+value(light_train_delay);
            case 'odor_valve_on'
                light_delay=odor_delay+value(light_train_delay);
            case 'wait_4_lick'
                light_delay=odor_delay+odor_dur+wait_dur+value(light_train_delay);
        end
        
        %         add_scheduled_wave(sma, 'name', 'ao_trigger1_mask', 'preamble', light_delay,...
        %             'sustain', light_pulse_dur, 'loop',0, 'trigger_on_up', 'ao_trigger2_mask');
        sma = add_scheduled_wave(sma, 'name', 'trigger1_mask', 'preamble', light_delay,...
            'sustain', light_pulse_dur, 'loop',0, 'trigger_on_up', 'trigger2_mask');
        
        photostimulation.value=double(light_flag);
        if light_flag
            sma = add_scheduled_wave(sma, 'name', 'ao_trigger1', 'preamble', light_delay,...
                'sustain', light_pulse_dur, 'loop',0, 'trigger_on_up', 'ao_trigger2');
        else
            sma = add_scheduled_wave(sma, 'name', 'ao_trigger1', 'preamble', light_delay,...
                'sustain', light_pulse_dur, 'loop',0);
        end
        
        
        
        light_IPI
        if  light_IPI>0 % pulsing
            sma = add_scheduled_wave(sma, 'name', 'ao_trigger2', 'preamble', 0,...
                'sustain', (light_IPI+light_pulse_dur), 'loop',light_train_dur/(light_IPI+light_pulse_dur), 'trigger_on_up', 'ao_laser');
            sma = add_scheduled_wave(sma, 'name', 'ao_laser', 'preamble', 0, 'sustain',light_pulse_dur,'DOut', Settings('get', 'DIOLINES','HF1laser'));
            
            % mask
            sma = add_scheduled_wave(sma, 'name', 'trigger2_mask', 'preamble', 0,...
                'sustain', (light_IPI+light_pulse_dur), 'loop',light_train_dur/(light_IPI+light_pulse_dur), 'trigger_on_up', 'ao_mask');
            sma = add_scheduled_wave(sma, 'name', 'ao_mask', 'preamble', 0, 'sustain',light_pulse_dur,'DOut', Settings('get', 'DIOLINES','HF1mask'));
            
        else % continuous
            sma = add_scheduled_wave(sma, 'name', 'ao_trigger2', 'preamble', 0,...
                'sustain', .5,'loop',0, 'trigger_on_up', 'ao_laser');
            sma = add_scheduled_wave(sma, 'name', 'ao_laser', 'preamble', 0, 'sustain',light_pulse_dur,'DOut', Settings('get', 'DIOLINES','HF1laser'));
            % mask
            sma = add_scheduled_wave(sma, 'name', 'trigger2_mask', 'preamble', 0,...
                'sustain', .5,'loop',0, 'trigger_on_up', 'ao_mask');
            sma = add_scheduled_wave(sma, 'name', 'ao_mask', 'preamble', 0, 'sustain',light_pulse_dur,'DOut', Settings('get', 'DIOLINES','HF1mask'));
        end
        %             [light_amp*ones(1,light_pulse_dur*fsm_rate);zeros(1,light_pulse_dur*fsm_rate)]);

        %-------------------------------------------------------------------------%
        %COMMON STATES
        %-------------------------------------------------------------------------%

        % Waiting for odor

        sma = add_state(sma, 'name', 'wait_4_odor', ...
            'output_actions', {'SchedWaveTrig','dio_poke_led+dio_trial_start+ao_trigger1+trigger1_mask', 'SoundOut',value(IdNoise)},...
            'self_timer', odor_delay, ...
            'input_to_statechange', {'Tup','odor_valve_on'});

        % Odor Valve On - Waiting for Go Signal

        sma= add_state(sma,'name','odor_valve_on',...
            'self_timer', odor_dur,...
            'output_actions',{value(odor_bank_C),curr_odor,'SchedWaveTrig','-dio_poke_led'},...
            'input_to_statechange',{'Tup','wait'});

        %% -------------*** different trial types ***--------------
        switch curr_trial
            case 'neutral'
                sma= add_state(sma,'name','wait',...
                    'self_timer', wait_dur,...
                    'input_to_statechange',{'Tup','after_wait_wait'});

                sma= add_state(sma,'name','after_wait_wait',...
                    'self_timer', after_wait_dur,...
                    'input_to_statechange',{'Tup','iti'});

                %--------------------------------------------------------------
                %GO
                %--------------------------------------------------------------

            case 'go'
                sma= add_state(sma,'name','wait',...
                    'self_timer', wait_dur,...
                    'input_to_statechange',{'Tup','wait_4_lick'});

                sma= add_state(sma,'name','wait_4_lick',...
                    'self_timer', timeToLick,...
                    'input_to_statechange',{'Cin','water','Tup','iti'});

                sma = add_state(sma, 'name', 'water',...
                    'output_actions', {'DOut', Settings('get', 'DIOLINES','HF1water'), 'SoundOut',value(IdGoTone)}, ...
                    'self_timer', water_dur,...
                    'input_to_statechange', {'Tup', 'iti'});

                %--------------------------------------------------------------
                %NO GO
                %--------------------------------------------------------------

            case 'nogo'
                sma= add_state(sma,'name','wait',...
                    'self_timer', wait_dur,...
                    'input_to_statechange',{'Tup','wait_4_nolick'});

                sma= add_state(sma,'name','wait_4_nolick',...
                    'self_timer', timeToAvoidLicking,...
                    'input_to_statechange',{'Cin','punish','Tup','iti'});

                if strcmp(NoGoPuff,'on') && strcmp(NoGoToneMenu,'on')
                    sma = add_state(sma, 'name', 'punish',...
                        'output_actions', {'DOut', Settings('get', 'DIOLINES','PUFF1valv'), 'SoundOut',value(IdNoGoTone)}, ...
                        'self_timer', max(tone_dur,puff_dur),...
                        'input_to_statechange', {'Tup', 'iti'});

                elseif strcmp(NoGoPuff,'on') && strcmp(NoGoToneMenu,'off')
                    sma = add_state(sma, 'name', 'punish',...
                        'output_actions', {}, ...
                        'self_timer', tone_dur,...
                        'input_to_statechange', {'Tup', 'iti'});

                elseif strcmp(NoGoPuff,'off') && strcmp(NoGoToneMenu,'on')
                    sma = add_state(sma, 'name', 'punish',...
                        'output_actions', {}, ...
                        'self_timer', puff_dur,...
                        'input_to_statechange', {'Tup', 'iti'});

                else
                    sma = add_state(sma, 'name', 'punish',...
                        'output_actions', {}, ...
                        'self_timer', 1,...
                        'input_to_statechange', {'Tup', 'iti'});
                end
                %----------------------------------------------------------
                %WAIT
                %----------------------------------------------------------
            case 'wait'
                sma= add_state(sma,'name','wait',...
                    'self_timer', wait_dur,...
                    'input_to_statechange',{'Tup','wait_4_nolick'});

                sma= add_state(sma,'name','wait_4_nolick',...
                    'self_timer', timeToAvoidLicking,...
                    'input_to_statechange',{'Tup','water','Cin','iti'});

                sma = add_state(sma, 'name', 'water',...
                    'output_actions', { 'SoundOut',value(IdWaitingTone),'DOut', Settings('get', 'DIOLINES','HF1water')}, ...
                    'self_timer', water_dur,...
                    'input_to_statechange', {'Tup', 'iti'});
                %----------------------------------------------------------
                %ACTIVE AVOID
                %----------------------------------------------------------
            case 'active avoid'
                sma= add_state(sma,'name','wait',...
                    'self_timer', wait_dur,...
                    'input_to_statechange',{'Tup','wait_4_lick'});

                sma= add_state(sma,'name','wait_4_lick',...
                    'self_timer', timeToLick,...
                    'input_to_statechange',{'Cin','iti','Tup','punish'});

                if strcmp(AAPuff,'on') && strcmp(AAToneMenu,'on')
                    sma = add_state(sma, 'name', 'punish',...
                        'output_actions', {'DOut', Settings('get', 'DIOLINES','PUFF1valv'), 'SoundOut',value(IdAATone)}, ...
                        'self_timer', max(tone_dur,puff_dur),...
                        'input_to_statechange', {'Tup', 'iti'});

                elseif strcmp(AAPuff,'on') && strcmp(AAToneMenu,'off')
                    sma = add_state(sma, 'name', 'punish',...
                        'output_actions', {}, ...
                        'self_timer', tone_dur,...
                        'input_to_statechange', {'Tup', 'iti'});

                elseif strcmp(AAPuff,'off') && strcmp(AAToneMenu,'on')
                    sma = add_state(sma, 'name', 'punish',...
                        'output_actions', {}, ...
                        'self_timer', puff_dur,...
                        'input_to_statechange', {'Tup', 'iti'});

                else
                    sma = add_state(sma, 'name', 'punish',...
                        'output_actions', {}, ...
                        'self_timer', 1,...
                        'input_to_statechange', {'Tup', 'iti'});
                end

                %             sma = add_state(sma, 'name', 'error_right_poke_in');
                %             sma = add_state(sma, 'name', 'correct_left_poke_in');
                %             %             sma = add_state(sma, 'name', 'correct_left_waiting_miss');
                %             sma = add_state(sma, 'name', 'error_right_waiting_miss');


        end
        if light_flag
            sma = add_state(sma, 'name', 'iti', ...
                'self_timer', ITI_dur/2,...
                'input_to_statechange', {'Tup', 'iti_stim'});
        else
            sma = add_state(sma, 'name', 'iti', ...
                'self_timer', ITI_dur/2,...
                'input_to_statechange', {'Tup', 'iti_nostim'});
        end
        
        if   light_IPI>0 % pulsing
            sma = add_state(sma, 'name', 'iti_stim', ...
                'output_actions', {'SchedWaveTrig','-ao_trigger2-trigger2_mask',},... %% BA untest
                'self_timer', ITI_dur/2,...
                'input_to_statechange', {'Tup', 'final_state'});
        else % continuous light
            sma = add_state(sma, 'name', 'iti_stim', ...
                'output_actions', {'SchedWaveTrig','-ao_laser-ao_mask',},...
                'self_timer', ITI_dur/2,...
                'input_to_statechange', {'Tup', 'final_state'});
        end
        
        if   light_IPI>0 % pulsing
            sma = add_state(sma, 'name', 'iti_nostim', ...
                'output_actions', {'SchedWaveTrig','-trigger2_mask',},... %% BA untest
                'self_timer', ITI_dur/2,...
                'input_to_statechange', {'Tup', 'final_state'});
        else % continuous light
            sma = add_state(sma, 'name', 'iti_nostim', ...
                'output_actions', {'SchedWaveTrig','-ao_mask',},... %% BA untest
                'self_timer', ITI_dur/2,...
                'input_to_statechange', {'Tup', 'final_state'});
            
         end
        %-------------------------------------------------------------------------%
        %FINAL STATE
        %-------------------------------------------------------------------------%

        % Final State

        sma = add_state(sma, 'name', 'final_state', ...
            'output_actions', {},...
            'self_timer', (0.1),...
            'input_to_statechange', {'Tup', 'check_next_trial_ready'});
        %%








        %   MANDATORY LINE:
        %   dispatcher('send_assembler', sma, ...
        %   optional cell_array of strings specifying the prepare_next_trial
        %   states);

        
        dispatcher('send_assembler', sma, 'final_state');
        pause(3.5);
        if bScientifica
            % % Move Scientifica (in Z)
            if lastz > thistrial_coordz(3) % this has to be sepeate from the first manipulator command because otherwise too fast for Scientifica
                setCoord_SCI(id,thistrial_coordz);
            else
                setCoord_SCI(id,thistrial_coord);
            end
            lastz = thistrial_coordz(3);
        end
        %----REINIT----------------------------------------------------------------%
        
    case 'reinit',

        % Delete all SoloParamHandles who belong to this object and whose
        % fullname starts with the name of this mfile:
        delete_sphandle('owner', ['^@' class(obj) '$'], ...
            'fullname', ['^' mfilename]);

        % Reinitialise at the original GUI position and figure:
        feval(mfilename, obj, 'init');

    otherwise,
        warning('%s : %s  don''t know action %s\n', class(obj), mfilename, action);




end %%% SWITCH action
