% Maria In�s Vicente - August 2009

% To run it:
%  newstartup
%  dispatcher('init')
% and select this protocol.
%
% dispatcher('close_protocol'); dispatcher('set_protocol','Masa_Withholding');
%

function [obj] = PIDtesting(varargin)

% Default object is of our own class (mfilename);
% We inherit from Plugins/@pokesplot and @soundmanager

obj = class(struct, mfilename, pokesplot, saveload);%, soundmanager);
% obj = class(struct, mfilename, pokesplot, water, saveload); %-- If you want to use plugins you have to declare them here
% obj = class(struct, mfilename, pokesplot,soundmanager,soundui,water,saveload,sidesplot,sessionmodel);

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
%

global state_machine_server;

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
    name = mfilename;  % name it
    set(value(myfig), 'Name', name, 'Tag', name, ...
      'closerequestfcn', 'dispatcher(''close_protocol'')', 'MenuBar', 'none');

    % At this point we have one SoloParamHandle, myfig
    % Let's put the figure where we want it and give it a reasonable size:
    set(value(myfig), 'Position', [500   400   832   315]);

    x = 5; y = 5; maxy=5;     % Initial position on main GUI window
    
    
    %      IMPORTANT: whatever data you want to save should be defined as a
    %      SoloParam object [whatever(obj, ....);], if you do NOT want to save
    %      things you can define it as whateverIdontwanttosave('base', ...);
    
    
    % ----------------------  Other Sections -----------------------

    % From Plugins/@saveload:
    %Initiates 'Savig Section' in the window(figure) just created, x e y =
    %position of section in the window.
    [x, y] = SavingSection(obj, 'init', x, y); next_row(y);
    SavingSection(obj,'set_autosave_frequency',10);
    
    % From Plugins/@water:
%     [x, y] = WaterValvesSection(obj, 'init', x, y); next_row(y);
   
    % The next line Displays 'nTrials' in myfig. Syntax: (obj, 'ParamName, beginning n.�, X position, Y position)   
    %For default position leave ..., x, y), x & y different from the x&y of the GUI window.  
    % If you have no psoition and a lot of additional stuff somthing will probably overlap whith     
    %somthing else, better to set position always, or learn to use the
    %next_line(y)...bah    
%     DispParam(obj, 'nTrials', 0, x, y);
    

%  % ----------------  ProtocolPhaseSection --------------------
% 
%     [x, y] = ProtocolPhaseSection(obj, 'init', x, y); next_row(y,2);     
   


    
    % ----------------  Parameters for Pokesplot --------------------
    % For plotting with the pokesplot plugin, we need to tell it what
    % colors to plot with:
    %  IMPORTANT: States in the StateMatrixSection (sma_states) should NOT have
    %  capitalized letters, if they do, the PokesPlot Plugin will not plot
    %  them. ex. waiting_4_cout works but Waiting_4_Cout will not...
    my_state_colors = struct( ...
        'pre_odor',                [0.75 0.75 0.75],   ...
        'odor_delivery',           [0.5 1 0.1],   ...
        'post_odor',               [0.1 0.5 0.5],   ...
        'final_state',             [0.75 0.25 0.25]);%   ...
