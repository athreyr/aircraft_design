function Default = defaultInputs(classname)
% defaultInputs returns input properties of class and their default values
% 
%   Used for assigning properties when no input arguments are passed to the
%   class constructor. The outputs are basically read from a text file
%   with the same name as that of the class located in a folder named
%   input_properties_default in the same folder as that of this function.
% 
%   Meant for internal use only.

parentFolder = fileparts(mfilename('fullpath'));
fileID = fopen(fullfile(parentFolder,'input_properties_default',[classname,'.txt']));

scannedCells = textscan(fileID, '%s %s %q', 'CommentStyle','%');
fclose(fileID);

inputsList = scannedCells{1};
datatypes = scannedCells{2};
valexpr = scannedCells{3};

nRows = numel(inputsList);
defaultValues = cell(nRows, 1);
for iRow = 1:nRows
    switch datatypes{iRow}
        case 'num'
            defaultValues{iRow} = str2num(valexpr{iRow}); %#ok<ST2NM>
        otherwise
            defaultValues{iRow} = valexpr{iRow};
    end
end

Default = cell2struct(defaultValues, inputsList, 1);

end
