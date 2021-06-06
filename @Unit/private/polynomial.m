function valout = polynomial(argin, fromUnit, toUnit, unitsMatrix, coefficientsList)
%polynomial     Value after converting units using linear coefficients
%   polynomial(argin, fromUnit, toUnit, unitsMatrix, coefficientsList)
%   returns the value of argin in toUnit, assuming it was in fromUnit,
%   based on the info available in unitsMatrix and coefficientsList.
% 
%   For now, only linear coefficients are supported in coefficientsList.
%   
%   BETA STAGE. DO NOT USE. (Check local function below.)

% set default output as empty (NOT 1 because units may be incompatible)
valout = [];

% if the From and To units are same (due to recursion or user input),
% return 1 and terminate
if strcmpi(fromUnit, toUnit), valout = argin; return, end

% locate From and To units in matrix
[fromRows, fromCols] = find(ismember(unitsMatrix, fromUnit));
[toRows, toCols] = find(ismember(unitsMatrix, toUnit));

% return empty output if unable to locate
if isempty(fromRows) || isempty(toRows), valout = []; return, end

% loop over each combination of From and To units in the matrix

% !! -- MAKE NESTED LOOP FASTER BY COMPARING FROM AND TO ROWS LENGTH --- !!
% !!! ---- SAVE ALL VAL TO REMOVE DEPENDENCY ON ORDER IN TXT FILE ---- !!!!

% start outer loop
for iFrom = 1:numel(fromRows)
    
    thisFromRow = fromRows(iFrom);
    thisFromCol = fromCols(iFrom);
    
    % compute polynomial for this row (will be paired with corresponding To
    % unit in the inner loop) which could be an inverse one
    polyFrom = ...
        switchPolynomial(coefficientsList{thisFromRow}, thisFromCol, true);
    
    % find name of other unit in this row (will be used as the next From
    % unit in recursive call)
    newFromUnit = unitsMatrix(thisFromRow, 3 - thisFromCol); 
    % 3 - (1, 2) = (2, 1)
    
    % start inner loop
    for iTo = 1:numel(toRows)
        
        % check if To unit is on the same row as From unit, and if so,
        % return the value using polynomial computed earlier (potential
        % inverse was taken care of then)
        thisToRow = toRows(iTo);
        if thisFromRow == thisToRow
            valout = polyval(polyFrom, argin);
            return
        end
        
        % To unit is on a different row, so compute that row's polynomial
        % like earlier (take care of inverses too)
        thisToCol = toCols(iTo);
        polyTo = ...
            switchPolynomial(coefficientsList{thisToRow}, thisToCol, false);
        
        % find name of other unit in this row as earlier
        newToUnit = unitsMatrix(thisToRow, 3 - thisToCol);
        
        % create new matrix and list of coefficients by eliminating this
        % From row and To row using setdiff
        newUnitsMatrix = unitsMatrix(setdiff(1:end, [thisFromRow,thisToRow]),:);
        newCoefficientsList = ...
            coefficientsList(setdiff(1:end, [thisFromRow,thisToRow]));
        
        % recurse into this function to calculate the value after
        % converting between new units
        fooVal = polynomial(polyval(polyFrom,argin), newFromUnit, newToUnit, ...
            newUnitsMatrix, newCoefficientsList);
        
        % if fooVal is empty, it means that the units are either
        % incompatible, or the combination was bad and there's another one
        % that yields a result
        
        if ~isempty(fooVal) % we found the good combination, so return
            valout = polyval(polyTo,fooVal);
%             valout = polyFrom * fooVal * polyTo;
            return % or else it will get overwritten in the next loop
        end
        
    end % loop over To rows

end % loop over From rows

end % main function

function valout = switchPolynomial(coefficients, col, isFrom)
%switchPolynomial   Switch to inverse coefficients based on unit column
%   switchPolynomial(coefficients, col, isFrom) returns either coefficients
%   or their inverse, depending on whether col is 1 or 2, and if isFrom is
%   true or false.
% 
%   Only linear coefficients are supported now. BETA STAGE. DO NOT USE.

p = str2num(coefficients); %#ok<ST2NM>
% y = p(x) is y = m*x + c
invp = [1/p(1) -p(2)/p(1)];
% x = invp(y) is x = 1/m * y + (-c/m)

switch col
    case 1
        if isFrom, valout = p; else, valout = invp; end
    case 2
        if isFrom, valout = invp; else, valout = p; end
%     otherwise
%         disp(col)
%         error('impossible column number')
end

end

