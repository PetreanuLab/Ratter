function endval = end(obj,k,n)
%END Last index in an indexing expression of timer object array.
%
%    END(A,K,N) is called for indexing expressions involving the 
%    object A when END is part of the K-th index out of N indices.
%

%    RDD 1-16-2002
%    Copyright 2001-2003 The MathWorks, Inc.
%    $Revision: 1616 $  $Date: 2008-08-23 09:05:37 +0100 (Sat, 23 Aug 2008) $

if n==1
    % e.g., t(2) -- just return the length of the vector
    endval = length(obj);
else
    sz = size(obj);
    if (k>length(sz)) % if the index is greater than the object's dimensions
        endval = 1;
    else % else return the size of the desired index.
        endval = sz(k);
    end
end

