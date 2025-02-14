
function  [] =  StateMatrixSection(obj, action)

global center1water  left1water left1led right1water right1led ...
    video_sync ephys_sync ceil_led laser_stim

mask_stim =   ceil_led;

GetSoloFunctionArgs;

%Pass other sections' SPHs to local variables

DELAY_TO_REWARD = value(DelayToReward);
CENTER_SMALL_REWARD = value(CenterSmall);
CENTER_LARGE_REWARD = value(CenterLarge);
LEFT_SMALL_REWARD = value(LeftSmall);
LEFT_LARGE_REWARD = value(LeftLarge);
RIGHT_SMALL_REWARD = value(RightSmall);
RIGHT_LARGE_REWARD = value(RightLarge);
ID_TONE_SMALL = value(IdToneSmall);
ID_TONE_LARGE = value(IdToneLarge);
ID_TONE_SMALL_LARGE = value(IdToneSmallLarge);
ID_NOISE = value(IdNoise);
ID_NOISE_BURST = value(IdNoiseBurst);
VALID_POKE_DURATION_1_N = value(VpdSmall_Current_N);
VALID_POKE_DURATION_2_N = value(VpdLarge_Current_N) - value(VpdSmall_Current_N);
VALID_POKE_DURATION_1_L = value(VpdSmall_Current_L);
VALID_POKE_DURATION_2_L = value(VpdLarge_Current_L) - value(VpdSmall_Current_L);
BLOCK_NAME = value(BlockName); %1:'NosePoke' or 0:'LeverPress'

WAIT_POKE_NECESSARY = value(WaitPokeNecessary); %'Yes' or 'No'
TIME_TO_FAKE_POKE = value(TimeToFakePoke);
MULTI_POKE = value(MultiPoke); %valid_waiting, just_noiseB', 'no_reward'
REWARD_AVAIL_PERIOD = value(RewardAvailPeriod);
ITI_POKE_TIMEOUT = value(ITIPokeTimeOut); % BA reappropriating this for the time for which a lick is accepted during this trila                                           
MULTI_POKE_TOLERANCE = value(MultiPokeTolerance);
TRIAL_LENGTH_CONSTANT = 'Yes'; % value(TrialLengthConstant);
TRIAL_LENGTH = value(TrialLength);
STIM_OR_NOT = value(StimOrNot);
OFF_DUR = value(OffDur);
ON_DUR = value(OnDur);
ON_EVENT = value(OnEvent);
OFF_EVENT = value(OffEvent);
ON_TIME = value(OnTime);
OFF_TIME = value(OffTime);
OFF_DUR_MASK = value(OffDur_Mask);
ON_DUR_MASK = value(OnDur_Mask);
ON_EVENT_MASK = value(OnEvent_Mask);
OFF_EVENT_MASK = value(OffEvent_Mask);
ON_TIME_MASK = value(OnTime_Mask);
OFF_TIME_MASK = value(OffTime_Mask);

NOLICK_TIME = 3;

if ON_TIME == 0, ON_TIME = 0.0001;
end

if OFF_TIME == 0, OFF_TIME = 0.0001;
end

if ON_TIME_MASK == 0, ON_TIME_MASK = 0.0001;
end

if OFF_TIME_MASK == 0, OFF_TIME_MASK = 0.0001;
end

