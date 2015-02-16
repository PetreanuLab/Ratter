function  [x,y, TrialLengthConstant, TrialLength] ...
    =  TrialLengthSection(obj, action, x, y)

GetSoloFunctionArgs;

switch action
  case 'init',
    NumeditParam(obj, 'TrialLength',6,x,y,'labelfraction', 0.6);next_row(y);
    set_callback(TrialLength, {'TrialLengthSection','trial_length'});
    MenuParam(obj, 'Adjust_TL_If_Short',{'No','Yes'},1,x,y,'labelfraction', 0.6);next_row(y);
    MenuParam(obj, 'TrialLengthConstant',{'Yes','No(FixedITI)'},1,x,y,'labelfraction', 0.6);next_row(y);
    set_callback(TrialLengthConstant, {'TrialLengthSection','trial_length_constant'});
    SubheaderParam(obj, 'TrialLengthSubHeader', 'Trial Length Parameters',x,y);next_row(y);
    
    set([get_ghandle(TrialLength) get_lhandle(TrialLength) ...
         get_ghandle(Adjust_TL_If_Short) get_lhandle(Adjust_TL_If_Short)], ...
         'visible','off');
    
  case 'prepare_next_trial', %adjust TrialLength if necessary

      if n_done_trials == 0, %most likey this is called when you load settings
          %do nothing
          return;
      end;

      TRIAL_LENGTH_CONSTANT = value(TrialLengthConstant);
      TRIAL_LENGTH = value(TrialLength);
      ADJUST_TL_IF_SHORT = value(Adjust_TL_If_Short);
      
      if strcmp(TRIAL_LENGTH_CONSTANT,'Yes'),
          
          %first calculate time from cpoke to time_out1_out
              TIME_CIN_TO_ITI = parsed_events.states.signal_trial_end(1,1) ...
                  - parsed_events.states.waiting1_np(1,2);
         
          
          %if [TIME_CIN_TO_ITI + 3(for iti)] is longer than TrialLength
          %print message!!
          if TRIAL_LENGTH<=TIME_CIN_TO_ITI+3,
              fprintf('\n Real TrialLength : %g is shorter than Set TrialLength! %g\n', ...
                  TIME_CIN_TO_ITI+3, TRIAL_LENGTH);
              if strcmp(ADJUST_TL_IF_SHORT,'Yes'), %if yes adjust value
                  TRIAL_LENGTH = ceil(TIME_CIN_TO_ITI+5);
              end;
          end;
      end;

      TrialLength.value = TRIAL_LENGTH;

      
  case 'trial_length_constant',
      %callback of SPH TrialLengthConstant (in this section)
      %also called from BlockControlSection when block is switched
      %also called from case 'visualize_nose_poke_block_params' in this
      %section
      
      if strcmp(value(TrialLengthConstant),'Yes'),
          %if ParamSection_MultiPoke is valid_waiting, change it to noiseB
          ParamsSection(obj,'multi_poke_not_valid_waiting');
          %trial_length is constant, a rat has to do wait_poke
          BeginnerSection(obj, 'wait_poke_necessary_yes');
          
          set([get_ghandle(TrialLength) get_lhandle(TrialLength) ...
               get_ghandle(Adjust_TL_If_Short) get_lhandle(Adjust_TL_If_Short)], ...
               'visible','on');
          
      elseif strcmp(value(TrialLengthConstant),'No(FixedITI)'),
          set([get_ghandle(TrialLength) get_lhandle(TrialLength) ...
               get_ghandle(Adjust_TL_If_Short) get_lhandle(Adjust_TL_If_Short)], ...
               'visible','off');
      end;
      
  case 'trial_length',
        %callback of SPH TrialLength (in this section)
      if value(TrialLength) < 6,
          TrialLength.value = 6;
          fpringf('\nTrialLength has to be longer than 6sec!\n')
      end;
      
    case 'trial_length_constant_no',
        %call from PramsSection, when 'multi_poke' is set to 'valid_waiting'

        %also called from AutomationSection, when
        %Beginner, Yes; WaitPokeNecessary, No;

        TrialLengthConstant.value = 'No(FixedITI)';
        set([get_ghandle(TrialLength) get_lhandle(TrialLength) ...
            get_ghandle(Adjust_TL_If_Short) get_lhandle(Adjust_TL_If_Short)], ...
            'visible','off');      
      
  otherwise,
    warning('%s : %s  don''t know action %s\n', class(obj), mfilename, action);
end;

   
      