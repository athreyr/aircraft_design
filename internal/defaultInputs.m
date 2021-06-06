function Default = defaultInputs(classname)
%defaultInputs  Struct containing default arguments for class constructor
% 
%   defaultInputs(classname) returns the default values of arguments for
%   the constructor of class classname in a structure whose fieldnames are
%   the same as the argument names.
% 
%   Both the fieldnames and values are read from a text file with the same
%   name as that of the class located in folder ..\data\default_inputs.
% 
%   Meant for internal use only.

% find fullpath to the relevant text file
parentFolderList = regexp(fileparts(mfilename('fullpath')), filesep, 'split');
datafile = fullfile(parentFolderList{1:end-1},'data','default_inputs',[classname,'.txt']);

% read formatted data from it
fileID = fopen(datafile);
scannedCells = textscan(fileID, '%s %s %q', 'CommentStyle','%');
fclose(fileID);

% separate extracted info
varnames = scannedCells{1};
datatypes = scannedCells{2};
expressions = scannedCells{3};

Default = struct; % initialise struct for using setfield later

nRows = numel(varnames); % number of lines in the text file
for iRow = 1:nRows
    
    % process values differently according to datatype
    switch datatypes{iRow}
        case 'num'
            value = str2num(expressions{iRow}); %#ok<ST2NM>
        case 'cell'
            value = char2cell(expressions{iRow});
        otherwise
            value = expressions{iRow};
    end
    
    % save values to (potentially nested) struct using setfield
    nestedStructFields = regexp(varnames{iRow}, '\.', 'split');
    Default = setfield(Default, nestedStructFields{:}, value);
    
end % loop over rows of data read from text file

end % function
