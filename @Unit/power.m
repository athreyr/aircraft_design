function x = power(A, B)
%POWER Summary of this function goes here
%   Detailed explanation goes here

if ~isnumeric(B)
    
    if any(B.dimensions, 'all')
        foostr = sprintf(['Raising ''%g'' to ''%s'' is not possible '...
            'because the latter''s dimensions are ['...
            repmat('%g,', size(B.dimensions)), ...
            '\b] (it should be dimensionless).'], ...
            A, B.symbol, B.dimensions);
        ME = MException('AD:Unit:powerToDimensionedUnit', foostr);
        % foostr is needed because MException message formatting won't
        % accept non-scalar numbers as input
        ME.throwAsCaller
    end
    
    x = A ^ B.coefficient;
    return
    
else
    
    symbol = [A.symbol, '^', sprintf('%g',B)];
    dims = A.dimensions * B;    
    coeff = A.coefficient ^ B;
    x = Unit(symbol, A.baseUnitSymbols, dims, coeff);
end


end

