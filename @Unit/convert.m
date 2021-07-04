function valout = convert(valin, fromUnit, toUnit, varargin)
%convert    Value in new units, based on info from file
%   convertUnit(argin, fromBaseUnit, toBaseUnit) returns the value of argin
%   in toBaseUnit, assuming it was already in fromUnit. The conversion
%   factors are read from a txt file. If a direct conversion isn't
%   available, it will attempt to link several pairs of units to get the
%   result.
%   
%   The row-wise order of the pairs in the file determines the path that
%   will be taken while linking, so be careful while editing the file. This
%   dependency will be removed in a future release.
% 
%   You can convert between relative temperature units, e.g. 0C and 0F by
%   passing a true argument at the end, e.g. convert(10, '0C', '0F', true)

if nargin > 3, isRelTemp = varargin{1}; else, isRelTemp = false; end

if isRelTemp % units cannot possibly be compound, so convert directly
    valout = convertRelativeTemperature(valin, fromUnit, toUnit);
    return
end

% units could be compound, so reduce them to their lowest form
UnitFrom = Unit.evaluate(fromUnit);
UnitTo = Unit.evaluate(toUnit);

fromDims = UnitFrom.dimensions;
toDims = UnitTo.dimensions;

if any(fromDims ~= toDims, 'all')
    foostr = sprintf(['Cannot convert from ''%s'' to ''%s'' because their', ...
        ' dimensions ([', ...
        repmat('%g,',size(fromDims)), ...
        '\b] and [', ...
        repmat('%g,',size(toDims)), ...
        '\b] respectively) are incompatible.'], ...
        fromUnit, toUnit, fromDims, toDims);
    ME = MException('AD:Unit:badDimensions', foostr);
    % foostr is necessary because MException msg formatting won't take
    % non-scalar numbers as input
    ME.throwAsCaller     
end

% find multiplication factor for converting between base units of objects
multiFact = UnitFrom.convertBase(UnitTo.baseUnitSymbols);

valout = multiFact * valin * UnitFrom.coefficient / UnitTo.coefficient;

end
