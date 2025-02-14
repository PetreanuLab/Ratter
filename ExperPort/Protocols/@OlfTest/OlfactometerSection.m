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
%


function [x, y] = OlfactometerSection(obj, action, x, y)
   
GetSoloFunctionArgs;


switch action

    case 'init',
        
%         gcf;
    SoloParamHandle(obj, 'myfig', 'value', figure, 'saveable', 0);
    name = 'Olfactometer Section'; 
    set(value(myfig), 'Name', name, 'Tag', name, ...
          'closerequestfcn', 'dispatcher(''close_protocol'')', 'MenuBar', 'none');
    set(value(myfig), 'Position', [1000   400   832   315], 'Visible', 'on');
    x = 1; y = 1;
 
    % -----------------------  Olf Server -----------------------
    


%       DispParam(obj, 'olf_bank_H_ID', 1, x, y, 'label', ' Bank H ID');  next_row(y,1);
%       DispParam(obj, 'olf_bank_G_ID', 1, x, y, 'label', ' Bank G ID');  next_row(y,1);
      DispParam(obj, 'olf_bank_F_ID', 1, x, y, 'label', ' Bank F ID');  next_row(y,1);
%       DispParam(obj, 'olf_bank_E_ID', 1, x, y, 'label', ' Bank E ID');  next_row(y,1);
%       DispParam(obj, 'olf_bank_D_ID', 1, x, y, 'label', ' Bank D ID');  next_row(y,1);
%       DispParam(obj, 'olf_bank_C_ID', 1, x, y, 'label', ' Bank C ID');  next_row(y,1);
      DispParam(obj, 'olf_bank_B_ID', 1, x, y, 'label', ' Bank B ID');  next_row(y,1);
%       DispParam(obj, 'olf_bank_A_ID', 1, x, y, 'label', ' Bank A ID');  next_row(y,1);
      DispParam(obj, 'olf_carrier_ID', 1, x, y, 'label', ' Carrier ID');  next_row(y,1.5);
 
   
%       DispParam(obj, 'olf_bank_H_valve', 0, x, y, 'label', ' Bank H valve'); next_row(y);
%       DispParam(obj, 'olf_bank_G_valve', 0, x, y, 'label', ' Bank G valve'); next_row(y);
      DispParam(obj, 'olf_bank_F_valve', 0, x, y, 'label', ' Bank F valve'); next_row(y);
%       DispParam(obj, 'olf_bank_E_valve', 0, x, y, 'label', ' Bank E valve'); next_row(y);
%       DispParam(obj, 'olf_bank_D_valve', 0, x, y, 'label', ' Bank D valve'); next_row(y);
%       DispParam(obj, 'olf_bank_C_valve', 0, x, y, 'label', ' Bank C valve'); next_row(y);
      DispParam(obj, 'olf_bank_B_valve', 0, x, y, 'label', ' Bank B valve'); next_row(y);
%       DispParam(obj, 'olf_bank_A_valve', 0, x, y, 'label', ' Bank A valve'); 
      next_row(y, 1.5);
      
%       DispParam(obj, 'olf_bank_H_flow',  0, x, y, 'label', ' Bank H flow rate');     next_row(y);
%       DispParam(obj, 'olf_bank_G_flow',  0, x, y, 'label', ' Bank G flow rate');     next_row(y);
      DispParam(obj, 'olf_bank_F_flow',  0, x, y, 'label', ' Bank F flow rate');     next_row(y);
%       DispParam(obj, 'olf_bank_E_flow',  0, x, y, 'label', ' Bank E flow rate');     next_row(y);
%       DispParam(obj, 'olf_bank_D_flow',  0, x, y, 'label', ' Bank D flow rate');     next_row(y);
%       DispParam(obj, 'olf_bank_C_flow',  0, x, y, 'label', ' Bank C flow rate');     next_row(y);
      DispParam(obj, 'olf_bank_B_flow',  0, x, y, 'label', ' Bank B flow rate');     next_row(y);
%       DispParam(obj, 'olf_bank_A_flow',  0, x, y, 'label', ' Bank A flow rate');     next_row(y);

      DispParam(obj, 'olf_carrier_flow', 0, x, y, 'label', ' Carrier flow rate');   next_row(y,1.5);

      SubheaderParam(obj, 'readRates', 'Read rates', x, y);
      %next_row(y,1.5); 
      next_column(x); y = 5;

  % Initialize odor settings
      PushbuttonParam(obj, 'SetOlfFlow', x, y, 'position', [x y 200 25], ...
          'BackgroundColor', [0.75 0.75 0.80]); next_row(y,1.5);
      set_callback(SetOlfFlow, {'OlfactometerSection', 'write'})
%       NumeditParam(obj, 'olf_bank_D_flow_set', 100, x, y, 'label', 'Target bankD fl.rate');  next_row(y,1);
%       NumeditParam(obj, 'olf_bank_H_flow_set', 100, x, y, 'label', 'Target bankH fl.rate');  next_row(y,1);
%       NumeditParam(obj, 'olf_bank_G_flow_set', 100, x, y, 'label', 'Target bankG fl.rate');  next_row(y,1);
      NumeditParam(obj, 'olf_bank_F_flow_set', 100, x, y, 'label', 'Target bankF fl.rate');  next_row(y,1);
