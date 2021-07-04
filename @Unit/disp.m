function disp(ThisUnit)
% disp overloads the builtin disp function for Unit class

if isempty(regexp(ThisUnit.symbol,'\(|\)|\.|*|/|\\|\^','match','once'))
    lsym = [ThisUnit.symbol, ' = '];
else
    lsym = '';
end
ThisUnit = ThisUnit.setSymbol;
rsym = ThisUnit.symbol;

fprintf('\tUnit object with properties:\n\n')
str = ['\t', lsym, '%g ', rsym, '\n'];
fprintf(str, ThisUnit.coefficient)
fprintf('\n')

end

