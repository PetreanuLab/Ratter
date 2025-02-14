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

function [x, y] = RandomSection(obj, action, x, y)
   
GetSoloFunctionArgs;

switch action

    case 'init',
    
    SoloParamHandle(obj, 'myfig', 'value', figure, 'saveable', 0);
    name = 'Random Protocol'; 
    set(value(myfig), 'Name', name, 'Tag', name, ...
          'closerequestfcn', 'dispatcher(''close_protocol'')', 'MenuBar', 'none');
    set(value(myfig), 'Position', [1000   400   832   315], 'Visible', 'on');
    x = 1; y = 1;

%     NumEditParam(obj, 'nOdorConcentrations', 0, x, y, ...
%         'label', 'Number of odor concentrations', 'labelfraction', 0.7); next_row(y, 1);
%     DispParam(obj, 'odorPresent', 'No', x, y, 'label', ' Odor Present'); next_row(y,1);

    DispParam(obj, 'odorConcentration', 0, x, y, ...
        'label', 'Odor concentration (%)', 'labelfraction', 0.7); next_row(y,1);

    PushbuttonParam(obj, 'SetOdorConcVector', x, y, 'label','Set odor concentration vector', ...
        'position', [x y 200 25], 'BackgroundColor', [0.75 0.75 0.80]); next_row(y,1);
    set_callback(SetOdorConcVector, {'RandomSection', 'setOdorConcVector'}); %next_row(y,1);
    NumEditParam(obj, 'conc1', NaN, x, y, 'label', 'Concentration 1'); next_row(y,1);
    NumEditParam(obj, 'conc2', NaN, x, y, 'label', 'Concentration 2'); next_row(y,1);
    NumEditParam(obj, 'conc3', NaN, x, y, 'label', 'Concentration 3'); next_row(y,1);
    NumEditParam(obj, 'conc4', NaN, x, y, 'label', 'Concentration 4'); next_row(y,1);
    NumEditParam(obj, 'conc5', NaN, x, y, 'label', 'Concentration 5'); next_row(y,1.5);
    SubHeaderParam(obj, 'setConcentrations', 'Set Concentrations', x, y); next_row(y,1.5);
    
%     DispParam(obj, 'leftPort', 0, x, y, ...
%         'label', 'Left port choices', 'labelfraction', 0.5); next_row(y,1);
%     DispParam(obj, 'rightPort', 0, x, y, ...
%         'label', 'Right port choices', 'labelfraction', 0.5); next_row(y,1.5);
%     SubHeaderParam(obj, 'LeftRightChoices', 'Left/Right Choices', x, y); next_row(y,1.5);
    
    DispParam(obj, 'errorChoiceConc5', 0, x, y, ...
        'label', 'Error', 'labelfraction', 0.5); next_row(y,1);
    DispParam(obj, 'correctChoiceConc5', 0, x, y, ...
        'label', 'Correct no water', 'labelfraction', 0.5); next_row(y,1);
    DispParam(obj, 'correctChoiceWaterConc5', 0, x, y, ...
        'label', 'Correct with water', 'labelfraction', 0.5); next_row(y,1.5);
    SubHeaderParam(obj, 'Conc5', 'Concentration 5', x, y); next_row(y,1.5);
    
    DispParam(obj, 'errorChoiceConc4', 0, x, y, ...
        'label', 'Error', 'labelfraction', 0.5); next_row(y,1);
    DispParam(obj, 'correctChoiceConc4', 0, x, y, ...
        'label', 'Correct', 'labelfraction', 0.5); next_row(y,1);
    DispParam(obj, 'correctChoiceWaterConc4', 0, x, y, ...
        'label', 'Correct with water', 'labelfraction', 0.5); next_row(y,1.5);
    SubHeaderParam(obj, 'Conc4', 'Concentration 4', x, y); next_row(y,1.5);
    
    DispParam(obj, 'errorChoiceConc3', 0, x, y, ...
        'label', 'Error', 'labelfraction', 0.5); next_row(y,1);
    DispParam(obj, 'correctChoiceConc3', 0, x, y, ...
        'label', 'Correct', 'labelfraction', 0.5); next_row(y,1);
    DispParam(obj, 'correctChoiceWaterConc3', 0, x, y, ...
        'label', 'Correct with water', 'labelfraction', 0.5); next_row(y,1.5);
    SubHeaderParam(obj, 'Conc3', 'Concentration 3', x, y); next_row(y,1.5);
    
    DispParam(obj, 'errorChoiceConc2', 0, x, y, ...
        'label', 'Error', 'labelfraction', 0.5); next_row(y,1);
    DispParam(obj, 'correctChoiceConc2', 0, x, y, ...
        'label', 'Correct', 'labelfraction', 0.5); next_row(y,1);
    DispParam(obj, 'correctChoiceWaterConc2', 0, x, y, ...
        'label', 'Correct with water', 'labelfraction', 0.5); next_row(y,1.5);
    SubHeaderParam(obj, 'Conc2', 'Concentration 2', x, y); next_row(y,1.5);
    
    DispParam(obj, 'errorChoiceConc1', 0, x, y, ...
        'label', 'Error', 'labelfraction', 0.5); next_row(y,1);
    DispParam(obj, 'correctChoiceConc1', 0, x, y, ...
        'label', 'Correct', 'labelfraction', 0.5); next_row(y,1);
    DispParam(obj, 'correctChoiceWaterConc1', 0, x, y, ...
        'label', 'Correct with water', 'labelfraction', 0.5); next_row(y,1.5);
    SubHeaderParam(obj, 'Conc2', 'Concentration 1', x, y); next_row(y,1.5);
    
    DispParam(obj, 'errorChoiceBlank', 0, x, y, ...
        'label', 'Error', 'labelfraction', 0.5); next_row(y,1);
    DispParam(obj, 'correctChoiceBlank', 0, x, y, ...
        'label', 'Correct', 'labelfraction', 0.5); next_row(y,1);
    DispParam(obj, 'correctChoiceWaterBlank', 0, x, y, ...
        'label', 'Correct with water', 'labelfraction', 0.5); next_row(y,1.5);
    SubHeaderParam(obj, 'Blank', 'Blank', x, y); next_row(y,1.5);

