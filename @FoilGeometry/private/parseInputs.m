function [inputPropertiesList, valuesList] = parseInputs(defaultValues, userInputValues)
%PARSEINPUTS Summary of this function goes here
%   Detailed explanation goes here

datasrc = '';
nHeaderRows = 1;
nLeadCols = 0;
if ischar(userInputValues{1})
    datasrc = userInputValues{1};
    % optional inputs = nHeaderRows, nLeadCols
    optDefVals = {nHeaderRows, nLeadCols};
    [nHeaderRows, nLeadCols] = setOptionalInputs(optDefVals, userInputValues(2:end));
    [~, name, ext] = fileparts(datasrc);
elseif isnumeric(userInputValues{1})
    [abcissas, ordinates, name] = setOptionalInputs(defaultValues, userInputValues);
else
    warning('FoilGeometry:ambiguousSyntax',...
            'Unable to parse first argument. Proceeding with default values.')
    [abcissas, ordinates, name] = deal(defaultValues{:});
end
%{
abcissas = [];
ordinates = [];
datasrc = '';
nHeaderRows = [];
nLeadCols = [];
switch nargin
    case 1
        datasrc = userInputValues{:};
    case 2
        if isnumeric(userInputValues{1})
            [abcissas, ordinates] = deal(userInputValues{:});
        elseif ischar(userInputValues{1})
            [datasrc, nHeaderRows] = deal(userInputValues{:});
        else
            warning('FoilGeometry:ambiguousSyntax',...
                    ['Unable to parse first argument. Proceeding with '...
                     'default values.'])
        end
    case 3
        [datasrc, nHeaderRows, nLeadCols] = deal(userInputValues{:});
    otherwise
        % do nothing
end
name = datasrc;

optionalInputValues = {nHeaderRows, nLeadCols, abcissas, ordinates, name};

[nHeaderRows, nLeadCols, abcissas, ordinates, name] = ...
                        setOptionalInputs(defaultValues, optionalInputValues);
%}
if ~isempty(datasrc)
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
        warning(ME.identifier, '%s', [ME.message, foostr])
        [abcissas, ordinates, name] = deal(defaultValues{:});
    %     else
    %         ME.throwAsCaller
    %     end
    end
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

valuesList = {abcissas; ordinates; name};
inputPropertiesList = {'abcissas'; ...
                       'ordinates'; ...
                       'name'};

end

