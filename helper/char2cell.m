function cellArray = char2cell(charVal)
%char2cell  Convert character row vector to cell array
%   cellArray = char2cell(charVal) converts charVal, a row vector of
%   characters, into a cell array by separating at commmas and semicolons.
%   charVal should represent a valid cell array, with same number of
%   columns in every row.
%   Example:
%       foo = char2cell('abc, defg, hijkl; mnop, qr, s')
%       foo = 
%           {'abc'}     {'defg'}    {'hijkl'}
%           {'mnop'}    {'qr'}      {'s'}

if isempty(charVal), cellArray = {''}; return, end

validateattributes(charVal, {'char'}, {'row'})

cellRows = regexp(charVal, ';', 'split'); % each row
nRows = numel(cellRows);

nCols = numel(regexp(cellRows{1}, ',')) + 1;
cellArray = cell(nRows, nCols);

for iRow = 1:numel(cellRows)
    cellArray(iRow,:) = strtrim(regexp(cellRows{iRow}, ',', 'split'));
end

end