%     SoloParam(obj, 'valveNumber')
%     nOdorConcentrations = 4;

%     PushbuttonParam(obj, 'SetOdorValvesVector', x, y, 'label','Set odor valves vector', ...
%         'position', [x y 200 25], 'BackgroundColor', [0.75 0.75 0.80]); next_row(y,1);
%     set_callback(SetOdorValvesVector, {'YesOrNoSection', 'setOdorValvesVector'}); %next_row(y,1);
%     NumEditParam(obj, 'probYesValve', 0.5, x, y, 'label', 'Prob. Yes valve');next_row(y,1.5);
%     
%     SoloParamHandle(obj, 'odorValvesOpening');
%     odorValvesOpening.value = zeros(1,1000);
    
    
    SoloParamHandle(obj, 'concentrations');
%     concentrations.value = zeros(1,value(nOdorConcentrations)+1);
%     concentrations(1,1) = 0;
%     concentrations(1,2) = 0.0001;
%     concentrations(1,3) = 0.001; 
%     concentrations(1,4) = 0.01;
%     concentrations(1,5) = 0.1;
    
    SoloParamHandle(obj, 'odorConcVector');
    odorConcVector.value = zeros(1,1200);
%     SoloParamHandle(obj, 'LodorConcVector');
%     LodorConcVector.value = length(value(odorConcVector))
    
        
%     disp(value(odorConcVector(1,n_started_trials + 1)))
    
%     if value(odorConcVector(1,n_started_trials + 1)) == 0,
%         odorPresent.value = 'No';
%         odorConcentration.value = 0;
%         valveNumber.value = 1;
%     elseif value(odorConcVector(1,n_started_trials + 1)) == value(conc1)
%         odorPresent.value = 'Yes';
%         odorConcentration.value = value(conc1);
%         valveNumber.value = 2;
%     elseif value(odorConcVector(1,n_started_trials + 1)) == value(conc2)
%         odorPresent.value = 'Yes';
%         odorConcentration.value = value(conc2);
%         valveNumber.value = 3;
%     elseif value(odorConcVector(1,n_started_trials + 1)) == value(conc3)
%         odorPresent.value = 'Yes';
%         odorConcentration.value = value(conc3);
%         valveNumber.value = 4;
%     elseif value(odorConcVector(1,n_started_trials + 1)) == value(conc5)
%         odorPresent.value = 'Yes';
%         odorConcentration.value = value(conc4);
%         valveNumber.value = 5;
%     elseif value(odorConcVector(1,n_started_trials + 1)) == value(conc6)
%         odorPresent.value = 'Yes';
%         odorConcentration.value = value(conc5);
%         valveNumber.value = 6;
%     end
    
