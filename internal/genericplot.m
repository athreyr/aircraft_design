function [plotHandle, axesHandle] = genericplot(datapoints, varargin)
%PARSEPLOTINPUTS Summary of this function goes here
%   Detailed explanation goes here

% parse inputs
plotoptions = {};
if isempty(varargin) % inputs don't contain target axes
    axesHandle = gca; % creates new axes if it doesn't exist
else
    if isa(varargin{1}, 'matlab.graphics.axis.Axes') || ...
                                isa(varargin{1}, 'matlab.ui.control.UIAxes')
    % ---------------- REVISIT FOR BACKWARD COMPATIBILITY ----------- !!!!
        axesHandle = varargin{1};
        plotoptions = varargin(2:end);
    else
        axesHandle = gca;
        plotoptions = varargin;
    end
end

try
    plotHandle = builtin('plot', axesHandle, ...
                         datapoints(:,1), datapoints(:,2), plotoptions{:});
catch ME
    throwAsCaller(ME)
end

end

