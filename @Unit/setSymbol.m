function ThisUnit = setSymbol(ThisUnit)
%setSymbol      Set compound unit symbol from base symbols and dimensions
%   ThisUnit = ThisUnit.setSymbol sets the compound unit symbol for
%   ThisUnit from its base unit symbols and dimensions. Since MATLAB copies
%   by value, the output of this function should be assigned back to the
%   object in order for the change to take place.
% 
%   The compound unit symbol is computed by grouping the symbols of all
%   positive dimensions (raised to those powers and separated by '*'),
%   likewise with the negative dimensions, and then separating both of
%   those by a '/', e.g. if base units are 'kg', 'm', s', and dimensions
%   are 1, 2, -1, then the compound symbol would be '(kg*m^2)/s'.

alldims = ThisUnit.dimensions;

posdimidx = alldims > 0;
if any(posdimidx)
    posdims = alldims(posdimidx);
    posBaseUnits = ThisUnit.baseUnitSymbols(posdimidx);
    symbol = compoundUnitSymbol(posBaseUnits, posdims);
else
    % if there are no positive dimensions, make it '1/unit'
    symbol = '1';
end

negdimidx = alldims < 0;
if any(negdimidx)
    negdims = -alldims(negdimidx);
    negBaseUnits = ThisUnit.baseUnitSymbols(negdimidx);
    symbol = [symbol, '/', compoundUnitSymbol(negBaseUnits, negdims)];
end

ThisUnit.symbol = symbol;

end

