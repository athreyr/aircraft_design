function runMeFirst
%Adds all subfolders (except the Git folder) to the MATLAB search path

[parentFolder,~,~] = fileparts(mfilename('fullpath'));
addpath(genpath(parentFolder))

gitFolder = fullfile(parentFolder,'.git');
rmpath(gitFolder)

end