%         'premature_cout',          [0.9 0.25 0],   ...
%         'go_signal',               [0.9 0.75 1],   ...
%         'cin_odor_after_go_signal',  [0.5 0.5 1], ...
%         'cout_before_go_signal',   [0.9 0.75 1],   ...
%         'too_late',   	           [0.8 0.8 0.75],   ...
%         'left_poke_in',            [0.7 0.4 0.9], ...
%         'right_poke_in',           [0.5 0 0.8], ...
%         'lin_water',      	       [0.5 1 0.75],   ...
%         'rin_water',      	       [0 0 0.5],   ...
%         'lin_no_water',      	   [0 0 1],   ...
%         'rin_no_water',      	   [0 0.5 0],   ...
%         'final_state',      	   [0.4 1 0]);%   ...
        %'cpoke_large1',          [0.5 1 0.5],   ...
        %'cpoke_large2',          [0.5 1 0.5],   ...
        %'cpoke_large3',          [0.5 1 0.5],   ...
        %'cpoke_large4',          [0.5 1 0.5],   ...
        %'short_poke1',           [1 1 0],   ...
        %'short_poke2',           [1 1 0],   ...
        %'small_available1',   	[0.8 0.8 1],   ...
        %'small_available2',   	[0.8 0.8 1],   ...
        %'large_available1',  	[0.9 0.75 1],   ...
        %'large_available2',  	[0.9 0.75 1],   ...
        %'pre_left_small_reward',[0.5 0.5 1], ...
        %'pre_right_small_reward',[0.5 0.5 1], ...
        %'left_small_reward',    [0 0 1], ...
        %'right_small_reward',    [0 0 1], ...
        %'pre_left_large_reward',[0.7 0.4 0.9], ...
        %'pre_right_large_reward',[0.7 0.4 0.9], ...
        %'left_large_reward',    [0.5 0 0.8], ... 
        %'right_large_reward',    [0.5 0 0.8]);
    
    % In pokesplot, the poke colors have a default value, so we don't need
    % to specify them, but here they are so you know how to change them.
    %colors vary from 0 to 1 in RGB so [1 0 0] is red, [0 1 0] is green, [0 0 1] is blue and [1 1 1] is
    % white [0 0 0] is black, of course.
    my_poke_colors = struct( ...
      'L',                  0.6*[1 0.66 0],    ...
      'C',                      [0 0 0],       ...
      'R',                  0.9*[1 0.66 0]);
      
    
    % Initiates PokesPlotSection
    [x, y] = PokesPlotSection(obj, 'init', x, y, ...
      struct('states',  my_state_colors, 'pokes', my_poke_colors)); next_row(y);
    %X&Y are the default position of the button that PokesPlot adds to the
    %Saving Section Figure
%     PokesPlotSection(obj, 'hide');%this hides pokesplot
%   PokesPlotSection(obj, 'set_alignon', 'center_valve_click(1,2)');%this sets the align at the end of center_valve_click
%   Next two lines set the Xaxis limits for the PokesPlot (don't understand them compleatly but thanks to Santiago Jaramillo's protocol)  
    ThisSPH=get_sphandle('owner', mfilename, 'name','t0'); ThisSPH{1}.value = -10;
    ThisSPH=get_sphandle('owner', mfilename, 'name','t1'); ThisSPH{1}.value = 10;
    next_row(y); % I think I could remove this....?
  
    
    
    
    maxy = max(y, maxy); next_column(x); y = 5;
    
    % Make the main figure window as wide as it needs to be and as tall as
    % it needs to be; that way, no matter what each plugin requires in terms of
    % space, we always have enough space for it.
    maxy = max(y, maxy);
    pos = get(value(myfig), 'Position');
    set(value(myfig), 'Position', [pos(1:2) x+220 maxy+25]);
    
    NumeditParam(obj, 'preOdor', 0, x, y, 'label', 'Pre-odor time period', 'labelfraction', 0.75);next_row(y);
    NumEditParam(obj, 'odorDelivery', 0, x, y, 'label', 'Odor delivery time period', 'labelfraction', 0.75);next_row(y);
    NumEditParam(obj, 'postOdor', 0, x, y, 'label', 'Post-odor time period', 'labelfraction', 0.75);next_row(y,1);
    NumeditParam(obj, 'timeOut', 0.001, x, y, 'label', 'Time out', 'labelfraction', 0.75);next_row(y,1.5);
    
    %       SoloParamHandle(obj, 'PIDScans');
    SoloParamHandle(obj, 'PIDdata');
    
    
    [x, y] = OdorSection(obj, 'init', x, y); next_row(y,2);
    
    PushbuttonParam(obj, 'StartAcquiringData', x, y, 'label','Start acquiring data', ...
        'position', [x y 200 25], 'BackgroundColor', [0.75 0.75 0.80]); next_row(y,2);
    set_callback(StartAcquiringData, {'OlfTest', 'startAcquiringData'}); %next_row(y,1);
    
