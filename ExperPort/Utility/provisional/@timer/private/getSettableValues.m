function [propnames,props] = getSettableValues(obj)
%getSettableValues gets all the settable values of a timer object array
%
%    getSettableValues(OBJ) returns the settable values of OBJ as a list of settable
%    property names and a cell array containing the values.
%
%    See Also: TIMER/PRIVATE/RESETVALUES

%    RDD 1-18-2002
%    Copyright 2001-2006 The MathWorks, Inc.
%    $Revision: 1616 $  $Date: 2008-08-23 09:05:37 +0100 (Sat, 23 Aug 2008) $

objlen = length(obj);

propnames = [];
% foreach valid timer object...
for objnum=1:objlen
    if isJavaTimer(obj.jobject(objnum)) % valid java object found
        if isempty(propnames) % if settable propnames are not yet known, get them from set
            propnames = fieldnames(set(obj.jobject(objnum)));
        end
        % the settable values of the valid timer object
        props{objnum} = get(obj.jobject(objnum),propnames);
    end
end
