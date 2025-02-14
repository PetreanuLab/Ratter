function [obj] = LaserCalib(varargin)

% It is in the following line that you can add plugin objects:
obj = class(struct, mfilename);

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



switch action,

  %---------------------------------------------------------------
  %          CASE INIT
  %---------------------------------------------------------------
  
  case 'init' 
    
    % Make main menu figure
    SoloParamHandle(obj, 'myfig', 'saveable', 0); myfig.value = figure;
    name = mfilename;
    set(value(myfig), 'Name', name, 'Tag', name, ...
      'closerequestfcn', 'dispatcher(''close_protocol'')', 'MenuBar', 'none');

    % At this point we have one SoloParamHandle, myfig
    % Let's put the figure where we want it and give it a reasonable size:
    set(value(myfig), 'Position', [500   104   200   5]);

    x = 5; y = 5;             % Initial position on main GUI window
    
    
    NumeditParam(obj, 'position', [0 0], x, y, 'TooltipString', ...
            'Position to simulate real calibration');next_row(y);
    PushbuttonParam(obj, 'save_all', x, y, 'position', [x y 200 30],...
            'BackgroundColor', [0 1 0],'TooltipString',...
            'Saves all calibration parameters to a MAT-file.'); next_row(y,1.75);
    set_callback(save_all, {'LaserCalib', 'save_all'}); 

    ToggleParam(obj, 'start_calib', 0, x, y, 'OnString', 'Calibrating...', ...
      'OffString', 'Start Calibrating!', 'TooltipString', 'Start of Calibration'); 
    set_callback(start_calib, {mfilename, 'show_hide'}); %#ok<NODEF> (Defined just above)
    next_row(y); 
    NumeditParam(obj, 'pulseDuration', 2, x, y, 'TooltipString', ...
            'Pulse Duration (s)');next_row(y);
    
    HeaderParam(obj, 'LaserCalibration', 'Laser Calibration', x, y);next_row(y);  
   
    pos = get(value(myfig), 'Position');
    set(value(myfig), 'Position', [pos(1:2) 205 150]);
    
    
   % Create figure STEP1 of calibration, and set it to be invisible until 
   % button is pressed
    SoloParamHandle(obj, 'calib_fig', 'saveable', 0); calib_fig.value = figure;
    set(value(calib_fig), 'Position', [700   100   200   5], 'Visible', 'off',...
        'closerequestfcn', 'LaserCalib(''close1'')');
    
    x=5;y=5; 
    
    
    NumeditParam(obj, 'xy_amplitudes', [10 10], x, y, 'TooltipString', ...
            'Amplitude of area to flash (V)');next_row(y);
        
    ToggleParam(obj, 'corners_flash', 0, x, y, 'OnString', '4 corners flashing mode - ON', ...
      'OffString', '4 corners flashing mode - OFF', 'TooltipString', 'enters mode where flashes 4 points in sucession');     
    next_row(y);
    
     NumeditParam(obj, 'rotation', 0, x, y, 'TooltipString', ...
            'Insert rotation angle correction (in �)');next_row(y);    
    NumeditParam(obj, 'voltage_bias', [0 0], x, y, 'TooltipString', ...
            'Voltage to be added to move laser until it is in the desired position'...
            );next_row(y);
%     PushbuttonParam(obj, 'take_picture', x, y, 'position', [x y 200 30],...
%             'BackgroundColor', [0 0 1],'TooltipString', 'Takes a picture!'); next_row(y,1.75);  
    %set_callback();
     
    ToggleParam(obj, 'invert_2', 0, x, y, 'OnString', 'Invert Axis 2- ON', ...
      'OffString', 'Invert Axis 2 - OFF', 'TooltipString', 'inverts Axis 2');     
    next_row(y);
    ToggleParam(obj, 'invert_1', 0, x, y, 'OnString', 'Invert Axis 1 - ON', ...
      'OffString', 'Invert Axis 1 - OFF', 'TooltipString', 'inverts Axis 1');       
    next_row(y);
    
     ToggleParam(obj, 'switch_xy', 0, x, y, 'OnString', 'Switch XY - ON', ...
      'OffString', 'Switch XY - OFF', 'TooltipString', 'Switches places of axis 1 and 2');       
    next_row(y);

 
    pos = get(value(calib_fig), 'Position');
    set(value(calib_fig), 'Position', [pos(1:2) 200 145]);
    
   
        %Global Variables declaration.
    SoloParamHandle(obj,'AOMatrix1'); %Matrix with positions to AOSW1
    SoloParamHandle(obj,'AOMatrix2'); %Matrix with positions to AOSW2

    DeclareGlobals(obj, 'rw_args', {...
       'pulseDuration',...
       'start_calib'...
       'voltage_bias', 'xy_amplitudes', 'rotation','corners_flash',...
       'invert_1','invert_2','switch_xy',...
       'AOMatrix1','AOMatrix2'...,
       'position'});      
   

%-------------------------------------------------------------------------% 
   
    StateMatrixSection(obj, 'init');
 
   
  % ------------------------------------------------------------------
  %              SHOW HIDE
  % ------------------------------------------------------------------    
