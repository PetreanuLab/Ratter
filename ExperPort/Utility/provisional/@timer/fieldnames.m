function out = fieldnames(obj, flag)
%FIELDNAMES Get timer object property names.
%
%    NAMES = FIELDNAMES(OBJ) returns a cell array of strings containing 
%    the names of the properties associated with timer object, OBJ.
%    OBJ must be a 1-by-1 timer object.
%
%    NAMES = FIELDNAMES(OBJ, FLAG) returns the same cell array as the previous 
%    syntax and is provided for backwards compatibility. 

%    CP 3-14-02
%    Copyright 2001-2003 The MathWorks, Inc.
%    $Revision: 1616 $  $Date: 2008-08-23 09:05:37 +0100 (Sat, 23 Aug 2008) $

% Error checking.
if ~isa(obj, 'timer')
    error('MATLAB:timer:noTimerObj',timererror('MATLAB:timer:noTimerObj'));
end

% Ignore the FLAG input for now until we decide what to do 
% for the '-full' option.
out = fieldnames(obj.jobject);