%         odorPresent.value = 'No';
%         valveNumber.value = 1;
%     else
%         odorPresent.value = 'Yes';
%         valveNumber.value = ceil(1 + (nOdorConcentrations - 1) * rand);
%     end
    
%     if rand > 0.5
%         valveNumber.value = value(nOdorConcentrations) + 1;
%     else %if rand < 1/8
%         valveNumber.value = ceil(nOdorConcentrations * rand);
%     end 

    
%     if value(valveNumber) == 1,
%         odorPresent.value = 'Yes';
%         odorConcentration.value = 0.1;
%     elseif value(valveNumber) == 2,
%         odorPresent.value = 'Yes';
%         odorConcentration.value = 0.2;
%     elseif value(valveNumber) == 3,
%         odorPresent.value = 'Yes';
%         odorConcentration.value = 0.3;
%     elseif value(valveNumber) == 4,
%         odorPresent.value = 'Yes';
%         odorConcentration.value = 0.4;
%     elseif value(valveNumber) > value(nOdorConcentrations),
%         odorPresent.value = 'No';
%         odorConcentration.value = 0;
%     end

    
    
%     if value(valveNumber) <= value(nOdorConcetrations),
%         odorPresent.value = 'Yes';
%     elseif value(valveNumber) > value(nOdorConcetrations),
%         odorPresent.value = 'No';
%     end
    


%     SoloFunctionAddVars('StateMatrixSection', 'rw_args', {'valveNumber', 'odorPresent'});
    
%     case 'setOdorValvesVector',
% %     valvesOpening.value = zeros(2,value(matrixLength));
%     odorValvesOpening(1,:) = rand (1,1000) < value(probYesValve);


   case 'setOdorConcVector'
       
        if isnan(value(conc1)) == 0 && isnan(value(conc2))== 1 && isnan(value(conc3))== 1 && isnan(value(conc4))== 1 && isnan(value(conc5))== 1
            concentrations.value = value(conc1);
        elseif isnan(value(conc1)) == 0 && isnan(value(conc2))== 0 && isnan(value(conc3))== 1 && isnan(value(conc4))== 1 && isnan(value(conc5))== 1
            concentrations.value = zeros(1,2);
            concentrations(1,1) = value(conc1);
            concentrations(1,2) = value(conc2);
        elseif isnan(value(conc1)) == 0 && isnan(value(conc2))== 0 && isnan(value(conc3))== 0 && isnan(value(conc4))== 1 && isnan(value(conc5))== 1
            concentrations.value = zeros(1,3);
            concentrations(1,1) = value(conc1);
            concentrations(1,2) = value(conc2);
            concentrations(1,3) = value(conc3);
       elseif isnan(value(conc1)) == 0 && isnan(value(conc2))== 0 && isnan(value(conc3))== 0 && isnan(value(conc4))== 0 && isnan(value(conc5))== 1
            concentrations.value = zeros(1,4);
            concentrations(1,1) = value(conc1);
            concentrations(1,2) = value(conc2);
            concentrations(1,3) = value(conc3);
            concentrations(1,4) = value(conc4);
        elseif isnan(value(conc1)) == 0 && isnan(value(conc2))== 0 && isnan(value(conc3))== 0 && isnan(value(conc4))== 0 && isnan(value(conc5))== 0
            concentrations.value = zeros(1,4);
            concentrations(1,1) = value(conc1);
            concentrations(1,2) = value(conc2);
            concentrations(1,3) = value(conc3);
            concentrations(1,4) = value(conc4);
            concentrations(1,5) = value(conc5);
        end
        