%       NumeditParam(obj, 'olf_bank_E_flow_set', 100, x, y, 'label', 'Target bankE fl.rate');  next_row(y,1);
%       NumeditParam(obj, 'olf_bank_D_flow_set', 100, x, y, 'label', 'Target bankD fl.rate');  next_row(y,1);
%       NumeditParam(obj, 'olf_bank_C_flow_set', 100, x, y, 'label', 'Target bankC fl.rate');  next_row(y,1);
      NumeditParam(obj, 'olf_bank_B_flow_set', 100, x, y, 'label', 'Target bankB fl.rate');  next_row(y,1);
%       NumeditParam(obj, 'olf_bank_A_flow_set', 100, x, y, 'label', 'Target bankA fl.rate');  next_row(y,1);
      NumeditParam(obj, 'olf_carrier_flow_set', 900, x, y, 'label','Target carr. fl.rate');  next_row(y,1.5);

      SubheaderParam(obj, 'setRates', 'Set rates', x, y);
      next_row(y,1.5);

      SoloParamHandle(obj, 'OLF_IP','value','nan');

      SoloParamHandle(obj,'olf','value','nan');
      
      SoloFunctionAddVars('OlfactometerSection','rw_args','olf');
      
      DispParam(obj, 'olf_ip_set', 'nan', x, y, 'label', ' olfactometer IP'); next_row(y, 1.5);

      DispParam(obj, 'olf_status', 'disconnected', x, y, 'label', ' recent status'); next_row(y, 1.5);

      SubHeaderParam(obj, 'OlfactometerSection', 'Olfactometer Section', x, y);
        
        
      OLF_IP.value         = Settings('get', 'RIGS', 'olfactometer_server');
      olf_ip_set.value     = value(OLF_IP);
%       olf_bank_H_ID.value  = Settings('get', 'RIGS', 'olfactometer_bank_H');
%       olf_bank_G_ID.value  = Settings('get', 'RIGS', 'olfactometer_bank_G');
      olf_bank_F_ID.value  = Settings('get', 'RIGS', 'olfactometer_bank_F');
%       olf_bank_E_ID.value  = Settings('get', 'RIGS', 'olfactometer_bank_E');
%       olf_bank_D_ID.value  = Settings('get', 'RIGS', 'olfactometer_bank_D');
%       olf_bank_C_ID.value  = Settings('get', 'RIGS', 'olfactometer_bank_C');
      olf_bank_B_ID.value  = Settings('get', 'RIGS', 'olfactometer_bank_B');
%       olf_bank_A_ID.value  = Settings('get', 'RIGS', 'olfactometer_bank_A');
      olf_carrier_ID.value = Settings('get', 'RIGS', 'olfactometer_carrier');
    %   olf.value = SimpleOlfFlient(value(OLF_IP),3336);


%       disp(value(olf_bank_E_ID))
%       disp(value(olf_bank_G_ID))
%       disp(value(olf_bank_H_ID))
%       disp(value(olf_bank_D_ID))
%       disp(value(olf_carrier_ID))
%       disp(value(OLF_IP))

%       sma = StateMachineAssembler('full_trial_structure');
% 
%         sma = add_olf_bank(sma, 'name', 'OlfBankA', 'ip',...
%             value(OLF_IP), 'bank', ['Bank' num2str(value(olf_bank_E_ID))]);
%         sma = add_olf_bank(sma, 'name', 'OlfBankB', 'ip',...
%             value(OLF_IP), 'bank', ['Bank' num2str(value(olf_bank_G_ID))]);
%         sma = add_olf_bank(sma, 'name', 'OlfBankF', 'ip',...
%             value(OLF_IP), 'bank', ['Bank' num2str(value(olf_bank_H_ID))]);
%         sma = add_olf_bank(sma, 'name', 'OlfBankD', 'ip',...
%             value(OLF_IP), 'bank', ['Bank' num2str(value(olf_bank_D_ID))]);
%         
%         SoloFunctionAddVars('OdorSection', 'rw_args', {'OlfBankA', 'OlfBankB', 'OlfBankF', 'OlfBankD'});
  
%     case 'olf_connect',    
    if ~strcmpi(value(OLF_IP), 'nan'), % if the olfactometer is connected
        olf.value = SimpleOlfClient(value(OLF_IP),3336);
        olf_status.value = 'connected';
    end
  

    SoloFunctionAddVars('StateMatrixSection', 'ro_args',{'OLF_IP'});
    SoloFunctionAddVars('PIDtesting', 'ro_args',{'olf'});
    
%     SoloFunctionAddVars('StateMatrixSection', 'ro_args',{'olf_bank_H_ID'});
%     SoloFunctionAddVars('StateMatrixSection', 'ro_args',{'olf_bank_G_ID'});
    SoloFunctionAddVars('StateMatrixSection', 'ro_args',{'olf_bank_F_ID'});
