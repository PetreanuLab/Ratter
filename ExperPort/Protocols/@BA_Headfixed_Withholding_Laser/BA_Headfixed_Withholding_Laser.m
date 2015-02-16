% This protocol runs a withholding task in which a rat gets different sizes
% of reward depending on the number of tones played while a rat is
% "WAITING", which is to restrain from licking
%
% BA 083112 based on Masa_Withholding_Laser
% Masayoshi Murakami - December 2008

% To run it:
%  newstartup
%  dispatcher('init')
% and select this protocol.
%
% dispatcher('close_protocol'); dispatcher('set_protocol','Masa_Withholding');
%

function [obj] = BA_Headfixed_Withholding_Laser(varargin)


% Default object is of our own class (mfilename);
% We inherit from Plugins/@pokesplot and @soundmanager
rd = rigdef();
obj = class(struct, mfilename, pokesplot, saveload, soundmanager);
%obj = class(struct, mfilename);


%---------------------------------------------------------------
%   BEGIN SECTION COMMON TO ALL PROTOCOLS, DO NOT MODIFY
%---------------------------------------------------------------

% If creating an empty object, return without further ado:
if nargin==0 || (nargin==1 && ischar(varargin{1}) && strcmp(varargin{1}, 'empty')),
    return;
end;

if isa(varargin{1}, mfilename), % If first arg is an object of this class itself, we are
    % Most likely responding to a callback from
    % a SoloParamHandle defined in this mfile.
    if length(varargin) < 2 || ~isstr(varargin{2}),
        error(['If called with a "%s" object as first arg, a second arg, a ' ...
            'string specifying the action, is required\n']);
    else action = varargin{2}; varargin = varargin(3:end);
    end;
else % Ok, regular call with first param being the action string.
    action = varargin{1}; varargin = varargin(2:end);
end;
if ~isstr(action), error('The action parameter must be a string'); end;

GetSoloFunctionArgs(obj);

%---------------------------------------------------------------
%   END OF SECTION COMMON TO ALL PROTOCOLS, MODIFY AFTER THIS LINE
%---------------------------------------------------------------