%         case 'setOdorConcVector'
%         if isnan(value(conc1)) == 0 && value(conc2)==0 && value(conc3)==0 && value(conc4)==0 && value(conc5)==0
%             concentrations.value = value(conc1);
%         elseif value(conc1)~=0 && value(conc2)~=0 && value(conc3)==0 && value(conc4)==0 && value(conc5)==0
%             concentrations.value = zeros(1,2);
%             concentrations(1,1) = value(conc1);
%             concentrations(1,2) = value(conc2);
%         elseif value(conc1)~=0 && value(conc2)~=0 && value(conc3)~=0 && value(conc4)==0 && value(conc5)==0
%             concentrations.value = zeros(1,3);
%             concentrations(1,1) = value(conc1);
%             concentrations(1,2) = value(conc2);
%             concentrations(1,3) = value(conc3);
%        elseif value(conc1)~=0 && value(conc2)~=0 && value(conc3)~=0 && value(conc4)~=0 && value(conc5)==0
%             concentrations.value = zeros(1,4);
%             concentrations(1,1) = value(conc1);
%             concentrations(1,2) = value(conc2);
%             concentrations(1,3) = value(conc3);
%             concentrations(1,4) = value(conc4);
%         elseif value(conc1)~=0 && value(conc2)~=0 && value(conc3)~=0 && value(conc4)~=0 && value(conc5)~=0
%             concentrations.value = zeros(1,4);
%             concentrations(1,1) = value(conc1);
%             concentrations(1,2) = value(conc2);
%             concentrations(1,3) = value(conc3);
%             concentrations(1,4) = value(conc4);
%             concentrations(1,5) = value(conc5);
%         end
        
        LodorConcVector = length(value(odorConcVector));
        Lconcentrations = length(value(concentrations));

        for i = 1 : Lconcentrations
%             i;
%             LodorConcVector/2*(1+(i-1)/Lconcentrations)+1;
%             LodorConcVector/2*(1+i/Lconcentrations);
%             value(concentrations(1,i));
%             (LodorConcVector/2*(1+(i-1)/Lconcentrations)+1 : ...
%                 LodorConcVector/2*(1+i/Lconcentrations));
            odorConcVector(round(LodorConcVector/2*(1+(i-1)/Lconcentrations)+1) : ...
                round(LodorConcVector/2*(1+i/Lconcentrations))) = value(concentrations(1,i)); 
%         odorConcVector(value(LodorConcVector)/2+1 : value(LodorConcVector)/2+value(LodorConcVector)/2*2/Lconcentrations) = value(concentrations(1,2)); 
%         odorConcVector(value(LodorConcVector)/2+1 : value(LodorConcVector)/2+value(LodorConcVector)/2*3/Lconcentrations) = value(concentrations(1,3)); 
%         odorConcVector(value(LodorConcVector)/2+1 : value(LodorConcVector)/2+value(LodorConcVector)/2*4/Lconcentrations) = value(concentrations(1,4)); 
        end
        
        disp(value(odorConcVector));
        
        p = randperm(value(LodorConcVector));
        
        disp(value(odorConcVector(p)));

        odorConcVector(1,:) = value(odorConcVector(p));
        
%         disp(value(odorConcVector(1,n_started_trials + 1)))

    if value(odorConcVector(1,n_started_trials + 1)) == 0,
        odorPresent.value = 'No';
        odorConcentration.value = 0;
        valveNumber.value = 1;
    elseif value(odorConcVector(1,n_started_trials + 1)) == value(conc1)
        odorPresent.value = 'Yes';
        odorConcentration.value = value(conc1);
        valveNumber.value = 2;
    elseif value(odorConcVector(1,n_started_trials + 1)) == value(conc2)
        odorPresent.value = 'Yes';
        odorConcentration.value = value(conc2);
        valveNumber.value = 3;
    elseif value(odorConcVector(1,n_started_trials + 1)) == value(conc3)
        odorPresent.value = 'Yes';
        odorConcentration.value = value(conc3);
        valveNumber.value = 4;
    elseif value(odorConcVector(1,n_started_trials + 1)) == value(conc4)
        odorPresent.value = 'Yes';
        odorConcentration.value = value(conc4);
        valveNumber.value = 5;
    elseif value(odorConcVector(1,n_started_trials + 1)) == value(conc5)
        odorPresent.value = 'Yes';
        odorConcentration.value = value(conc5);
        valveNumber.value = 6;
    end
    
        
        
    case 'next_trial',
        
    if n_done_trials == 0,
