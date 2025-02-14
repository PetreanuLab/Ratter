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

function [x, y] = WaterProbSection(obj, action, x, y)
   
GetSoloFunctionArgs;

switch action

    case 'init',
    
%     SoloParamHandle(obj, 'myfig', 'value', figure, 'saveable', 0);
%     name = 'Side choices'; 
%     set(value(myfig), 'Name', name, 'Tag', name, ...
%           'closerequestfcn', 'dispatcher(''close_protocol'')', 'MenuBar', 'none');
%     set(value(myfig), 'Position', [1000   400   832   315], 'Visible', 'on');
%     x = 1; y = 1;
    gcf;
% 

    DispParam(obj, 'lValve', 0.113, x, y, 'label', 'Left valve open time');next_row(y,1);
    DispParam(obj, 'rValve', 0.106, x, y, 'label', 'Right valve open time');next_row(y, 1.5);

    
    PushbuttonParam(obj, 'SetValvesOpeningMatrix', x, y, 'label','Set valves opening matrix', ...
        'position', [x y 200 25], 'BackgroundColor', [0.75 0.75 0.80]); next_row(y,1);
    set_callback(SetValvesOpeningMatrix, {'WaterProbSection', 'setValvesOpeningMatrix'}); %next_row(y,1);
    NumEditParam(obj, 'probLvalve', 1, x, y, 'label', 'Prob. left valve'); next_row(y,1);
    NumEditParam(obj, 'probRvalve', 1, x, y, 'label', 'Prob. right valve');%next_row(y);
%     NumEditParam(obj, 'matrixLength', 0, x, y, 'label', 'Length of the matrix');%next_row(y,1.5)
    
    
    SoloParamHandle(obj, 'valvesOpening');
    valvesOpening.value = ones(2,1000);
    if value(valvesOpening(1,n_started_trials + 1)) == 0,
        rValve.value = 0.001;
    elseif value(valvesOpening(1,n_started_trials + 1)) == 1,
        rValve.value = 0.106;
    end
    if value(valvesOpening(2,n_started_trials + 1)) == 0,
        lValve.value = 0.001;
    elseif value(valvesOpening(2,n_started_trials + 1)) == 1,
        lValve.value = 0.113;  
    end
    
%     n_started_trials
%     disp(value(valvesOpening(1,n_started_trials)))
%     disp(value(valvesOpening(2,n_started_trials)))
    
    SoloFunctionAddVars('StateMatrixSection', 'rw_args', ...
        {'rValve', 'lValve'});
%     SoloFunctionAddVars('olfprotocol', 'rw_args', {'rValve', 'lValve'});

    case 'setValvesOpeningMatrix',
%     valvesOpening.value = zeros(2,value(matrixLength));
%     valvesOpening(1,:) = rand (1,value(matrixLength)) < value(probRvalve);
%     valvesOpening(2,:) = rand (1,value(matrixLength)) < value(probLvalve);
    valvesOpening(1,:) = rand (1,1000) < value(probRvalve);
    valvesOpening(2,:) = rand (1,1000) < value(probLvalve);
    
    case 'next_trial',
        
    if n_done_trials == 0,
        return,
    end;
%     n_started_trials
%     
%     disp(value(valvesOpening(1,n_started_trials)))
%     disp(value(valvesOpening(2,n_started_trials)))
    
    if value(valvesOpening(1,n_started_trials + 1)) == 0,
        rValve.value = 0.001;
    elseif value(valvesOpening(1,n_started_trials + 1)) == 1,
        rValve.value = 0.106;
    end
    if value(valvesOpening(2,n_started_trials + 1)) == 0,
        lValve.value = 0.001;
    elseif value(valvesOpening(2,n_started_trials + 1)) == 1,
        lValve.value = 0.113;  
    end
    
%     n_started_trials
%     disp(value(valvesOpening(1,n_started_trials)))
%     disp(value(valvesOpening(2,n_started_trials)))
%     if n_done_trials == 0,
% %         numberTrials.value = 0;
% %         SwitchInNTrials.value = value(TrialsPerBlock) + 1;
%         return,
%     end;
     
    
%     if (~isempty(parsed_events.states.left_poke_in_water) == 1),
%         leftPort.value = value(leftPort) + 1;
%     elseif (~isempty(parsed_events.states.right_poke_in_water) == 1),
%         rightPort.value = value(rightPort) + 1;
%     end
    
    
%   ------------------------------------------------------------------
%                CLOSE
%   ------------------------------------------------------------------    
  case 'close'    
    % Delete all SoloParamHandles who belong to this object and whose
    % fullname starts with the name of this mfile:
    
    if exist('myfig', 'var') && isa(myfig, 'SoloParamHandle') && ishandle(value(myfig)),
      delete(value(myfig));
    end;    
    delete_sphandle('owner', ['^@' class(obj) '$'], 'fullname', ['^' mfilename '_']);

    
  % ------------------------------------------------------------------
  %              REINIT
  % ------------------------------------------------------------------    
%   case 'reinit'
%     x = my_xyfig(1); y = my_xyfig(2); origfig = my_xyfig(3);
%     currfig = gcf;
%     
%     feval(mfilename, obj, 'close');
%     
%     figure(origfig);
%     feval(mfilename, obj, 'init', x, y);
%     figure(currfig);

    
 
%   case 'reinit',
% %     currfig = gcf;
% 
%     % Get the original GUI position and figure:
%     x = my_gui_info(1); y = my_gui_info(2); origfig = my_gui_info(3);
% 
%     
%     feval(mfilename, obj, 'close');
%     figure(origfig);
% %     delete_sphandle('owner', ['^@' class(obj) '$'], ...
% %       'fullname', ['^' mfilename]);
% 
%     % Reinitialise at the original GUI position and figure:
%     [x, y] = feval(mfilename, obj, 'init', x, y);
% 
%     % Restore the current figure:
%     figure(currfig);
end;