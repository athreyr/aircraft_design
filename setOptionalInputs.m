function varargout = setOptionalInputs(defaultValues, varargin)
% setOptionalInputs replaces default values with nonempty user inputs
% 
%   Helper function for parsing inputs in class constructors.
% 
%   Meant for internal use only.

if nargout ~= numel(defaultValues)
    msgtext = ['There are %i default values, but they are being assigned'...
               ' to %i variables.'];
    ME = MException('Internal:nargMismatch', msgtext, ...
                    numel(defaultValues), nargout);
    ME.throwAsCaller
end

% populate output with default values
varargout = cell(size(defaultValues));
for outIdx = 1:numel(varargout)
    varargout{outIdx} = defaultValues(outIdx);
end

% update those outputs whose corresponding user input is not empty
for arginIdx = 1:numel(varargin)
    thisUserInput = varargin{arginIdx};
    if ~isempty(thisUserInput), varargout{arginIdx} = thisUserInput; end
end

end

