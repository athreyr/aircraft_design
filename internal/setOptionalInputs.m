function varargout = setOptionalInputs(defaultValues, userInputValues)
% setOptionalInputs replaces default values with nonempty user inputs
% 
%   Helper function for parsing inputs in class constructors.
%   
%   Both defaultValues and userInputs are cell vectors of unequal length,
%   but their contents are in the same order, i.e. if userInputs{idx} is
%   empty or doesn't exist, output{idx} = defaultValues{idx}, otherwise
%   output{idx} = userInputs{idx}.
% 
%   Also, if number of user inputs are more than number of default values,
%   the additional inputs are ignored.
% 
%   Meant for internal use only.

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

