function UnitOut = evaluate(unitExpression)
%evaluate   Evaluate compound unit expression
%   Unit.evaluate(unitExpression) returns a Unit object whose properties
%   are computed from the char vector unitExpression using unit arithmetic.

% pad the expression with parantheses so first char doesn't need processing
padexpr = ['(',unitExpression,')'];

% separate unit symbols and operators from the padded expression
[symbols, operators] = ...
    regexp(padexpr, '\(|\)|*|/|\\|\^', 'split', 'match');
% '.' would be used as decimal places, not multiplication

% for every unit symbol, prepend "Unit('" and append "')"
fullexpr = symbols{1};

for iSym = 2:numel(symbols)
    if isempty(symbols{iSym}) || isspace(symbols{iSym})
        % two operators could have come one after the other, or it's a
        % whitespace character
        str = '';
    elseif ~isnan(str2double(symbols{iSym}))
        str = symbols{iSym};
    else
        str = ['Unit(''', symbols{iSym}, ''')'];
    end
    fullexpr = [fullexpr, operators{iSym-1}, str]; %#ok<AGROW>
    % it's a very small growth and no way to preallocate, so Code Analyzer
    % warning can be suppressed
end

% evaluate resultant expression
UnitOut = builtin('eval',fullexpr);

end

