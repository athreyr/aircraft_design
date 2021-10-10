function S = setfieldnew(S, A)
%SETFIELDNEW Summary of this function goes here
%   Detailed explanation goes here

if ~isstruct(S) || ~isstruct(A)
    ME = MException('AD:setfieldnew:notStructInput', ...
        ['Expected inputs to be struct arrays. Instead their types were '...
        '%s and %s respectively.'], ...
        class(S), class(A));
    ME.throw
end

allfields = fieldnames(A);
newFieldsIdx = find(~isfield(S, allfields));

for iField = 1:numel(newFieldsIdx)
    thisfield = allfields(newFieldsIdx(iField));
    [S.(thisfield)] = deal([A.(thisfield)]);
end

end