switch value(PortAssign), %
    case 'NP-C;Rew-Both'
        NOSE_POKE_IN = 'Cin'; % BA NOSE_POKE is not used
        NOSE_POKE_OUT = 'Cout'; % BA NOSE_POKE is not used
        REWARD_PORT = 'Left';
        warning('BA hack there is no Both just Left')
    case 'NP-C;Rew-L'
        NOSE_POKE_IN = 'Cin';% BA NOSE_POKE is not used
        NOSE_POKE_OUT = 'Cout';% BA NOSE_POKE is not used
        REWARD_PORT = 'Left';
    case 'NP-C;Rew-R'
        NOSE_POKE_IN = 'Cin';% BA NOSE_POKE is not used
        NOSE_POKE_OUT = 'Cout';% BA NOSE_POKE is not used
        REWARD_PORT = 'Right';
    case 'NP-L;Rew-C'
        NOSE_POKE_IN = 'Lin';% BA NOSE_POKE is not used
        NOSE_POKE_OUT = 'Lout';% BA NOSE_POKE is not used
        REWARD_PORT = 'Center';
    case 'NP-R;Rew-C'
        NOSE_POKE_IN = 'Rin';% BA NOSE_POKE is not used
        NOSE_POKE_OUT = 'Rout';% BA NOSE_POKE is not used
        REWARD_PORT = 'Center';
    otherwise
        error('don''t know this parameter %s', value(PortAssign));
end;

switch REWARD_PORT %input_to_statechange for reward port in
    
    case 'Both',
        error ('BA both not currently supported');
    otherwise,
        available_str = {'Center','Left','Right'};
        reward_str_in = {'Cin','Lin','Rin'};
        reward_str_out = {'Cin','Lin','Rin'};
        reward_port_str_in = reward_str_in{find(~cellfun(@isempty,(strfind(available_str,REWARD_PORT))))};
        reward_port_str_out = reward_str_out{find(~cellfun(@isempty,(strfind(available_str,REWARD_PORT))))};
        if isempty(reward_port_str_in)
            error('don''t know this REWARD_PORT parameter %s!', REWARD_PORT)
        end
end;


