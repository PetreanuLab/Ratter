% [sph] = LogsliderParam(obj, parname, parval, min, max, x, y, {'position', gui_position(x, y)}, ...
%                              {'TooltipString', ''}, {'label', parname}, ...
%                              {'labelfraction', 0.5}, {'lapelpos', 'right}, ...
%                              {'param_owner', ['@' class(obj)]}, ...
%                              {'param_funcowner', determine_fullfuncname})
%
% 
% Create and instantiate in the caller's workspace a SoloParamHandle of type
% 'logslider' (a logarithmically scaled horizontal slider that has a
% numeric value).  This is just like SliderParam, except the scaling on the
% slider's steps is logarithmic, not linear.
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
% parval   The initial value of the SoloParamHandle. This should be a
%          scalar number.
%
% min      The value the SoloParamHandle will take if the slider is moved
%          all the way to the left.
%
% max      The value the SoloParamHandle will take if the slider is moved
%          all the way to the right.
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
%
%
% EXAMPLES:
% ---------
%
% >> LogsliderParam('base', 'this', 49, 0.1, 60, 5, 5, 'TooltipString', 'gee!')
%    will create a variable named this, together with a slider ranging from
%    0.1 to 20, and that currently has the value 49 next to a label saying
%    'this' at position [5, 5] in the current figure. We can then do this:
%        >> this.value = 10;
%    and change what is displayed in the slider.  Or, move the slider and
%    then ask for
%        >> value(this)
%
% >> LogsliderParam('base', 'this', 49, 0.1, 60, 5, 5, 'labelpos', 'left')
%    will put the label on the left of the slider instead of on the right.
%

% Carlos Brody wrote me sometime in late 2005. Shraddha Pai helped a lot
% with modifications and improvements.
   
function [ed] = LogsliderParam(obj, parname, parval, min, max, x, y, varargin)   
   if ischar(obj) && strcmp(obj, 'base'), param_owner = 'base';
   elseif isobject(obj),                  param_owner = ['@' class(obj)];
   else   error('obj must be an object or the string ''base''');
   end;
   
   pairs = { ...
       'param_owner',        param_owner            ; ...
       'param_funcowner',    determine_fullfuncname     ; ...
       'position',           gui_position(x, y)         ; ...
       'TooltipString',      ''                         ; ...
       'minval',             min                        ; ...
       'maxval',             max                        ; ...
       'currval',            parval                     ; ...
       'label',              parname                    ; ...
       'labelfraction',      0.5                        ; ...
       'labelpos',           'right'                    ...  
       }; parseargs(varargin, pairs);
    
   ed = SoloParamHandle(obj, parname, ...
                        'type',            'logslider', ...
                        'value',           currval,  ...
                        'minval',          minval,   ...
                        'maxval',          maxval,   ...
                        'position',        position, ...
                        'TooltipString',   TooltipString, ...
                        'label',           label, ...
                        'labelfraction',   labelfraction, ...
                        'labelpos',        labelpos, ...
                        'param_owner',     param_owner, ...
                        'param_funcowner', param_funcowner);
   assignin('caller', parname, eval(parname));
   return;
   
   
