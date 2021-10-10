function multiFact = convertBase(ThisUnit, toUnitList)
%convertBase    Multiplication factor for converting base units to new set
%   ThisUnit.convertBase(toUnitList) returns the multiplication factor for
%   converting 1 unit of ThisUnit to 1 unit of the combination of base
%   units toUnitList.
%   
%   toUnitList is a cell array of character vectors representing the
%   symbols of units of dimenions mass, length, time, and temperature
%   respectively.
% 
%   The elements in toUnitList corresponding to the dimensions of ThisUnit
%   that are zero are ignored when computing the multiplication factor.
% 
%   The multiplication factors for converting between each pair of base
%   units are read from data\unit_conversion\multipliers.txt. If a direct
%   conversion isn't available, it will attempt to link several pairs of
%   units to get the result.
% 
%   The row-wise order of the pairs in the file determines the path that
%   will be taken while linking, so be careful while editing the file. This
%   dependency will be removed in a future release.

parentFolderList = regexp(fileparts(mfilename('fullpath')), filesep, 'split');

fileID = fopen(fullfile(...
    parentFolderList{1:end-1},'data','unit_conversion','multipliers.txt'));

scannedCells = textscan(fileID, '%s %s %f', 'CommentStyle','%');
fclose(fileID);

unitsMatrix = [scannedCells{1},scannedCells{2}];

fromUnitList = ThisUnit.baseUnitSymbols;
dims = ThisUnit.dimensions;

multiFact = 1;
for idim = 1:numel(dims)
    if dims(idim) ~= 0 % so that multiplier isn't unnecessarily called
        fooVal = multiplier(fromUnitList{idim}, toUnitList{idim}, ...
                            unitsMatrix, scannedCells{3});

        if isempty(fooVal)
            warning('AD:Unit:noMultiplier', ...
                ['Conversion from ''%s'' to ''%s'' not available (yet). '...
                 'Check the files in data\unit_conversion to see list of '...
                 'available units.\nReturning the value unchanged'],...
                 fromUnitList{idim}, toUnitList{idim})
             fooVal = 1;
        end % if multiplier is empty (incompatible dimensions or bad symbol)

        multiFact = multiFact * fooVal ^ dims(idim);
    end % if this dimension is non-zero
end % for loop over dimensions

end % function
