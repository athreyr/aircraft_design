function disp(ThisUnit)
%disp   Display Unit object
%   disp(ThisUnit) displays a simple unit by its symbol and compound unit
%   by its symbol and definition.
% 
%   Unit('lbf') displays:
% 
%       Unit object with properties:
% 
%       lbf = 32.174 (lb*ft)/s^2

% if unit was created with evaluate, it would have operators in its symbol
% which should just go on the RHS, so:
if isempty(regexp(ThisUnit.symbol,'\(|\)|\.|*|/|\\|\^','match','once'))
    % there's a symbol that can be put on the LHS
    lsym = [ThisUnit.symbol, ' = '];
else
    % just display RHS
    lsym = '';
end
% compute the reduced version of the compound unit symbol
ThisUnit = ThisUnit.setSymbol;
rsym = ThisUnit.symbol;

% print the necessary info
fprintf('\tUnit object with properties:\n\n')
str = ['\t', lsym, '%g ', rsym, '\n'];
fprintf(str, ThisUnit.coefficient)
fprintf('\n')

end