%     SoloFunctionAddVars('StateMatrixSection', 'ro_args',{'olf_bank_E_ID'});
%     SoloFunctionAddVars('StateMatrixSection', 'ro_args',{'olf_bank_D_ID'});
%     SoloFunctionAddVars('StateMatrixSection', 'ro_args',{'olf_bank_C_ID'});
    SoloFunctionAddVars('StateMatrixSection', 'ro_args',{'olf_bank_B_ID'});
%     SoloFunctionAddVars('StateMatrixSection', 'ro_args',{'olf_bank_A_ID'});

%     SoloFunctionAddVars('PIDtesting', 'ro_args',{'olf_bank_H_ID'});
%     SoloFunctionAddVars('PIDtesting', 'ro_args',{'olf_bank_G_ID'});
    SoloFunctionAddVars('PIDtesting', 'ro_args',{'olf_bank_F_ID'});
%     SoloFunctionAddVars('PIDtesting', 'ro_args',{'olf_bank_E_ID'});
%     SoloFunctionAddVars('PIDtesting', 'ro_args',{'olf_bank_D_ID'});
%     SoloFunctionAddVars('PIDtesting', 'ro_args',{'olf_bank_C_ID'});
    SoloFunctionAddVars('PIDtesting', 'ro_args',{'olf_bank_B_ID'});
%     SoloFunctionAddVars('PIDtesting', 'ro_args',{'olf_bank_A_ID'});
  


    case 'write',
        % set rates
%         Write(value(olf), ['BankFlow' num2str(value(olf_bank_H_ID)) '_Actuator'], value(olf_bank_H_flow_set));
%         Write(value(olf), ['BankFlow' num2str(value(olf_bank_G_ID)) '_Actuator'], value(olf_bank_G_flow_set));
        Write(value(olf), ['BankFlow' num2str(value(olf_bank_F_ID)) '_Actuator'], value(olf_bank_F_flow_set));
%         Write(value(olf), ['BankFlow' num2str(value(olf_bank_E_ID)) '_Actuator'], value(olf_bank_E_flow_set));
%         Write(value(olf), ['BankFlow' num2str(value(olf_bank_D_ID)) '_Actuator'], value(olf_bank_D_flow_set));
%         Write(value(olf), ['BankFlow' num2str(value(olf_bank_C_ID)) '_Actuator'], value(olf_bank_C_flow_set));
        Write(value(olf), ['BankFlow' num2str(value(olf_bank_B_ID)) '_Actuator'], value(olf_bank_B_flow_set));
%         Write(value(olf), ['BankFlow' num2str(value(olf_bank_A_ID)) '_Actuator'], value(olf_bank_A_flow_set));
        % Write(value(olf), ['Carrier' num2str(value(olf_carrier_ID)) '_Actuator'], value(olf_carrier_flow_set));

    case 'update',
        
        % read rates
%         olf_bank_H_valve.value = Read(value(olf), ['Bank' num2str(value(olf_bank_H_ID)) '_Valves']);
%         olf_bank_G_valve.value = Read(value(olf), ['Bank' num2str(value(olf_bank_G_ID)) '_Valves']);
        olf_bank_F_valve.value = Read(value(olf), ['Bank' num2str(value(olf_bank_F_ID)) '_Valves']);
%         olf_bank_E_valve.value = Read(value(olf), ['Bank' num2str(value(olf_bank_E_ID)) '_Valves']);
%         olf_bank_D_valve.value = Read(value(olf), ['Bank' num2str(value(olf_bank_D_ID)) '_Valves']);
%         olf_bank_C_valve.value = Read(value(olf), ['Bank' num2str(value(olf_bank_C_ID)) '_Valves']);
        olf_bank_B_valve.value = Read(value(olf), ['Bank' num2str(value(olf_bank_B_ID)) '_Valves']);
%         olf_bank_A_valve.value = Read(value(olf), ['Bank' num2str(value(olf_bank_A_ID)) '_Valves']);

%         olf_bank_H_flow.value = Read(value(olf), ['BankFlow' num2str(value(olf_bank_H_ID)) '_Sensor']);
%         olf_bank_G_flow.value = Read(value(olf), ['BankFlow' num2str(value(olf_bank_G_ID)) '_Sensor']);
        olf_bank_F_flow.value = Read(value(olf), ['BankFlow' num2str(value(olf_bank_F_ID)) '_Sensor']);
%         olf_bank_E_flow.value = Read(value(olf), ['BankFlow' num2str(value(olf_bank_E_ID)) '_Sensor']);
%         olf_bank_D_flow.value = Read(value(olf), ['BankFlow' num2str(value(olf_bank_D_ID)) '_Sensor']);
%         olf_bank_C_flow.value = Read(value(olf), ['BankFlow' num2str(value(olf_bank_C_ID)) '_Sensor']);
        olf_bank_B_flow.value = Read(value(olf), ['BankFlow' num2str(value(olf_bank_B_ID)) '_Sensor']);
%         olf_bank_A_flow.value = Read(value(olf), ['BankFlow' num2str(value(olf_bank_A_ID)) '_Sensor']);
        %olf_carrier_flow.value = Read(value(olf), ['Carrier' num2str(value(olf_carrier_ID)) '_Sensor']);


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
%     currfig = gcf;
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