%         numberTrials.value = 0;
%         SwitchInNTrials.value = value(TrialsPerBlock) + 1;
        return,
    end;
   
%    value(odorConcVector);
%    n_started_trials + 1
%    value(odorConcVector(1,n_started_trials + 1))
%    disp(value(conc1))
%    disp(value(conc2))
%    disp(value(conc3))
%    disp(value(conc4))
%    disp(value(conc5))
    
   if value(odorConcVector(1,n_started_trials + 1)) == 0,
        odorPresent.value = 'No'
        odorConcentration.value = 0
        valveNumber.value = 1;
    elseif value(odorConcVector(1,n_started_trials + 1)) == value(conc1)
        odorPresent.value = 'Yes'
        odorConcentration.value = value(conc1)
        valveNumber.value = 2;
    elseif value(odorConcVector(1,n_started_trials + 1)) == value(conc2)
        odorPresent.value = 'Yes';
        odorConcentration.value = value(conc2);
        valveNumber.value = 3;
    elseif value(odorConcVector(1,n_started_trials + 1)) == value(conc3)
        odorPresent.value = 'Yes';
        odorConcentration.value = value(conc3);
        valveNumber.value = 4;
    elseif value(odorConcVector(1,n_started_trials + 1)) == value(conc4)
        odorPresent.value = 'Yes';
        odorConcentration.value = value(conc4);
        valveNumber.value = 5;
    elseif value(odorConcVector(1,n_started_trials + 1)) == value(conc5)
        odorPresent.value = 'Yes';
        odorConcentration.value = value(conc5);
        valveNumber.value = 6;
    end
    
   
%     if rand > 0.5
%         valveNumber.value = value(nOdorConcentrations) + 1;
%     elseif rand < 1/8
%         valveNumber.value = ceil(nOdorConcentrations * rand);
%     end 

    
    
%     if value(valveNumber) == 1,
%         odorPresent.value = 'Yes';
%         odorConcentration.value = 0.1;
%     elseif value(valveNumber) == 2,
%         odorPresent.value = 'Yes';
%         odorConcentration.value = 0.2;
%     elseif value(valveNumber) == 3,
%         odorPresent.value = 'Yes';
%         odorConcentration.value = 0.3;
%     elseif value(valveNumber) == 4,
%         odorPresent.value = 'Yes';
%         odorConcentration.value = 0.4;
%     elseif value(valveNumber) > value(nOdorConcetrations),
%         odorPresent.value = 'No';
%         odorConcentration.value = 0;
%     end
    
    
    if value(odorConcVector(1,n_started_trials) == 0)
        if (~isempty(parsed_events.states.right_poke_in) == 1),
            errorChoiceBlank.value = value(errorChoiceBlank) + 1;
        elseif (~isempty(parsed_events.states.left_poke_in) == 1),
            correctChoiceBlank.value = value(correctChoiceBlank) + 1;
            if (~isempty(parsed_events.states.lin_water) == 1),
                correctChoiceWaterBlank.value = value(correctChoiceWaterBlank) + 1;
            end
        end
    end
    
    if value(odorConcVector(1,n_started_trials) == value(conc1))
        if (~isempty(parsed_events.states.left_poke_in) == 1),
            errorChoiceConc1.value = value(errorChoiceConc1) + 1;
        elseif (~isempty(parsed_events.states.right_poke_in) == 1),
            correctChoiceConc1.value = value(correctChoiceConc1) + 1;
            if (~isempty(parsed_events.states.rin_water) == 1),
                correctChoiceWaterConc1.value = value(correctChoiceWaterConc1) + 1;
            end
        end
    end
    
    if value(odorConcVector(1,n_started_trials) == value(conc2))
        if (~isempty(parsed_events.states.left_poke_in) == 1),
            errorChoiceConc2.value = value(errorChoiceConc2) + 1;
        elseif (~isempty(parsed_events.states.right_poke_in) == 1),
            correctChoiceConc2.value = value(correctChoiceConc2) + 1;
            if (~isempty(parsed_events.states.rin_water) == 1),
                correctChoiceWaterConc2.value = value(correctChoiceWaterConc2) + 1;
            end
        end
    end
    
    if value(odorConcVector(1,n_started_trials) == value(conc3))
        if (~isempty(parsed_events.states.left_poke_in) == 1),
            errorChoiceConc3.value = value(errorChoiceConc3) + 1;
        elseif (~isempty(parsed_events.states.right_poke_in) == 1),
            correctChoiceConc3.value = value(correctChoiceConc3) + 1;
            if (~isempty(parsed_events.states.rin_water) == 1),
                correctChoiceWaterConc3.value = value(correctChoiceWaterConc3) + 1;
            end
        end
    end
    
    if value(odorConcVector(1,n_started_trials) == value(conc4))
        if (~isempty(parsed_events.states.left_poke_in) == 1),
            errorChoiceConc4.value = value(errorChoiceConc4) + 1;
        elseif (~isempty(parsed_events.states.right_poke_in) == 1),
            correctChoiceConc4.value = value(correctChoiceConc4) + 1;
            if (~isempty(parsed_events.states.rin_water) == 1),
                correctChoiceWaterConc4.value = value(correctChoiceWaterConc4) + 1;
            end
        end
    end
    
    if value(odorConcVector(1,n_started_trials) == value(conc5))
        if (~isempty(parsed_events.states.left_poke_in) == 1),
            errorChoiceConc5.value = value(errorChoiceConc5) + 1;
        elseif (~isempty(parsed_events.states.right_poke_in) == 1),
            correctChoiceConc5.value = value(correctChoiceConc5) + 1;
            if (~isempty(parsed_events.states.rin_water) == 1),
                correctChoiceWaterConc5.value = value(correctChoiceWaterConc5) + 1;
            end
        end
    end