switch action
    case 'init',
        StateMatrixSection(obj, 'prepare_next_trial');
        
    case 'prepare_next_trial',
        
        sma = StateMachineAssembler('no_dead_time_technology');
        
        sma = add_scheduled_wave(sma, 'name', 'vpd1_np', ...
            'preamble', VALID_POKE_DURATION_1_N);
        sma = add_scheduled_wave(sma, 'name', 'vpd2_np', ...
            'preamble', VALID_POKE_DURATION_2_N);
        sma = add_scheduled_wave(sma, 'name', 'vpd1_lp', ...
            'preamble', VALID_POKE_DURATION_1_L);
        sma = add_scheduled_wave(sma, 'name', 'vpd2_lp', ...
            'preamble', VALID_POKE_DURATION_2_L);
        sma = add_scheduled_wave(sma, 'name', 'reward_avail', ...
            'preamble', REWARD_AVAIL_PERIOD);
        sma = add_scheduled_wave(sma, 'name', 'delay_to_reward', ...
            'preamble', DELAY_TO_REWARD);
        sma = add_scheduled_wave(sma, 'name', 'center_large_reward', ...
            'preamble', CENTER_LARGE_REWARD);
        sma = add_scheduled_wave(sma, 'name', 'left_large_reward', ...
            'preamble', LEFT_LARGE_REWARD);
        sma = add_scheduled_wave(sma, 'name', 'right_large_reward', ...
            'preamble', RIGHT_LARGE_REWARD);
        %         give small reward stochastically
        if rand(1) > 0
            sma = add_scheduled_wave(sma, 'name', 'center_small_reward', ...
                'preamble', CENTER_SMALL_REWARD);
            sma = add_scheduled_wave(sma, 'name', 'left_small_reward', ...
                'preamble', LEFT_SMALL_REWARD);
            sma = add_scheduled_wave(sma, 'name', 'right_small_reward', ...
                'preamble', RIGHT_SMALL_REWARD);
        else
            sma = add_scheduled_wave(sma, 'name', 'center_small_reward', ...
                'preamble', .000001);
            sma = add_scheduled_wave(sma, 'name', 'left_small_reward', ...
                'preamble', .000001);
            sma = add_scheduled_wave(sma, 'name', 'right_small_reward', ...
                'preamble', .000001);
        end
        sma = add_scheduled_wave(sma, 'name', 'iti_poke_timeout', ...
            'preamble',ITI_POKE_TIMEOUT );  % ITI_POKE_TIMEOUT % BA this is used to restart the trial if Trial Length * n has elapsed and the animal hasn't licked
        sma = add_scheduled_wave(sma, 'name', 'trial_length', ...           
            'preamble', TRIAL_LENGTH-NOLICK_TIME);
        sma = add_scheduled_wave(sma, 'name', 'laser_stim_on_delay', ...
            'preamble', ON_TIME, 'trigger_on_up', 'laser_pulse_generator');
        sma = add_scheduled_wave(sma, 'name', 'laser_stim_off_delay', ...
            'preamble', 0.0001, 'sustain', OFF_TIME, 'untrigger_on_down', 'laser_pulse_generator');
        sma = add_scheduled_wave(sma, 'name', 'laser_stim_off_imed', ...
            'preamble', 0.0001, 'sustain', 0.0001, 'untrigger_on_down', 'laser_pulse_generator');
        sma = add_scheduled_wave(sma, 'name', 'laser_pulse_generator', ...
            'preamble', OFF_DUR, 'sustain', ON_DUR, 'loop', -1, ...
            'no_wave_events', 1, 'trigger_on_up', 'laser_stim_dout');
        sma = add_scheduled_wave(sma, 'name', 'laser_stim_dout', ...
            'preamble', 0.0001, 'sustain', ON_DUR, 'DOut', laser_stim, 'no_wave_events', 1);
        sma = add_scheduled_wave(sma, 'name', 'mask_stim_on_delay', ...
            'preamble', ON_TIME_MASK, 'trigger_on_up', 'mask_pulse_generator');
        sma = add_scheduled_wave(sma, 'name', 'mask_stim_off_delay', ...
            'preamble', 0.0001, 'sustain', OFF_TIME_MASK, 'untrigger_on_down', 'mask_pulse_generator');
        sma = add_scheduled_wave(sma, 'name', 'mask_pulse_generator', ...
            'preamble', OFF_DUR_MASK, 'sustain', ON_DUR_MASK, 'loop', -1, ...
            'no_wave_events', 1, 'trigger_on_up', 'mask_stim_dout');
        sma = add_scheduled_wave(sma, 'name', 'mask_stim_dout', ...
            'preamble', 0.0001, 'sustain', ON_DUR_MASK, 'DOut', mask_stim, 'no_wave_events', 1);
        
        
        %     sma = add_scheduled_wave(sma, 'name', 'laser_stim_on_delay', ...
        %         'preamble', ON_TIME);
        %     sma = add_scheduled_wave(sma, 'name', 'laser_stim_off_delay', ...
        %         'preamble', 0.0001, 'sustain', OFF_TIME);
        %     sma = add_scheduled_wave(sma, 'name', 'laser_stim_off_imed', ...
        %         'preamble', 0.0001, 'sustain', 0.0001);
        
        %%% Laser %%%
%         trial_start_laser_sw_str = '';
        poke_in_laser_sw_str = '';
        poke_out_laser_sw_str = '+laser_stim_off_imed'; %turn off laser after poke-out, unless explicitly told not to
        
        if STIM_OR_NOT == 1
            switch OFF_EVENT
%                 case 'TrialStart'
%                     trial_start_laser_sw_str = [trial_start_laser_sw_str '+laser_stim_off_delay'];
                case 'CPokeIn'
                    poke_in_laser_sw_str = [poke_in_laser_sw_str '+laser_stim_off_delay'];
                case 'CPokeOut' % THIS CASE IS END OF TRIAL
                    poke_out_laser_sw_str = '+laser_stim_off_delay'; %overwrite laser_stim_off_ime!
                otherwise
                    error('don''t know what to do!');
            end
            
            switch ON_EVENT
