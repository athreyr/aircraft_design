function val = multiplier(fromUnit, toUnit, unitsMatrix, multiplierList)
%multiplier     Mulitiplication factor computed recursively as chain.
%   multiplier(fromUnit, toUnit, unitsMatrix, multiplierList) returns the
%   number to be multiplied to convert a quantity in fromUnit to toUnit,
%   based on the unit pairing information in unitsMatrix, and the
%   corresponding list of conversion factors in multiplierList.

% set default output as empty (NOT 1 because units may be incompatible)
val = [];

% if the From and To units are same (due to recursion or user input),
% return 1 and terminate
if strcmpi(fromUnit, toUnit), val = 1; return, end

% locate From and To units in matrix
[fromRows, fromCols] = find(ismember(unitsMatrix, fromUnit));
[toRows, toCols] = find(ismember(unitsMatrix, toUnit));

% return empty output if unable to locate
if isempty(fromRows) || isempty(toRows), val = []; return, end

% loop over each combination of From and To units in the matrix

% !! -- MAKE NESTED LOOP FASTER BY COMPARING FROM AND TO ROWS LENGTH --- !!
% !!!! -- SAVE ALL VAL TO REMOVE DEPENDENCY ON ORDER IN unitsMatrix -- !!!!

% start outer loop
for iFrom = 1:numel(fromRows)
    
    thisFromRow = fromRows(iFrom);
    thisFromCol = fromCols(iFrom);
    
    % compute multiplier for this row (will be paired with corresponding To
    % unit in the inner loop) which could be a reciprocal
    multiplierFrom = ...
        switchMultiplier(multiplierList(thisFromRow), thisFromCol, true);
    
    % find name of other unit in this row (will be used as the next From
    % unit in recursive call)
    newFromUnit = unitsMatrix(thisFromRow, 3 - thisFromCol); 
    % 3 - (1, 2) = (2, 1)
    
    % start inner loop
    for iTo = 1:numel(toRows)
        
        % check if To unit is on the same row as From unit, and if so,
        % return the multiplier computed earlier (potential reciprocal was
        % taken care of then)
        thisToRow = toRows(iTo);
        if thisFromRow == thisToRow
            val = multiplierFrom;
            return
        end
        
        % To unit is on a different row, so compute that row's multiplier
        % like earlier (take care of reciprocals too)
        thisToCol = toCols(iTo);
        multiplierTo = ...
            switchMultiplier(multiplierList(thisToRow), thisToCol, false);
        
        % find name of other unit in this row as earlier
        newToUnit = unitsMatrix(thisToRow, 3 - thisToCol);
        
        % create new matrix and list of multipliers by eliminating this
        % From row and To row using setdiff
        newUnitsMatrix = unitsMatrix(setdiff(1:end, [thisFromRow,thisToRow]),:);
        newMultiplierList = ...
            multiplierList(setdiff(1:end, [thisFromRow,thisToRow]));
        
        % recurse into this function to calculate the multiplier for
        % converting between new units
        fooVal = ...
            multiplier(newFromUnit, newToUnit, newUnitsMatrix, newMultiplierList);
        
        % if fooVal is empty, it means that the units are either
        % incompatible, or the combination was bad and there's another one
        % that yields a result
        if ~isempty(fooVal) % we found the good combination, so return
            val = multiplierFrom * fooVal * multiplierTo;
            return % or else it will get overwritten in the next loop
        end
        
    end % loop over To rows

end % loop over From rows

end % main function

function valout = switchMultiplier(argin, col, isFrom)
%switchMultiplier   Switches to 1/multiplier based on unit column location.
%   switchMultiplier(argin, col, isFrom) returns either argin or 1/argin,
%   depending on whether col is 1 or 2, and if isFrom is true or false.

switch col
    case 1
        if isFrom, valout = argin; else, valout = 1/argin; end
    case 2
        if isFrom, valout = 1/argin; else, valout = argin; end
%     otherwise
%         disp(col)
%         error('impossible column number')
end

end