%     
% %     if value(odorConcVector(1,n_started_trials + 1)) == value(conc1) ...
% %             && (~isempty(parsed_events.states.lin_no_water) == 1),
% %         errorChoiceConc1.value = value(errorChoiceConc1) + 1;
% %     elseif value(odorConcVector(1,n_started_trials + 1)) == value(conc1) ...
% %             && (~isempty(parsed_events.states.rin_water) == 1),
% %         correctChoiceConc1.value = value(correctChoiceConc1) + 1;
% %     end
% %     
% %     if value(odorConcVector(1,n_started_trials + 1)) == value(conc2) ...
% %             && (~isempty(parsed_events.states.lin_no_water) == 1),
% %         errorChoiceConc2.value = value(errorChoiceConc2) + 1;
% %     elseif value(odorConcVector(1,n_started_trials + 1)) == value(conc2) ...
% %             && (~isempty(parsed_events.states.rin_water) == 1),
% %         correctChoiceConc2.value = value(correctChoiceConc2) + 1;
% %     end
% %     
% %     if value(odorConcVector(1,n_started_trials + 1)) == value(conc3) ...
% %             && (~isempty(parsed_events.states.lin_no_water) == 1),
% %         errorChoiceConc3.value = value(errorChoiceConc3) + 1;
% %     elseif value(odorConcVector(1,n_started_trials + 1)) == value(conc3) ...
% %             && (~isempty(parsed_events.states.rin_water) == 1),
% %         correctChoiceConc3.value = value(correctChoiceConc3) + 1;
% %     end
% %     
% %     if value(odorConcVector(1,n_started_trials + 1)) == value(conc4) ...
% %             && (~isempty(parsed_events.states.lin_no_water) == 1),
% %         errorChoiceConc4.value = value(errorChoiceConc4) + 1;
% %     elseif value(odorConcVector(1,n_started_trials + 1)) == value(conc4) ...
% %             && (~isempty(parsed_events.states.rin_water) == 1),
% %         correctChoiceConc4.value = value(correctChoiceConc4) + 1;
% %     end
% %     
% %     if value(odorConcVector(1,n_started_trials + 1)) == value(conc5) ...
% %             && (~isempty(parsed_events.states.lin_no_water) == 1),
% %         errorChoiceConc5.value = value(errorChoiceConc5) + 1;
% %     elseif value(odorConcVector(1,n_started_trials + 1)) == value(conc5) ...
% %             && (~isempty(parsed_events.states.rin_water) == 1),
% %         correctChoiceConc5.value = value(correctChoiceConc5) + 1;
% %     end
                
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