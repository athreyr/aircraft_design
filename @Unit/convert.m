function valout = convert(valin, fromUnit, toUnit, varargin)
%convert    Value in new unit, based on multiplicative factors from file
%   Unit.convert(valin, fromUnit, toUnit) returns the value of valin in
%   toUnit, assuming it was already in fromUnit. The conversion factors
%   (after reducing the potentially compound units fromUnit and toUnit to
%   their base units and dimensions) are read from a text file.
% 
%   You can convert between relative temperature units, e.g. 0C and 0F by
%   passing a true argument at the end, e.g. Unit.convert(10, '0C', '0F',
%   true) returns the value of 10 degree celsius in degree fahrenheit.
% 
%   See also evaluate.

narginchk(3,4)

if nargin == 4, isRelTemp = varargin{1}; else, isRelTemp = false; end

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
