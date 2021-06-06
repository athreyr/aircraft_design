function UnitOut = evaluate(unitExpression)
%EVAL Summary of this function goes here
%   Detailed explanation goes here

padexpr = ['(',unitExpression,')'];
[symbols, operators] = ...
    regexp(padexpr, '\(|\)|\.|*|/|\\|\^', 'split', 'match');

fullexpr = symbols{1};

for iSym = 2:numel(symbols)
    if isempty(symbols{iSym})
        str = '';
    elseif ~isnan(str2double(symbols{iSym}))
        str = symbols{iSym};
    else
        str = ['Unit(''', symbols{iSym}, ''')'];
    end
    fullexpr = [fullexpr, operators{iSym-1}, str]; %#ok<AGROW>
end

UnitOut = builtin('eval',fullexpr);

end

