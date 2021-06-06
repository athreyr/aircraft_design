function [inputPropertiesList, valuesList] = parseInputs(Default, userInputValues)
%parseInputs    Parse and validate user inputs (including optional ones)
%   [inputPropertiesList,valuesList] = parseInputs(Default,userInputValues)
%   parses and validates the inputs provided by the user (assigning default
%   values to those inputs which user has left empty), and returns the
%   values of the input properties in valuesList.
% 
%   Meant for internal use only.

inputPropertiesList = { ...
    'symbol'; ...
    'baseUnitSymbols'; ...
    'dimensions'; ...
    'coefficient' ...
    };

valuesList = { ...
    Default.symbol; ...
    Default.baseUnits; ...
    Default.dims; ...
    Default.coeff ...
    };

if isempty(userInputValues), return, end

symbol = userInputValues{1};
defaultValues = {Default.baseUnits, Default.dims, Default.coeff};

% In other classes, userInputValues was of similar shape as that of
% defaultValues because they created a scalar object. Now userInputValues
% can be used to create an object array, which means that the 1-to-1
% correspondence between userInputValues and defaultValues doesn't exist.

% Hence, to use setOptionalInputs(), the inputs corresponding to a single
% object has to be extracted from userInputValues, and used together with
% defaultValues in a loop.

% But to do that, the "optional" part of userInputValues would have to be
% rearranged to produce a matrix of inner dimensions same as that of
% symbol, and outer dimensions same as that of defaultValues.

% This needs an approach like the one given in the constructor, but with
% one difference: since the sizes of symbol and defaultValues are going to
% be concatenated to get the indices, there shouldn't be singleton
% dimensions in between (or they would count as an index and produce
% index-out-of-bounds errors).

% Also, the user won't give placeholders for empty optional inputs, so
% another cell array of required dimensions have to be created, and the
% non-empty elements of optional part of userInputValues need to be copied
% to it.

userValues = cell([sizen(symbol),numel(defaultValues)]); % sizen, NOT size
fullidx = ~cellfun('isempty', userInputValues(2:end));
% values for optional inputs provided by user
userValues(fullidx) = userInputValues(1+find(fullidx));
% fullidx is measured relative userInputValues(2:end), so 1 needs to be
% added to it, but it can't be done before converting the logical indices
% to linear ones

subIdxSym = cell(1, numel(sizen(symbol))); % sizen, NOT size
% subscripted index to collect all the outputs of ind2sub later, except the
% leading and trailing singleton dimensions

valuesList = cell(1+numel(defaultValues), numel(symbol));
% each column contains values of input properties of each object (1
% mandatory input + numel(defaultValues) optional inputs)

for linIdxSym = 1:numel(symbol)
    
    [subIdxSym{:}] = ind2sub(size(symbol), linIdxSym);
    % either size or sizen would work here as their behaviours are similar
    % when there's no concatenation, so size is used for familiarity
    
    [baseUnits, dims, coeff] = ...
        setOptionalInputs(defaultValues, userValues(subIdxSym{:},:));
    
    try
        validateattributes(symbol{linIdxSym}, {'char','string'}, {'nonempty','scalartext'})
        validateattributes(baseUnits, {'cell'}, {'row'})
        validateattributes([baseUnits{:}], {'char','string'}, {'scalartext'})
        validateattributes(dims, {'numeric'}, {'finite'})
        validateattributes(coeff, {'numeric'}, {'vector','finite'})
        if isscalar(coeff)
            validateattributes(coeff, {'numeric'}, {'positive'})
        end
    catch ME
        msg = sprintf(...
            ['Parse error at inputs corresponding to symbol at index (', ...
            repmat('%i,',size(subIdxSym)), ...
            '\b):\n%s'], ...
            subIdxSym{:}, ME.message);
        MEnew = MException(ME.identifier, msg);
        MEnew.throwAsCaller
    end
    
    % save to this column of valuesList
    valuesList(:,linIdxSym) = { ...
        symbol{linIdxSym}; ...
        baseUnits; ...
        dims; ...
        coeff ...
        };
    
end % loop over each input symbol

end % function
