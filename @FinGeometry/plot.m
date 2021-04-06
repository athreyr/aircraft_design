function plotHandle = plot(ThisWing,varargin)

% p = inputParser;
% addParameter(p,'Origin',[0,0])
% parse(p,varargin{:})
% origin = p.Results.Origin;

axesHandle = gobjects(1);
if nargin > 2 && isa(varargin{1},'matlab.graphics.axis.Axes')
    axesHandle = varargin{1};
    plotoptions = varargin(2:end);
else
    plotoptions = varargin;
end

AR = ThisWing.aspectRatio;
b = ThisWing.fullspan;
TR = ThisWing.taperRatio;
lambda_deg = ThisWing.sweepAngle_deg;
xBar = ThisWing.sweepLocation;
cRoot = ThisWing.rootChord;

origin = [-cRoot * xBar, 0];
rootLE = [0, 0] - origin;
rootTE = [-cRoot, 0] - origin;

lambdaLE_deg = atand( tand(lambda_deg) + 4/AR * (1-TR)/(1+TR) * xBar );
rightTipLE = [-b/2 * tand(lambdaLE_deg), b/2] - origin;
leftTipLE  = [-b/2 * tand(lambdaLE_deg), -b/2] - origin;

lambdaTE_deg = atand( tand(lambdaLE_deg) - 4/AR * (1-TR)/(1+TR) );
rightTipTE = [-cRoot - b/2 * tand(lambdaTE_deg), b/2] - origin;
% if you write -cRoot -b/2*..., it reads it as -cRoot, -b/2*...
leftTipTE  = [-cRoot - b/2 * tand(lambdaTE_deg), -b/2] - origin;

data = [rootLE; rightTipLE; rightTipTE; rootTE; leftTipTE; leftTipLE; rootLE];

if isempty(plotoptions)
    plotHandle = plot(data(:,1), data(:,2));
    axesHandle = gca;
else
    if isgraphics(axesHandle)
        plotHandle = plot(axesHandle,data(:,1),data(:,2),plotoptions);
    else
        plotHandle = plot(data(:,1),data(:,2),plotoptions);
        axesHandle = gca;
    end   
end
axis equal
grid on
set(axesHandle,'XAxisLocation','origin')
set(axesHandle,'YAxisLocation','origin')
set(axesHandle,'YDir','reverse')
xlabel('X_B')
fooHandle = ylabel('Y_B');
fooPos = fooHandle.Position;
fooPos(2) = -fooPos(2);
fooHandle.Position = fooPos;
fooHandle.VerticalAlignment = 'bottom';
% fooPos(1) = -fooPos(1);
% fooHandle.Position = fooPos;
% fooHandle.HorizontalAlignment = 'left';

end
