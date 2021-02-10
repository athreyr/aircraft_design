function runMeFirst
	filename = mfilename('fullpath');
	[parentFolder,~,~] = fileparts(filename);
	addpath(genpath(parentFolder))
    
    gitFolder = fullfile(parentFolder,'.git');
    rmpath(gitFolder)
end
