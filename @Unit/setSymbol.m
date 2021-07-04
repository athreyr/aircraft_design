function ThisUnit = setSymbol(ThisUnit)
%SETSYMBOL Summary of this function goes here
%   Detailed explanation goes here

alldims = ThisUnit.dimensions;

posdimidx = alldims > 0;
if any(posdimidx)
    posdims = alldims(posdimidx);
    posBaseUnits = ThisUnit.baseUnitSymbols(posdimidx);
    symbol = compoundUnitSymbol(posBaseUnits, posdims);
else
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

