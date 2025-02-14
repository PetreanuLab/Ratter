% To run it:
%  newstartup
%  dispatcher('init')
% and select this protocol.
%
% dispatcher('close_protocol'); dispatcher('set_protocol','gilmix');
%
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
% n_started trials  How many trials have been started. This variable gets
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
function [obj] = Head_fixed2(varargin)

% Default object is of our own class (mfilename);
% We inherit from Plugins/@pokesplot and @soundmanager



obj = class(struct, mfilename, pokesplot, saveload, soundmanager,water,sidesplot);





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
%--------------------------------------------------------------

switch action

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
        set(value(myfig), 'Position', [5   50   1100   750]); % Initial position on main GUI window


        %---------------------------------------------------------------
        %                     SPHs INITIALIZED
        %---------------------------------------------------------------


        %----------------------- Globals ----------------------
        SoloParamHandle(obj, 'LastTrialEvents', 'value', []);
        SoloParamHandle(obj, 'maxtrials', 'value', 1000);

        DeclareGlobals(obj, 'ro_args', {'maxtrials','LastTrialEvents'});

        x = 5; y = 5;

        % ----------------------  Pluggins -----------------------

        % From Plugins/@saveload:
        [x, y] = SavingSection(obj, 'init', x, y); %next_row(y);
        SavingSection(obj,'set_autosave_frequency',10);


        % ----------------  Parameters for Pokesplot --------------------

        my_state_colors = struct( ...
            'wait_4_odor',           [0.75 0.75 0.75],   ...
            'wait_4_lick',  [0.75 0.25 0.25],   ...
            'odor_valve_on',      	       0.9*[0.5 1 1],...
            'wait',  [0.75 0.95 0.25],   ...
            'water',            0.9*[0.4 0.7 0.9], ...
            'after_wait_wait',            0.5*[0.1 0.9 0.5], ...
            'wait_4_nolick',            0.7*[0.7 0.7 0.9], ...
            'punish',            0.9*[0.4 0.9 0.7], ...
            'iti',                               [0.9 0.25 0],...
            'iti_stim',                               [0.25 0.25 0.9],...
            'iti_nostim',                               [0.5 0.5 0.5],...
            'final_state',      	   [1 1 1]   ...
            );

        my_poke_colors = struct( ...
            'L',                  0.6*[1 0.66 0],    ...
            'C',                      [0 0 0],       ...
            'R',                  0.9*[1 0.66 0]);

        [x, y] = PokesPlotSection(obj, 'init', x, y, ...
            struct('states',  my_state_colors, 'pokes', my_poke_colors)); next_row(y,1.5);

        ThisSPH=get_sphandle('owner', mfilename, 'name','trial_limits'); ThisSPH{1}.value_callback = 'last n';
        ThisSPH=get_sphandle('owner', mfilename, 'name','t0'); ThisSPH{1}.value = -2;
        ThisSPH=get_sphandle('owner', mfilename, 'name','t1'); ThisSPH{1}.value = 15;


        % -----------------------  Other Parameters -----------------------

        NumeditParam(obj, 'odorDur', 1, x, y, 'label', 'odor dur');next_row(y);
        NumeditParam(obj, 'timeToOdorMin', 3, x, y, 'label', 'Time to odor min'); next_row(y,1);
        NumeditParam(obj, 'timeToOdorMax', 4, x, y, 'label', 'Time to odor max'); next_row(y,1);
        NumeditParam(obj, 'timeAfterOdor', 1, x, y, 'label', 'wait'); next_row(y,1);
        NumeditParam(obj, 'timeITI', 8, x, y, 'label', 'mean ITI');next_row(y);
        NumeditParam(obj, 'SDITI', 1, x, y, 'label', 'SD ITI');next_row(y);
        SubHeaderParam(obj, 'otherParams', 'Other Parameters', x, y); next_row(y,2);

        SoloFunctionAddVars('StateMatrixSection', 'rw_args', ...
            {'odorDur', 'timeToOdorMin','timeAfterOdor', 'timeITI', 'timeToOdorMax', 'SDITI'});

        % Display the odor number for the future trial
        DispParam(obj, 'future_odor', 0, x, y); % (at initialization, display 0)
        next_row(y);

        % Display the odor number for the current trial
        DispParam(obj, 'current_odor', 0, x, y); % (at initialization, display 0)
        next_row(y);

        DispParam(obj, 'previous_odor', 0, x, y); % (at initialization, display 0)
        next_row(y);

        DispParam(obj, 'photostimulation', 0,  x, y);   next_row(y);
        SoloFunctionAddVars('StateMatrixSection', 'rw_args', {'photostimulation'});
        
        DispParam(obj, 'photostimulationCoordX', 0,  x, y);   next_row(y);
        SoloFunctionAddVars('StateMatrixSection', 'rw_args', {'photostimulationCoordX'});
       DispParam(obj, 'photostimulationCoordY', 0,  x, y);   next_row(y);
        SoloFunctionAddVars('StateMatrixSection', 'rw_args', {'photostimulationCoordY'});
       DispParam(obj, 'photostimulationCoordZ', 0,  x, y);   next_row(y);
        SoloFunctionAddVars('StateMatrixSection', 'rw_args', {'photostimulationCoordZ'});
        
        
        %%%%%%%%%%%%%noise
        SoundManagerSection(obj, 'init');
        sound_samp_rate = SoundManagerSection(obj, 'get_sample_rate');

        SoloParamHandle(obj, 'IdNoise', 'value', 0);
        SoundManagerSection(obj, 'declare_new_sound', 'Noise');
        IdNoise.value = SoundManagerSection(obj, 'get_sound_id', 'Noise');

        PushbuttonParam(obj, 'Play_Noise', x,y, 'label', 'Play Noise', 'position');next_row(y);
        set_callback(Play_Noise,{'SoundManagerSection', 'play_sound', 'Noise'});


        NoiseMenu = MenuParam(obj, 'Noise', {'on', 'off',}, ...
            'on', x, y, 'label','Noise'); next_row(y,1);

        SoloFunctionAddVars('StateMatrixSection', 'rw_args', {'IdNoise'});

        t=value(odorDur)+value(timeToOdorMax);

        Noise = 0.01*randn(1,t*sound_samp_rate);

        SoundManagerSection(obj, 'set_sound', 'Noise', Noise);
        SoundManagerSection(obj, 'send_not_yet_uploaded_sounds');

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


        next_column(x);
        y=5;

        % Neurtal SECTION
        [x, y] = NeutralSection(obj, 'init', x, y);next_row(y,1);

        % GO SECTION
        [x, y] = GoSection(obj, 'init', x, y);next_row(y,1);

        next_column(x);
        y=5;


        % NOGO SECTION
        [x, y] = NoGoSection(obj, 'init', x, y);next_row(y,1);

        next_column(x);
        y=5;


        % WAIT SECTION
        [x, y] = WaitingSection(obj, 'init', x, y);% next_row(y,1);

        value()
        next_column(x);
        y=5;

        % ACTIVE AVOID SECTION
        [x, y] = AASection(obj, 'init', x, y);next_row(y,1);


        %ODOR SECTION

        [x, y] = OdorSection(obj, 'init', x, y);


        next_column(x);
        y = 5;




        StateMatrixSection(obj, 'init');


        %---------------------------------------------------------------
        %          CASE PREPARE_NEXT_TRIAL
        %---------------------------------------------------------------
        % The next cases are just set up with outputs so to understand when (during
        % the protocol) each case happens. If you want your protocol to do
        % something at a particular moment during each trial you can use these
        % cases...

    case 'prepare_next_trial'
        ol = value(odor_list);
        current_odor.value = ol(n_done_trials + 1);
        future_odor.value = ol(n_done_trials + 2);
        if n_done_trials>1
            previous_odor.value = ol(n_done_trials);

            eval(strcat('prev_trial=','odorType',num2str(value(previous_odor)),';'));

            value(prev_trial)
            parsed_events.states
            try
                switch value(prev_trial)
                    case 'neutral'

                    case 'go'
                        if isempty(parsed_events.states.water)

                            eval(strcat(strcat('percent_correct', num2str(value(previous_odor))),...
                                '.value = ',strcat('percent_correct', num2str(value(previous_odor))),'*',...
                                strcat('nr_odor', num2str(value(previous_odor)),'trials'),'/',...
                                '(',strcat('nr_odor', num2str(value(previous_odor)),'trials'),'+1)'));
                        else
                            eval(strcat(strcat('percent_correct', num2str(value(previous_odor))),...
                                '.value = (',strcat('percent_correct', num2str(value(previous_odor))),'*',...
                                strcat('nr_odor', num2str(value(previous_odor)),'trials'),'+1)/',...
                                '(',strcat('nr_odor', num2str(value(previous_odor)),'trials'),'+1)'));
                        end
                    case 'nogo'
                        if ~isempty(parsed_events.states.punish)

                            eval(strcat(strcat('percent_correct', num2str(value(previous_odor))),...
                                '.value = ',strcat('percent_correct', num2str(value(previous_odor))),'*',...
                                strcat('nr_odor', num2str(value(previous_odor)),'trials'),'/',...
                                '(',strcat('nr_odor', num2str(value(previous_odor)),'trials'),'+1)'));
                        else
                            eval(strcat(strcat('percent_correct', num2str(value(previous_odor))),...
                                '.value = (',strcat('percent_correct', num2str(value(previous_odor))),'*',...
                                strcat('nr_odor', num2str(value(previous_odor)),'trials'),'+1)/',...
                                '(',strcat('nr_odor', num2str(value(previous_odor)),'trials'),'+1)'));
                        end
                    case 'wait'

                        if isempty(parsed_events.states.water)

                            eval(strcat(strcat('percent_correct', num2str(value(previous_odor))),...
                                '.value = ',strcat('percent_correct', num2str(value(previous_odor))),'*',...
                                strcat('nr_odor', num2str(value(previous_odor)),'trials'),'/',...
                                '(',strcat('nr_odor', num2str(value(previous_odor)),'trials'),'+1)'));


                            if strcmp(value(WaitingAdaptiveMenu),'on') && value(WaitingMeanTime)>1
                                WaitingSection(obj,'update waiting time',0)
                            end
                        else

                            eval(strcat(strcat('percent_correct', num2str(value(previous_odor))),...
                                '.value = (',strcat('percent_correct', num2str(value(previous_odor))),'*',...
                                strcat('nr_odor', num2str(value(previous_odor)),'trials'),'+1)/',...
                                '(',strcat('nr_odor', num2str(value(previous_odor)),'trials'),'+1)'));
                            %WaitingMeanTime.value=3

                            if strcmp(value(WaitingAdaptiveMenu),'on') && value(WaitingMeanTime)<4
                                WaitingSection(obj,'update waiting time',1)
                            end
                        end
                    case 'active avoid'
                        if ~isempty(parsed_events.states.punish)

                            eval(strcat(strcat('percent_correct', num2str(value(previous_odor))),...
                                '.value = ',strcat('percent_correct', num2str(value(previous_odor))),'*',...
                                strcat('nr_odor', num2str(value(previous_odor)),'trials'),'/',...
                                '(',strcat('nr_odor', num2str(value(previous_odor)),'trials'),'+1)'));
                        else
                            eval(strcat(strcat('percent_correct', num2str(value(previous_odor))),...
                                '.value = (',strcat('percent_correct', num2str(value(previous_odor))),'*',...
                                strcat('nr_odor', num2str(value(previous_odor)),'trials'),'+1)/',...
                                '(',strcat('nr_odor', num2str(value(previous_odor)),'trials'),'+1)'));
                        end
                end
                eval(strcat(strcat('nr_odor', num2str(value(previous_odor)),'trials'),...
                    '.value = ',strcat('nr_odor', num2str(value(previous_odor)),'trials'),'+1;'));
            end
        end



        StateMatrixSection(obj, 'next_trial');

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


        if ~isempty(latest_parsed_events.states.starting_state),
            %             fprintf(1, 'moved from state : "%s" to state : "%s"\n', ...
            %                 latest_parsed_events.states.starting_state, latest_parsed_events.states.ending_state);
            %latest_parsed_events.pokes
        end;


        %---------------------------------------------------------------
        %          CASE CLOSE
        %---------------------------------------------------------------
    case 'close'
        PokesPlotSection(obj, 'close');
        if exist('myfig', 'var') && isa(myfig, 'SoloParamHandle') && ishandle(value(myfig)),
            delete(value(myfig));
        end;
        delete_sphandle('owner', ['^@' class(obj) '$']);

        Write(value(olf), ['Bank' num2str(value(olf_bank_C_ID)) '_Valves'], 0);
        Write(value(olf), ['Bank' num2str(value(olf_bank_H_ID)) '_Valves'], 0);

    otherwise,
        warning('Unknown action! "%s"\n', action);
end;

return;
end



