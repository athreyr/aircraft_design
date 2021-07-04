function multiFact = convertBase(ThisUnit, toUnitList)
%

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
                 'Check the files in data/unit_conversion to see list of '...
                 'available units.\nReturning the value unchanged'],...
                 fromUnitList{idim}, toUnitList{idim})
             fooVal = 1;
        end

        multiFact = multiFact * fooVal ^ dims(idim);
    end
end


end % function
