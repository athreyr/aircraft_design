function valout = convertRelativeTemperature(argin, fromUnit, toUnit)
%convertRelativeTemperature     Value in new unit of relative temperature
%   convertRelativeTemperature(argin, fromUnit, toUnit) returns the value
%   of argin in toUnit, assuming it was already in fromUnit. Both toUnit
%   and fromUnit are relative temperature units, e.g. '0C', '0R', etc.
% 
%   A relative temperature unit cannot be present in a compound unit,
%   except as a difference, e.g. delta degree celsius, which is the same as
%   delta kelvin, which is just 'K'. Therefore, conversion between relative
%   temperature units does not need any dimension checking, but that makes
%   it more nontrivial since the conversion cannot be represented by a
%   multiplicative factor.
% 
%   For all the common relative temperature unit conversions, (i.e. those
%   between '0C', '0K', '0R', and '0F'), the conversion factor can be
%   expressed as a linear polynomial, which means its "reciprocal" can be
%   written quite easily.
% 
%   But user-defined units that have different expressions for conversion
%   cannot be added, yet. Support for general conversions will be added in
%   a future release.

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
         'Check data\unit_conversion\relativeTemperature.txt to see list'...
         ' of available units.\nReturning the value unchanged'],...
         fromUnit, toUnit)
     valout = argin;
end

end