%   case 'hide',
%     start_step1.value = 0; set(value(step1_fig), 'Visible', 'off');
% 
%   case 'show',
%     start_step1.value = 1; set(value(step1_fig), 'Visible', 'on');

  case 'show_hide',
    if value(start_calib) == 1, set(value(calib_fig), 'Visible', 'on'); %#ok<NODEF> (defined by GetSoloFunctionArgs)
    else                        set(value(calib_fig), 'Visible', 'off');
    end;
 

  %---------------------------------------------------------------
  %          CASE PREPARE_NEXT_TRIAL
  %---------------------------------------------------------------
  case 'prepare_next_trial'
    fprintf(1, 'Got to a prepare_next_trial state -- making the next state matrix\n');
    
    StateMatrixSection(obj, 'next_trial');
    
  %---------------------------------------------------------------
  %          CASE TRIAL_COMPLETED
  %---------------------------------------------------------------
  case 'trial_completed'
    fprintf(1, ['\nFrom the beginning of this trial #%d to the\n' ...
      'start of the next, %g seconds elapsed.\n\n'], n_done_trials, ...
      parsed_events.states.state_0(2,1) - parsed_events.states.state_0(1,2));
  
   % PokesPlotSection(obj, 'trial_completed');
    
  %---------------------------------------------------------------
  %          CASE UPDATE
  %---------------------------------------------------------------
  case 'update'
    if ~isempty(latest_parsed_events.states.starting_state),
      fprintf(1, 'Somep''n happened! Since the last update, we''ve moved from state "%s" to state "%s"\n', ...
        latest_parsed_events.states.starting_state, latest_parsed_events.states.ending_state);
    end;
   
   % PokesPlotSection(obj, 'update');

 %---------------------------------------------------------------
 %          CASE SAVE_ALL
 %---------------------------------------------------------------  
   
  case 'save_all'
      
      voltage_bias = value(voltage_bias);
      xy_amplitudes= value(xy_amplitudes);
      rotation = value(rotation);
      invert_1=value(invert_1);
      invert_2=value(invert_2);
      switch_xy=value(switch_xy);
      
%       save('D:\FChampalimaud\ratter\Calibration\CalibParams',...
%           'voltage_bias','xy_amplitudes', 'rotation',...
%          'invert_1','invert_2','switch_xy');  
      
      save('C:\Documents and Settings\Admin\Desktop\CalibParams',...
          'voltage_bias','xy_amplitudes', 'rotation',...
          'invert_1','invert_2','switch_xy'); 
   
  %---------------------------------------------------------------
  %          CASE CLOSE
  %---------------------------------------------------------------
  case 'close'
    delete(value(myfig));
    delete(value(calib_fig));

  case 'close1'
    start_calib.value=0;
    set(value(calib_fig), 'Visible', 'off');
         
  otherwise,
    warning('Unknown action! "%s"\n', action);
end;

return;


%   %---------------------------------------------------------------
%   %          CASE STEP1
%   %---------------------------------------------------------------
%   case 'step1'
%     fprintf('Step 1 of calibration entered!\n');
%     
%       % Make a figure
%     SoloParamHandle(obj, 'step1_fig', 'saveable', 0); step1_fig.value = figure;
%     
%     name = 'step1_fig';
%     set(value(step1_fig), 'Name', name, 'Tag', name, ...
%       'closerequestfcn', 'LaserCalib(''close1'')', 'MenuBar', 'none');
% 
%     % Let's put the figure where we want it and give it a reasonable size:
%     set(value(step1_fig), 'Position', [500   104   200   5]);
%   
%     x=5; y=5;
%     
%     
%     PushbuttonParam(obj, 'take_picture', x, y, 'position', [x y 200 30],...
%             'BackgroundColor', [0 0 1],'TooltipString', 'Takes a picture!'); next_row(y,1.75);
%      %set_callback(load_image, {'LaserControlSection', 'load_img'});      
% 
%     PushbuttonParam(obj, 'next_step', x, y, 'position', [x y 200 30],...
%             'BackgroundColor', [0 1 0],'TooltipString', ...
%             'Goes to next step of calibration'); next_row(y,1.75);
%      set_callback(next_step, {'LaserCalib', 'step2'});  
%      %set_callback(next_step, {'LaserCalib','close1'});
%      
%     pos = get(value(step1_fig), 'Position');
%     set(value(step1_fig), 'Position', [pos(1:2) 205 230]);  
%     
% %      DeclareGlobals(obj, 'rw_args', {...
% %     % 'take_picture','next_step',...
% %      'voltage_bias'}); 
% %   
%   %---------------------------------------------------------------
%   %          CASE STEP2
%   %---------------------------------------------------------------
%   case 'step2'
%     fprintf('Step 2 of calibration entered!\n');
%     
%       % Make a figure
%     SoloParamHandle(obj, 'step2_fig', 'saveable', 0); step2_fig.value = figure;
%     
%     name = 'step2_fig';
%     set(value(step2_fig), 'Name', name, 'Tag', name, ...
%       'closerequestfcn', 'LaserCalib(''close2'')', 'MenuBar', 'none');
% %'dispatcher(''close_protocol'')'
%     % Let's put the figure where we want it and give it a reasonable size:
%     set(value(step2_fig), 'Position', [500   104   200   5]);
%   
%     x=5; y=5;
%     
%     PushbuttonParam(obj, 'take_picture', x, y, 'position', [x y 200 30],...
%             'BackgroundColor', [0 0 1],'TooltipString', 'Takes a picture!'); next_row(y,1.75);
%      %set_callback(load_image, {'LaserControlSection', 'load_img'});      
% 
%     PushbuttonParam(obj, 'next_step', x, y, 'position', [x y 200 30],...
%             'BackgroundColor', [0 1 0],'TooltipString', ...
%             'Goes to next step of calibration'); next_row(y,1.75);
%      %set_callback(next_step, {'LaserCalib', 'step2'});  
%     
%     pos = get(value(step2_fig), 'Position');
%     set(value(step2_fig), 'Position', [pos(1:2) 205 230]);