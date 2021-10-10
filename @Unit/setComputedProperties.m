function ThisUnit = setComputedProperties(ThisUnit)
%setComputedProperties      Set properties for array of input objects
%   setComputedProperties(ThisUnit) reads information about the symbol in
%   each object of the array ThisUnit from file and assigns them to
%   respective properties of the objects.

% retrieve the symbols and base units in cell arrays by collecting them as
% comma-separated lists and transposing them to column vectors
symbols = {ThisUnit.symbol}.';
baseUnits = {ThisUnit.baseUnitSymbols}.';

% read the information from file in a particular format
parentFolderList = regexp(fileparts(mfilename('fullpath')), filesep, 'split');
fileID = fopen(fullfile(...
    parentFolderList{1:end-1},'data','unit_conversion','definitions.txt'));

scannedCells = textscan(fileID, '%s %q %q %f', 'CommentStyle','%');
fclose(fileID);

symbolList = scannedCells{1};

for iSym = 1:numel(symbols)
    
    thisSym = symbols{iSym};
    thisBaseUnits = baseUnits{iSym};
    
    if strcmp('1',thisSym) || any(~strcmp('0',thisBaseUnits)), continue, end
    %   default symbol          user has provided values
    
    [~, rowSym] = ismember(thisSym, symbolList); % find symbol in list
    
    % skip iteration with a warning if symbol is not found
    if rowSym == 0
        warning('AD:Unit:noDefinition', ...
            ['No definition available for %s (yet). Please type edit ' ...
             'data\\unit_conversion\\definitions.txt at the Command Window' ...
             ' to see list of available definitions. Setting this unit to' ...
             ' the default value'], ...
            thisSym)
        % warning() escapes \ characters, so \\ is necessary
        continue
    end
    
    reqdBaseUnits = char2cell(scannedCells{2}{rowSym});
    % only those ones with non-zero dimension
    
    dims = str2num(scannedCells{3}{rowSym}); %#ok<ST2NM>
    
    fullBaseUnits = cell(size(dims)); % all base units
    [fullBaseUnits{dims == 0}] = deal('');
    [fullBaseUnits{dims ~= 0}] = deal(reqdBaseUnits{:});
    
    ThisUnit(iSym).baseUnitSymbols = fullBaseUnits;
    ThisUnit(iSym).dimensions = dims;
    ThisUnit(iSym).coefficient = scannedCells{4}(rowSym);

end % loop over symbols of each object in ThisUnit array

end % function