% ---- From here on is where you can put the code you like.
%
% Your protocol will be called, at the appropriate times, with the
% following possible actions:
%
%   'init'     To initialize -- make figure windows, variables, etc.
%
%   'update'   Called periodically within a trial
%
%   'prepare_next_trial'  Called when a trial has ended and your protocol
%              is expected to produce the StateMachine diagram for the next
%              trial; i.e., somewhere in your protocol's response to this
%              call, it should call "dispatcher('send_assembler', sma,
%              prepare_next_trial_set);" where sma is the
%              StateMachineAssembler object that you have prepared and
%              prepare_next_trial_set is either a single string or a cell
%              with elements that are all strings. These strings should
%              correspond to names of states in sma.
%                 Note that after the 'prepare_next_trial' call, further
%              events may still occur in the RTLSM while your protocol is thinking,
%              before the new StateMachine diagram gets sent. These events
%              will be available to you when 'trial_completed' is called on your
%              protocol (see below).
%
%   'trial_completed'   Called when 'state_0' is reached in the RTLSM,
%              marking final completion of a trial (and the start of
%              the next).
%
%   'close'    Called when the protocol is to be closed.
%
%
% VARIABLES THAT DISPATCHER WILL ALWAYS INSTANTIATE FOR YOU IN YOUR
% PROTOCOL:
%
% (These variables will be instantiated as regular Matlab variables,
% not SoloParamHandles. For any method in your protocol (i.e., an m-file
% within the @your_protocol directory) that takes "obj" as its first argument,
% calling "GetSoloFunctionArgs(obj)" will instantiate all the variables below.)
%
%
% n_done_trials     How many trials have been finished; when a trial reaches
%                   one of the prepare_next_trial states for the first
%                   time, this variable is incremented by 1.
%
% n_started_trials  How many trials have been started. This variable gets
%                   incremented by 1 every time the state machine goes
%                   through state 0.
%
% parsed_events     The result of running disassemble.m, with the
%                   parsed_structure flag set to 1, on all events from the
%                   start of the current trial to now.
%
% latest_events     The result of running disassemble.m, with the
%                   parsed_structure flag set to 1, on all new events from
%                   the last time 'update' was called to now.
%
% raw_events        All the events obtained in the current trial, not parsed
%                   or disassembled, but raw as gotten from the State
%                   Machine object.
%
% current_assembler The StateMachineAssembler object that was used to
%                   generate the State Machine diagram in effect in the
%                   current trial.
%
% Trial-by-trial history of parsed_events, raw_events, and
% current_assembler, are automatically stored for you in your protocol by
% dispatcher.m. See the wiki documentation for information on how to access
% those histories from within your protocol and for information.
%
%
switch action,

    %---------------------------------------------------------------
    %          CASE INIT
    %---------------------------------------------------------------

    case 'init'

        % Make default figure. We remember to make it non-saveable; on next run
        % the handle to this figure might be different, and we don't want to
        % overwrite it when someone does load_data and some old value of the
        % fig handle was stored as SoloParamHandle "myfig"
        SoloParamHandle(obj, 'myfig', 'saveable', 0); myfig.value = figure;

        % Make the title of the figure be the protocol name, and if someone tries
        % to close this figure, call dispatcher's close_protocol function, so it'll know
        % to take it off the list of open protocols.
        name = mfilename;
        set(value(myfig), 'Name', name, 'Tag', name, ...
            'closerequestfcn', 'dispatcher(''close_protocol'')', 'MenuBar', 'none');

        % At this point we have one SoloParamHandle, myfig
        % Let's put the figure where we want it and give it a reasonable size:
        set(findall(0,'name','dispatcher'),'position', rd.dispatcher.WinPos);

        x = 5; y = 5;       % Initial position on main GUI window

        % ----------------------  Other Sections -----------------------

        next_row(y);
        % From Plugins/@saveload:
        [x, y] = SavingSection(obj, 'init', x, y); %next_row(y);
        SavingSection(obj,'set_autosave_frequency',10);

        % ----------------  Parameters for Pokesplot --------------------
        % For plotting with the pokesplot plugin, we need to tell it what
        % colors to plot with:
        my_state_colors = struct( ...
            'ready_to_start_waiting',[0.1 0.1 0.1],   ...
            'waiting1_np',              [1 1 1],   ...
            'waiting_small1_np',      	 [0.8 1 0.8],   ...
            'waiting_large1_np',        [0.5 1 0.5],   ...
            'pre_left_short_reward', [1 1 0], ...
            'left_short_reward',     [1 0 0], ...
            'pre_left_small_reward', [0.5 0.5 1], ...
            'left_small_reward',     [0 0 1], ...
            'pre_left_large_reward', [0.7 0.4 0.9], ...
            'left_large_reward',     [0.5 0 0.8], ...
            'pre_left_zero_reward', [1 0.5 0.5], ...
            'left_zero_reward',     [1 0 0], ...
            'ending_trial_length',       [0.2 0.2 0.2], ...
            'mirror_ending_trial_length',       [0.2 0.2 0.2], ...
            'time_out_signal_trial_end',       [0.2 0.2 0.2]);  
        %           'state35',               [1 0 0]);

        % In pokesplot, the poke colors have a default value, so we don't need
        % to specify them, but here they are so you know how to change them.
        my_poke_colors = struct( ...
            'L',                  0.6*[1 0.66 0],    ...
            'C',                      [0 0 0],       ...
            'R',                  0.9*[1 0.66 0]);

        [x, y] = PokesPlotSection(obj, 'init', x, y, ...
            struct('states',  my_state_colors, 'pokes', my_poke_colors));next_row(y);
        PokesPlotSection(obj,'set_trial_limits','last n')
        PokesPlotSection(obj,'set_time_axis',[-0.1 20])
        set(findall(0,'name','PokesPlotSection'),'position',rd.PokesPlot.WinPos)  % % BA set dispatcher where we want it

        SoloFunctionAddVars('RewardSection', 'rw_args', {}, 'ro_args', {});
        [x, y, ...
            DelayToReward, ...
            RightLarge, RightSmall, LeftLarge, LeftSmall, CenterLarge, CenterSmall, ...
            PortAssign] ...
            = RewardSection(obj, 'init', x, y);
        
        next_column(x); y=5;
        
        SoloFunctionAddVars('BlockControlSection', 'rw_args', {}, 'ro_args', {});
        [x, y, BlockName, SameBlockParams] = ...
            BlockControlSection(obj, 'init', x, y);
        
        SoloFunctionAddVars('ParamsSection', 'rw_args', {}, 'ro_args', {});
        [x, y, ...
            MultiPokeTolerance, ITIPokeTimeOut, RewardAvailPeriod, MultiPoke] ...
            = ParamsSection(obj, 'init', x, y);
        
        SoloFunctionAddVars('VpdsSection', 'rw_args',{}, ...
            'ro_args',{BlockName});
        [x, y, ...
            VpdSmall_Current_N, VpdLarge_Current_N, ...
            VpdSmall_N, VpdLargeMin_N, VpdLargeMean_N, Adaptive_N, ...
            VpdSmall_Current_L, VpdLarge_Current_L, ...
            VpdSmall_L, VpdLargeMin_L, VpdLargeMean_L, Adaptive_L] = ...
            VpdsSection(obj, 'init', x, y);
        
        %         SoloFunctionAddVars('PokeDuration', 'rw_args',{}, 'ro_args', {'VpdList'});
        %         [x, y]= PokeDuration(obj, 'init', x, y);
        
        next_column(x); y=5;
        next_row(y, 2.5);
        
        SoloFunctionAddVars('BeginnerSection', ...
            'rw_args', {}, 'ro_args', {});
        [x, y, Beginner, WaitPokeNecessary, TimeToFakePoke, RewardCounter] = ...
            BeginnerSection(obj, 'init', x, y);
        next_row(y,0.5);
        
        SoloFunctionAddVars('TrialLengthSection', ...
            'rw_args', {}, 'ro_args', {});
        [x, y, TrialLengthConstant, TrialLength] = ...
            TrialLengthSection(obj, 'init', x, y);
        next_row(y,0.5);
        
        SoloFunctionAddVars('AutomationSection', ...
            'rw_args', {Adaptive_N, Adaptive_L, ...
            Beginner, WaitPokeNecessary, ...
            TrialLengthConstant, ...
            ITIPokeTimeOut, RewardAvailPeriod, MultiPoke, ...
            VpdSmall_N, VpdLargeMin_N, VpdLargeMean_N, ...
            VpdSmall_L, VpdLargeMin_L, VpdLargeMean_L, ...
            TimeToFakePoke, RewardCounter}, ...
            'ro_args', {SameBlockParams});
        AutomationSection(obj, 'init');
        
        SoloFunctionAddVars('SoundsSection', 'rw_args',{},'ro_args',{});
        [x, y, IdToneSmall, IdToneLarge, IdToneSmallLarge, ...
            IdNoise, IdNoiseBurst] = SoundsSection(obj, 'init', x, y);
        next_row(y,0.5);
        
        SoloFunctionAddVars('LaserSection', 'rw_args',{},'ro_args',{});
        [x, y, StimOrNot, OffDur, OnDur, OnEvent, OffEvent, OnTime, OffTime, ...
            OffDur_Mask, OnDur_Mask, OnEvent_Mask, OffEvent_Mask, OnTime_Mask, OffTime_Mask] = ...
            LaserSection(obj, 'init', x, y);
        SoloFunctionAddVars('StateMatrixSection', ...
            'rw_args', {}, ...
            'ro_args', {CenterSmall, CenterLarge, LeftSmall, LeftLarge, RightSmall, RightLarge, ...
            PortAssign, DelayToReward,  ....
            MultiPoke, RewardAvailPeriod, ITIPokeTimeOut, MultiPokeTolerance, ...
            BlockName, ...
            VpdSmall_Current_N, VpdLarge_Current_N, VpdSmall_Current_L, VpdLarge_Current_L, ...
            WaitPokeNecessary, TimeToFakePoke, ...
            TrialLengthConstant, TrialLength, ...
            IdToneSmall, IdToneLarge, IdToneSmallLarge, IdNoise, IdNoiseBurst, ...
            StimOrNot, OffDur, OnDur, OnEvent, OffEvent, OnTime, OffTime, OffDur_Mask, OnDur_Mask, OnEvent_Mask, OffEvent_Mask, OnTime_Mask, OffTime_Mask});
        
        set(findall(0,'name','BA_Headfixed_Withholding_Laser'),'position',rd.BA_Headfixed_Withholding_Laser.Main.WinPos)  % % BA set dispatcher where we want it
        set(findall(0,'name','LaserParams'),'position',rd.BA_Headfixed_Withholding_Laser.LaserParams.WinPos)  % % BA set dispatcher where we want it
        
        StateMatrixSection(obj, 'init');
        
        %---------------------------------------------------------------
        %          CASE PREPARE_NEXT_TRIAL
        %---------------------------------------------------------------
    case 'prepare_next_trial'

        AutomationSection(obj, 'prepare_next_trial');
        TrialLengthSection(obj, 'prepare_next_trial');
        BlockControlSection(obj, 'prepare_next_trial');
        VpdsSection(obj,'prepare_next_trial');
        SoundsSection(obj, 'prepare_next_trial');
        LaserSection(obj, 'prepare_next_trial');
        StateMatrixSection(obj,'prepare_next_trial');
        BlockControlSection(obj, 'set_next_done_trial_block')

        %---------------------------------------------------------------
        %          CASE TRIAL_COMPLETED
        %---------------------------------------------------------------
    case 'trial_completed'
        PokesPlotSection(obj, 'trial_completed');

        %---------------------------------------------------------------
        %          CASE UPDATE
        %---------------------------------------------------------------
    case 'update'
        PokesPlotSection(obj, 'update');

        %---------------------------------------------------------------
        %          CASE CLOSE
        %---------------------------------------------------------------
    case 'close'
        PokesPlotSection(obj, 'close');
        BeginnerSection(obj, 'close');
        if exist('myfig', 'var') && isa(myfig, 'SoloParamHandle') && ishandle(value(myfig)),
            delete(value(myfig));
        end;
        delete_sphandle('owner', ['^@' class(obj) '$']);

    otherwise,
        warning('Unknown action! "%s"\n', action);
end;

return;

