function runMeFirst
%runMeFirst     Add relevant folders to MATLAB search path

parentFolder = fileparts(mfilename('fullpath'));
addpath(fullfile(parentFolder,'internal'))
addpath(fullfile(parentFolder,'helper'))

end