%     DispParam(obj, 'arrivalDate', '09Set09', x, y, 'label', 'Date of arrival');next_row(y,1.5);
%     SubHeaderParam(obj, 'RatParams', 'Rat Parameters', x, y); next_row(y,2);
    
%    % ----------------  WaitingTimeRewardSection --------------------
     
    OlfactometerSection(obj, 'init', x, y); next_row(y,1.5) 
    
%     NumeditParam(obj, 'timeOut', 1, x, y, 'label', 'Time out');next_row(y);
%     NumeditParam(obj, 'timeToGetReward', 3, x, y, 'label', 'Time to get reward');next_row(y, 1.5);
    
    
%      % ----------------  WaterProbSection --------------------
%      
%     [x, y] = WaterProbSection(obj, 'init', x, y); next_row(y,1.5)
% 
%         
%     SubHeaderParam(obj, 'GeneralParams', 'General Parameters', x, y); next_row(y,1.5);
%     
%     
%     % -----------------------  SoundsSection -----------------------
%  
%      [x, y] = SoundsSection(obj, 'init', x, y); next_row(y,1.5);
% 
%     
% %     MenuParam(obj, 'ProtocolPhase', {'water at the lateral pokes' 'wait at center poke' 'olfaction'},...
% %         'wait at center poke', x, y, 'label','Protocol phase') %, ...
%         %'labelpos', 'left', 'TooltipString','Protocol phase');



    SoloFunctionAddVars('StateMatrixSection', 'rw_args', ...
        {'preOdor', 'odorDelivery', 'postOdor', 'timeOut'});
    ..., 'waitingTime', 'TrialsPerBlock', 'SwitchInNTrials'});
    
%     SoloFunctionAddVars('WaterProbSection', 'rw_args', ...
%         {'probRvalve', 'probLvalve'});
    ..., 'waitingTime', 'TrialsPerBlock', 'SwitchInNTrials'}); 


%     SoloFunctionAddVars('WaitingTimeSection', 'rw_args', {'ProtocolPhase'});



%     NumEditParam(obj, 'leftPort', 0, x, y, ...
%         'label', 'Left port choices', 'labelfraction', 0.5); next_row(y, 1);
%     NumEditParam(obj, 'rightPort', 0, x, y, ...
%         'label', 'Right port choices', 'labelfraction', 0.5); next_row(y, 1);
    
%      SoloFunctionAddVars('ChoiceSection', 'rw_args', {'leftPort', 'rightPort'});

%      [x, y] = WaterProbSection(obj, 'init', x, y);

    % ------------------ From Plugins/@sidesplot ------------------
%     [x, y] = SidesPlotSection(obj, 'init', x, y, SidesList);
%     next_row(y);

%     SoloParamHandle(obj, 'HitHistory','value', nan(value(MaxTrials),1));
% 
%     
%     % ------------------ From PerformancePlotSection ------------------
%     PerformancePlotSection(obj, 'init', x, y, value(MaxTrials));
   
    % ----------------  OlfactometerSection --------------------
    
%     OlfactometerSection(obj, 'init');
%     [x, y] = OlfactometerSection(obj, 'init', x, y); %next_row(y);
%     OlfactionSection(obj, 'init');
     
%    AutomationSection(obj, 'init');
    
    % OK, usually the case 'init' of a protocol ends with the following
    % line.
    StateMatrixSection(obj, 'init');
%     PlotSection(obj, 'init');
  
    case 'startAcquiringData'
        
        % it looks like this only works on port1 of the breakout box... i
        % don't know why...
%          sm = RTLSM2(state_machine_server);
         sm = dispatcher('get_state_machine');
         sm = StartDAQ(sm,1);
         PIDdata.value = GetDAQScans(sm);

  
  %---------------------------------------------------------------
  %          CASE PREPARE_NEXT_TRIAL
  %---------------------------------------------------------------
  % The next cases are just set up with outputs so to understand when (during
  % the protocol) each case happens. If you want your protocol to do
  % something at a particular moment during each trial you can use these
  % cases...
    
   case 'prepare_next_trial'
   
    OdorSection(obj, 'next_trial');