%                 case 'TrialStart' % THESE TWO CASES ARE THE SAME
%                      poke_in_laser_sw_str = [poke_in_laser_sw_str '+laser_stim_on_delay'];
                case 'CPokeIn' % this means BEGIN of Trial 
                    poke_in_laser_sw_str = [poke_in_laser_sw_str '+laser_stim_on_delay'];
                otherwise
                    error('don''t know what to do!');
            end
        end
        
        %%% Mask %%% BA dont quite understand this
        trial_start_mask_sw_str = '';
        poke_in_mask_sw_str = '';
        poke_out_mask_sw_str = '';
        time_out_mask_sw_str = '';
        
        switch ON_EVENT_MASK
%             case 'TrialStart'
%                 trial_start_mask_sw_str = [trial_start_mask_sw_str '+mask_stim_on_delay'];
            case 'CPokeIn'
                poke_in_mask_sw_str = [poke_in_mask_sw_str '+mask_stim_on_delay'];
            otherwise
                error('don''t know what to do!');
        end
        
        switch OFF_EVENT_MASK
%             case 'TrialStart'
%                 trial_start_mask_sw_str = [trial_start_mask_sw_str '+mask_stim_off_delay'];
            case 'CPokeIn'
                poke_in_mask_sw_str = [poke_in_mask_sw_str '+mask_stim_off_delay'];
            case 'CPokeOut' % THIS CASE IS END OF TRIAL
                poke_out_mask_sw_str = [poke_out_mask_sw_str '+mask_stim_off_delay'];
