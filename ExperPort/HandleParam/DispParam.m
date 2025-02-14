% [sph] = DispParam(obj, parname, parval, x, y, {'position', gui_position(x, y)}, ...
%                              {'TooltipString', ''}, {'label', parname}, ...
%                              {'labelfraction', 0.5}, {'lapelpos', 'right}, ...
%                              {'param_owner', ['@' class(obj)]}, ...
%                              {'save_with_settings', 0}, ...
%                              {'param_funcowner', determine_fullfuncname})
%
% 
% Create and instantiate in the caller's workspace SoloParamHandle of type
% 'disp' (a display parameter). Display parameters are not editable-- for
% editable ones, see EditParam.m or NumeditParam.m
%
%
% RETURNS:
% --------
%
% sph      The SoloParamHandle just created. Most often this return value is
%          neither asked for nor used: instead, the fact that a variable with
%          name parname will have been created is used as the return value.
%
%
% PARAMETERS:
% ------------
%
% obj      Either the string 'base' or a Matlab object to which this
%          SoloParamHandle will belong. Currently it is the class of the
%          object that matters: different instantiations of objects of the
%          same class will all share their SoloParamHandles. If obj is passed
%          as the string 'base', then no object owns this SoloParamHandle the
%          base workspace does.
%
% parname  The name with which the variable will be created. This is the
%          name with which the SoloParamHandle will be stored, and will
%          also be the name of the variable instantiated in the caller's
%          workspace.
%
% parval   The initial value of the SoloParamHandle.
%
% x, y     The position, in pixels, at which to create the GUI display for
%          the SoloParamHandle. This position refers to the lower left
%          corner of the SoloParamHandle, and is counted from the lower
%          left corner of the current figure.
%
%
% OPTIONAL PARAMETERS:
% --------------------
%
% 'position'   A 4-by-1 vector, indicating [x, y, width, height], in pixels
%          from lower left-hand corner, at which to put the GUI part of the
%          SoloParamHandle. Default value is gui_position(x, y) (see
%          gui_position.m)
%
% 'TooltipString'   A string which will be displayed if the mouse floats
%          over the GUI portion of the SoloParamHandle. Typically this is
%          used to explain to users what this variable does.
%
% 'label'  A string that indicates the label that will appear next to the
%          GUI portion of the SoloParamHandle. The default value of this is
%          parname, the name of the SoloParamHandle.
%
% 'labelpos'  A string that indicates where the label should go, relative
%          to the GUI portion of the SoloParamHandle. Default is 'right'.
%          Other admissible values are 'top', 'left', and 'bottom'.
%
% 'labelfraction'   When considering the total extent of the GUI portion of
%          the SoloParamHandle plus its label, what fraction of this should
%          be taken up by the label? Default value is 0.5. If labelpos is
%          'right' or 'left', this fraction will refer to width; if
%          labelpos is 'top' or 'bottom', this fraction will refer to
%          height.
%
% 'param_owner'  Typically used only by developers, not users of the
%          SoloParamHandle code. This optional parameter allows overriding
%          the default owner, which is ['@' class(obj)].
%
% 'param_funcowner'  Typically used only by developers, not users of the
%          SoloParamHandle code. This optional parameter allows overriding
%          the default full function owner name. The default is 
%          obtained from determine_fullfuncname.m
%
% 'save_with_settings'   0    By default DispParams are not saved with
%          settings. If you pass this default argument as 1, the DispParam
%          will be saved with the settings.
%
%
%
% EXAMPLES:
% ---------
%
% >> DispParam('base', 'this', 'phooo!', 10, 20, 'TooltipString', 'gee!')
%    will create a variable named this, together with a textbox that says
%    'phoo!' next to a label saying 'this' at position [10, 20] in the
%    current figure. We can then do this:
%        >> this.value = 10;
%    and change what is displayed in the text box.
%
% >> DispParam('base', 'this', 'phooo!', 10, 20, 'labelpos', 'left');
%    will put the label on the left of the textbox instead of on the right.
%

% Carlos Brody wrote me sometime in late 2005. Shraddha Pai helped a lot
% with modifications and improvements.



function [dp] = DispParam(obj, parname, parval, x, y, varargin)

   if ischar(obj) && strcmp(obj, 'base'), param_owner = 'base';
   elseif isobject(obj),                  param_owner = ['@' class(obj)];
   else   error('obj must be an object or the string ''base''');
   end;
   
   pairs = { ...
       'param_owner',        param_owner            ; ...
       'param_funcowner',    determine_fullfuncname     ; ...
       'position',           gui_position(x, y)         ; ...
       'TooltipString',      ''                         ; ...
       'label',              parname                    ; ...
       'labelfraction',      0.5,                       ; ...
       'save_with_settings',   0                    ; ...
       'labelpos',           'right'                    ...  
   }; parseargs(varargin, pairs);
    

   dp = SoloParamHandle(obj, parname, ...
                        'type',            'disp', ...
                        'value',           parval, ...
                        'position',        position, ...
                        'TooltipString',   TooltipString, ...
                        'label',           label, ...
                        'labelfraction',   labelfraction, ...
                        'labelpos',        labelpos, ...
                        'param_owner',     param_owner, ...
                        'save_with_settings',  save_with_settings, ...
                        'param_funcowner', param_funcowner);
   assignin('caller', parname, eval(parname));
   return;
   
