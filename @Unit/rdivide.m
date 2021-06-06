function x = rdivide(A, B)
%RDIVIDE Summary of this function goes here
%   Detailed explanation goes here

if isnumeric(A)
    warning('AD:Unit:numberDivisionByUnit', ...
        ['Division of ''%g'' by ''%s'' is ignored because it will '...
         'introduce numbers into the unit symbol, which is hard ', ...
         'to parse'], ...
        A, B.symbol)
    return
    
elseif isnumeric(B)
    x = Unit(A.symbol, A.baseUnitSymbols, A.dimensions, A.coefficient/B);
    return
    
else
    symbol = [A.symbol, '/', B.symbol];
    dims = A.dimensions - B.dimensions;
    
    baseA = cell(size(dims)); % for converting from base units of B
    baseX = cell(size(dims)); % base units of nonempty dims
    for idim = 1:numel(dims)
        if dims(idim) == 0
            baseX{idim} = ''; % or else kg/lb will have a base unit
            baseA{idim} = A.baseUnitSymbols{idim};
            % or else you can't do things like kg/m
        else
            if ~isempty(A.baseUnitSymbols{idim})
                baseX{idim} = A.baseUnitSymbols{idim};
                baseA{idim} = A.baseUnitSymbols{idim};
            else % assign B's base unit
                baseX{idim} = B.baseUnitSymbols{idim};
                baseA{idim} = B.baseUnitSymbols{idim};
            end
        end
    end
    
    coeff = A.coefficient / (B.coefficient * B.convertBase(baseA));
    x = Unit(symbol, baseX, dims, coeff);
end

end

