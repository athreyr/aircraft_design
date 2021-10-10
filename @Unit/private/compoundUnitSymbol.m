function symbol = compoundUnitSymbol(posBaseUnitList, posdims)
%compoundUnitSymbol     Base units separated by '*' and raised to powers
%   compoundUnitSymbol(posBaseUnitList, posdims) computes the compound unit
%   symbol from the cell vector of character rows posBaseUnitList and their
%   corresponding positive powers posdims.

% if dimensions are empty, return empty char
if isempty(posdims), symbol = ''; return, end

% if only 1 dimension, just add '^d' after the unit, if d > 1
if numel(posdims) == 1
    symbol = [posBaseUnitList{1}, n1exp(posdims)];
    return
end

% multiple dimensions, so add parantheses and loop over everything
symbol = ['(', posBaseUnitList{1}, n1exp(posdims(1))];
for idim = 2:numel(posdims)
    symbol = [symbol, '*', ...
        posBaseUnitList{idim}, n1exp(posdims(idim))]; %#ok<AGROW>
end
symbol = [symbol, ')'];

end % main function

function expsym = n1exp(dim)
%n1exp  Non-one exponent
%   n1exp(dim) returns '^dim' if dim > 1 and empty char otherwise

if dim > 1, expsym = sprintf('^%g',dim); else, expsym = ''; end

end

