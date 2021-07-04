function symbol = compoundUnitSymbol(posBaseUnitList, posdims)
%COMPOUNDUNITSYMBOL Summary of this function goes here
%   Detailed explanation goes here
% NO CHECKS FOR EMPTY POSDIMS - RECTIFY

if numel(posdims) == 1
    symbol = [posBaseUnitList{1}, n1exp(posdims)];
    return
end

symbol = ['(', posBaseUnitList{1}, n1exp(posdims(1))];
for idim = 2:numel(posdims)
    symbol = [symbol, '*', ...
        posBaseUnitList{idim}, n1exp(posdims(idim))]; %#ok<AGROW>
end
symbol = [symbol, ')'];

end

function expsym = n1exp(dim)

if dim > 1, expsym = sprintf('^%g',dim); else, expsym = ''; end

end

