function varargout = setOptionalInputs(defaultValues, userInputValues)
%setOptionalInputs      Deal default values for nonempty user inputs
%   [out1,out2,...outN] = setOptionalInputs(defaultValues, userInputValues)
%   assigns userInputValues{i} to outi if it is not empty, and
%   defaultValues{i} otherwise. Number of outputs should be equal to
%   numel(defaultValues). If numel(userInputValues) > numel(defaultValues),
%   the extra inputs are ignored.
% 
%   See also setfieldnew.

if nargout ~= numel(defaultValues)
    msgtext = ['There are %i default values, but they are being assigned'...
               ' to %i variables.'];
    ME = MException('Internal:defaultsOutMismatch', ...
        msgtext, numel(defaultValues), nargout);
    ME.throwAsCaller
end

% populate output with default values
varargout = defaultValues;

% ignore user inputs beyond number of default values (i.e. nargout)
userInputValues(nargout+1:end) = [];

% update those outputs whose corresponding user input is not empty
nonemptyIdx = ~cellfun('isempty', userInputValues);
varargout(nonemptyIdx) = userInputValues(nonemptyIdx);

end

