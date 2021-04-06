function [propertiesList, defaultValues] = defaultInputs(classname)
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
outcells = textscan(fileID,'%s %f', 'CommentStyle', '%');

propertiesList = outcells{1};
defaultValues = outcells{2};

fclose(fileID);

end