%        WaitingTimeSection(obj, 'next_trial');
%        feval(mfilename, 'update');
    % -- Create and send state matrix for next trial --
       fprintf(1, 'Got to a prepare_next_trial state -- making the next state matrix\n');
       

    OlfactometerSection(obj, 'next_trial');
%     WaitingTimeRewardSection(obj, 'next_trial');
%     SoundsSection(obj, 'next_trial');
    StateMatrixSection(obj, 'next_trial');
%     PlotSection(obj, 'next_trial');
       
%        disp(n_done_trials)
       
  %---------------------------------------------------------------
  %          CASE TRIAL_COMPLETED
  %---------------------------------------------------------------
  case 'trial_completed'
    fprintf(1, ['\nFrom the beginning of this trial #%d to the\n' ...
      'start of the next, %g seconds elapsed.\n\n'], n_done_trials, ...
      parsed_events.states.state_0(2,1) - parsed_events.states.state_0(1,2));
  
  
    % --  PokesPlot needs completing the trial --
    %You need to inform the PokesPlot Plugin at what moment of the trial you
    %are so, here should go:
    PokesPlotSection(obj, 'trial_completed');
    
  %---------------------------------------------------------------
  %          CASE UPDATE
  %---------------------------------------------------------------
  case 'update'
    sm = dispatcher('get_state_machine');
    PIDdata.value = [value(PIDdata);GetDAQScans(sm)];
    OlfactometerSection(obj, 'update')
%   OlfactometerSection(obj, 'update');
%   WaitingTimeSection(obj, 'update');
  %And here should go this otherwise you will not see the plotting as it
  %happens trial by tial.
     PokesPlotSection(obj, 'update');
     if ~isempty(latest_parsed_events.states.starting_state),
        fprintf(1, 'Somep''n happened! Since the last update, we''ve moved from state "%s" to state "%s"\n', ...
         latest_parsed_events.states.starting_state, latest_parsed_events.states.ending_state);
     end;
        
     
  %---------------------------------------------------------------
  %          CASE CLOSE
  %---------------------------------------------------------------
  case 'close'
    sm = dispatcher('get_state_machine');
    sm = StopDAQ(sm);
    PokesPlotSection(obj, 'close');
    OlfactometerSection(obj, 'close');
%     PlotSection(obj, 'close');
%     YesOrNoSection(obj, 'close');
%     OlfactionSection(obj, 'close');
%     MachineSection(obj, 'initialize_machine')
    if exist('myfig', 'var') && isa(myfig, 'SoloParamHandle') && ishandle(value(myfig)),
      delete(value(myfig));
    end;
    
%     delete(value(myfig));
    delete_sphandle('owner', ['^@' class(obj) '$']);
  
    OLF_IP = Settings('get', 'RIGS', 'olfactometer_server');olf = SimpleOlfClient(OLF_IP,3336);
%     Write(olf, 'OlfBankA', 0);
%     Write(olf, 'OlfBankB', 0);
%     Write(olf, 'OlfBankC', 0);
%     Write(olf, 'OlfBankD', 0);
%     Write(olf, 'OlfBankE', 0);
    Write(olf, 'OlfBankF', 0);
%     Write(olf, 'OlfBankG', 0);
%     Write(olf, 'OlfBankH', 0);
        %Write(value(olf), ['Bank' num2str(value(olf_bank_A_ID)) '_Valves'], 0);
        %Write(value(olf), ['Bank' num2str(value(olf_bank_B_ID)) '_Valves'], 0);
        %Write(value(olf), ['Bank' num2str(value(olf_bank_C_ID)) '_Valves'], 0);
        %Write(value(olf), ['Bank' num2str(value(olf_bank_D_ID)) '_Valves'], 0);
%  Write(value(olf), 'Bank1_Valves', 0);
%   StateMatrixSection(obj, 'close');  
    
  otherwise,
    warning('Unknown action! "%s"\n', action);
end;

return;