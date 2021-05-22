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
%   Meant for internal use only.

if nargout ~= numel(defaultValues)
    msgtext = ['There are %i default values, but they are being assigned'...
               ' to %i variables.'];
    ME = MException('Internal:defaultsOutMismatch', msgtext, nDefaults, nargout);
    ME.throwAsCaller
end

% populate output with default values
varargout = defaultValues;

% update those outputs whose corresponding user input is not empty
nonemptyIdx = ~cellfun('isempty', userInputValues);
varargout(nonemptyIdx) = userInputValues(nonemptyIdx);

end

