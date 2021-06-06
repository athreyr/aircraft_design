function valout = convertRelativeTemperature(argin, fromUnit, toUnit)
%CONVERTRELATIVETEMPERATURE Summary of this function goes here
%   Detailed explanation goes here

parentFolderList = regexp(fileparts(mfilename('fullpath')), filesep, 'split');
fileID = fopen(fullfile(...
    parentFolderList{1:end-2},'data','unit_conversion','relativeTemperature.txt'));

scannedCells = textscan(fileID, '%s %s %q', 'CommentStyle','%');
fclose(fileID);

unitsMatrix = [scannedCells{1},scannedCells{2}];

valout = polynomial(argin, fromUnit, toUnit, unitsMatrix, scannedCells{3});

if isempty(valout)
    warning('AD:UnitConversion:noPolynomial', ...
        ['Conversion from ''%s'' to ''%s'' not available (yet). '...
         'Check the files in data/unit_conversion to see list of '...
         'available units.\nReturning the value unchanged'],...
         fromUnit, toUnit)
     valout = argin;
end

end