%             case 'TimeOut'
%                 time_out_mask_sw_str = [time_out_mask_sw_str 'mask_stim_off_delay'];
            otherwise
                error('don''t know what to do!');
        end
        
        
        for i = 1:2, %repeat for MIRROR WORLD STATE MATRIX!!!  % BA (for mirror state no sound)
            %%% some conditianal parameter for determinig real side state matrix or
            %%% mirror side state matrix
            %%*BA what is the mirror state matrix?
            if i == 1,
                MIRROR_STR = '';
            elseif i == 2,
                MIRROR_STR = 'mirror_';
            end;
            
            %%%%%%%%%%%Waiting inside waiting port%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            if strcmp(TRIAL_LENGTH_CONSTANT, 'Yes'),
                SCHED_WAVE_TL_STR = '+trial_length';
            else
                SCHED_WAVE_TL_STR = '';
            end;
            
            
            BLOCK_STR = '_np';           
                       %'short_poke', 'small_available, 'large_available', 'zero_available'
            REWARD_PORT_IN_SHORT = {reward_port_str_in,[MIRROR_STR 'pre_left_short_reward']};
            REWARD_PORT_IN_SMALL = {reward_port_str_in,[MIRROR_STR 'pre_left_small_reward']};
            REWARD_PORT_IN_LARGE = {reward_port_str_in,[MIRROR_STR 'pre_left_large_reward']};
 
            
            sma = add_state(sma, 'name', [MIRROR_STR 'waiting1' BLOCK_STR], ...
                'output_actions', {'SchedWaveTrig',['vpd1' BLOCK_STR SCHED_WAVE_TL_STR poke_in_laser_sw_str poke_in_mask_sw_str],...
                'SoundOut',-ID_NOISE}, ... % Noise was started at the end of the last trial
                'input_to_statechange', [REWARD_PORT_IN_SHORT,...
                {['vpd1' BLOCK_STR '_In'],[MIRROR_STR 'waiting_small1' BLOCK_STR], ...
                'trial_length_In',['mirror_waiting1' BLOCK_STR]}]);
            
            
            
            %'waiting_small1'
            sma = add_state(sma, 'name', [MIRROR_STR 'waiting_small1' BLOCK_STR], ...
                'output_actions', {'SoundOut', ID_TONE_SMALL, ...
                'SchedWaveTrig',['vpd2' BLOCK_STR]}, ...
                'input_to_statechange', {['vpd2' BLOCK_STR '_In'],[MIRROR_STR 'waiting_large1' BLOCK_STR], ...
                'trial_length_In',['mirror_waiting_small2' BLOCK_STR]}); %not mirror_waiting_small1 because sound is alreday played
            
            % BA (for mirror state no sound)
            %'waiting_small2' %in real world, never used...
            sma = add_state(sma, 'name', [MIRROR_STR 'waiting_small2' BLOCK_STR], ...
                'input_to_statechange', [REWARD_PORT_IN_SMALL,...
                {['vpd2' BLOCK_STR '_In'],[MIRROR_STR 'waiting_large1' BLOCK_STR], ...
                'trial_length_In',['mirror_waiting_small2' BLOCK_STR]}]);
            
            %'waiting_large1'
            sma = add_state(sma, 'name', [MIRROR_STR 'waiting_large1' BLOCK_STR], ...
                'output_actions', {'SoundOut', ID_TONE_LARGE,'SchedWaveTrig','iti_poke_timeout'}, ...
                'input_to_statechange', [REWARD_PORT_IN_LARGE,...
                {'trial_length_In',['mirror_waiting_large2' BLOCK_STR], 'iti_poke_timeout_In','trial_timed_out' }]); %not mirror_waiting_large1 because sound is alreday played
            
            %'waiting_large2' %in real world, never used...
            sma = add_state(sma, 'name', [MIRROR_STR 'waiting_large2' BLOCK_STR], ...
                'input_to_statechange', [REWARD_PORT_IN_LARGE,...
                {'trial_length_In',['mirror_waiting_large2' BLOCK_STR], 'iti_poke_timeout_In','trial_timed_out' }]);           
            
         
            %%%%%%%%%%%%%Pre-reward state and reward delivery state%%%%%%%%%%%%
            
            for j = 1:3, %repeat for center,left, and right
                for k = 1:3, %repeat for short,small,large, and zero
                    
                    %set conditional parameters
                    if j == 1, REW_PORT_STR = 'center_'; DOUT_WATER = center1water;
                    elseif j == 2, REW_PORT_STR = 'left_'; DOUT_WATER = left1water;
                    elseif j == 3, REW_PORT_STR = 'right_'; DOUT_WATER = right1water;
                    end;
                    
                    if k == 1,
                        REW_SIZE_STR = 'short_';
                        DELAY_TO_REWARD_SCHED_IN_STATE = [MIRROR_STR 'ending_trial_length'];
                        REWARD_SCHED_WAVE = {};
                        REWARD_SCHED_WAVE_IN = {};
                    elseif k == 2,
                        REW_SIZE_STR = 'small_';
                        DELAY_TO_REWARD_SCHED_IN_STATE = [MIRROR_STR REW_PORT_STR REW_SIZE_STR 'reward'];
                        REWARD_SCHED_WAVE = {'SchedWaveTrig',[REW_PORT_STR REW_SIZE_STR 'reward']};
                        REWARD_SCHED_WAVE_IN = {[REW_PORT_STR REW_SIZE_STR 'reward_In'],[MIRROR_STR 'ending_trial_length']};
                    elseif k == 3,
                        REW_SIZE_STR = 'large_';
                        DELAY_TO_REWARD_SCHED_IN_STATE = [MIRROR_STR REW_PORT_STR REW_SIZE_STR 'reward'];
                        REWARD_SCHED_WAVE = {'SchedWaveTrig',[REW_PORT_STR REW_SIZE_STR 'reward']};
                        REWARD_SCHED_WAVE_IN = {[REW_PORT_STR REW_SIZE_STR 'reward_In'],[MIRROR_STR 'ending_trial_length']};
                    end;
                    % % BA may wanna make this period longer or adjustable
                    % later
                    %         pre reward states
                    sma = add_state(sma, 'name', [MIRROR_STR 'pre_' REW_PORT_STR REW_SIZE_STR 'reward'], ...
                        'output_actions', {'SchedWaveTrig',['delay_to_reward'  poke_out_laser_sw_str ], ...
                        'DOut', video_sync}, ...
                        'input_to_statechange', {'delay_to_reward_In',DELAY_TO_REWARD_SCHED_IN_STATE, ...
                        'trial_length_In',['mirror_pre_' REW_PORT_STR REW_SIZE_STR 'reward']});
                    
                    %         reward state
                    sma = add_state(sma, 'name', [MIRROR_STR REW_PORT_STR REW_SIZE_STR 'reward'], ...
                        'output_actions', [{'DOut',DOUT_WATER}, ...
                        REWARD_SCHED_WAVE], ...
                        'input_to_statechange', [REWARD_SCHED_WAVE_IN, ...
                        {'trial_length_In',['mirror_' REW_PORT_STR REW_SIZE_STR 'reward']}]);
                    
                end;
            end;
            %%%%%%%%%%%%%Pre-reward state and reward delivery state%%%%%%%%%%%%
            
            %%%%%%%%%%%%%%%%%%%% ITI (inter-trial interval) %%%%%%%%%%%%%%%%%%%%
        end; %end of for i=1:2, end making REAL AND MIRROR STATE MATRIX
        if isempty(strcmp(TRIAL_LENGTH_CONSTANT, 'Yes'))
            error('Only support: TRIAL_LENGTH_CONSTANT = YES,i.e. Constant minimum length trials')
        end
        
        %             CASE: Trial length has not passed (so must not be in mirror state)
        sma = add_state(sma, 'name', ['trial_timed_out'], ... % this occurs if iti_poke_timeout schedule wave is goes high
            'self_timer', 0.001,...
            'input_to_statechange', {'Tup','signal_trial_end','trial_length_In','signal_trial_end'});
        
        sma = add_state(sma, 'name', ['ending_trial_length'], ...
            'input_to_statechange', {'trial_length_In','signal_trial_end'});
        
        %             CASE: Trial length passed (in mirror state) this is just
            %             state is just for symmetry with non-mirro state.
            sma = add_state(sma, 'name', [MIRROR_STR 'ending_trial_length'], ...
                'self_timer', 0.001,...
                'input_to_statechange', {'Tup','signal_trial_end'});
            % BA  after trial length period has passed
            
