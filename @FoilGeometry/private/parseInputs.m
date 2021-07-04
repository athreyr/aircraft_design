function [inputPropertiesList, valuesList] = parseInputs(Default, userInputValues)
%PARSEINPUTS Summary of this function goes here
%   Detailed explanation goes here

datasrc = Default.datasrc;
nHeaderRows = Default.nHeaderRows;
nLeadCols = Default.nLeadCols;

coords = dlmread(datasrc, '', nHeaderRows, nLeadCols);
abcissas = coords(:,1);
ordinates = coords(:,2);
[~,name] = fileparts(datasrc);

inputPropertiesList = { ...
    'abcissas'; ...
    'ordinates'; ...
    'name' ...
    };

valuesList = { ...
    abcissas; ...
    ordinates; ...
    name ...
    };

if isempty(userInputValues), return, end

if isnumeric(userInputValues{1}) && numel(userInputValues) > 1
    abcissas = userInputValues{1};
    ordinates = userInputValues{2};
    name = setOptionalInputs({'untitled'}, userInputValues(3));
    
elseif ischar(userInputValues{1}) || isastring(userInputValues{1})
    datasrc = userInputValues{1};
    defaultValues = {Default.nHeaderRows, Default.nLeadCols};
    [nHeaderRows, nLeadCols] = ...
        setOptionalInputs(defaultValues, userInputValues(2:end));
    [~, name, ext] = fileparts(datasrc);

    try
        if strcmpi('.csv', ext)
            coords = csvread(datasrc, nHeaderRows, nLeadCols);
        else
            coords = dlmread(datasrc, '', nHeaderRows, nLeadCols);
        end
        if coords(1)*2 == length(coords)-1, coords = coords(2:end,:); end
        abcissas = coords(:,1);
        ordinates = coords(:,2);
    catch ME
    %     if strcmp(ME.identifier, 'MATLAB:dlmread:FileNotOpened')
        foostr = sprintf(['.\nUnable to make coordinates from ''%s''. '...
                          'Proceeding with default values.'], datasrc);
        warning('FoilGeometry:baddatasrc', '%s', [ME.message, foostr])
        return
    %     else
    %         ME.throwAsCaller
    %     end
    end
else
    warning('FoilGeometry:ambiguousInputSyntax',...
            ['Wrong or ambiguous input syntax. Proceeding with default'...
             ' values.'])
    return
end

% validate user inputs
try
    validateattributes(abcissas, {'numeric'}, {'real','finite','vector'})
    validateattributes(ordinates, {'numeric'}, {'real','finite','vector'})
    validateattributes(name, {'char','string'}, {'nonempty','scalartext'})
catch ME
    ME.throwAsCaller
end

if numel(abcissas) ~= numel(ordinates)
    ME = MException('FoilGeometry:coordDimMismatch',...
                    'There are %i abcissas and %i ordinates.',...
                    numel(abcissas), numel(ordinates));
    ME.throwAsCaller
end

valuesList = { ...
    abcissas; ...
    ordinates; ...
    name ...
    };

end