%             
           WAIT_IN_TIME_OUT = {reward_port_str_in,'intermediate_time_out_signal_trial_end'};
            
            sma = add_state(sma, 'name', ['signal_trial_end'], ...
                'output_actions', {'DOut', ephys_sync,'SoundOut',ID_NOISE}, ...
                'self_timer',NOLICK_TIME,...
                'input_to_statechange', [WAIT_IN_TIME_OUT,{'Tup','turn_off_mask_and_last_stim'}]);
            
            sma = add_state(sma, 'name', ['intermediate_time_out_signal_trial_end'], ... % % This state is required because looping back to the same state doesn't reset the self_timer
                'self_timer',0.001,...
                'input_to_statechange', [{'Tup','time_out_signal_trial_end'}]);
        
             sma = add_state(sma, 'name', ['time_out_signal_trial_end'], ...
                'output_actions', {'SoundOut',ID_NOISE}, ...
                'self_timer',NOLICK_TIME,...
                'input_to_statechange', [WAIT_IN_TIME_OUT,{'Tup','turn_off_mask_and_last_stim'}]);
            
                  sma = add_state(sma, 'name', ['turn_off_mask_and_last_stim'], ...
                'output_actions', {'SchedWaveTrig',poke_out_mask_sw_str}, ...
                'self_timer',0.001,...
                'input_to_statechange', [WAIT_IN_TIME_OUT,{'Tup','state35'}]);
   
       
        %   dispatcher('send_assembler', sma, ...
        %   optional cell_array of strings specifying the prepare_next_trial states);
        dispatcher('send_assembler', sma, {'signal_trial_end'});
        
    otherwise,
        warning('%s : %s  don''t know action %s\n', class(obj), mfilename, action);
end


