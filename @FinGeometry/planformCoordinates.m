function datapoints = planformCoordinates(ThisFinGeometry, varargin)
% planformCoordinates returns array of x- and y-coordinates of fin planform
%
%   Helper function for plot. Syntax is as follows:
%       datapoints = ThisFinGeometry.planformCoordinates;
%       datapoints = ThisFinGeometry.planformCoordinates(origin);
%   where the coordinates in datapoints are computed as the distance from
%   the ordered pair [x0, y0] = origin (whose default value is the
%   leading edge of the root chord).
% 
%   The order of the coordinates is such that:
%       datapoints = ThisFinGeometry.planformCoordinates;
%       plot(datapoints(:,1), datapoints(:,2))
%   generates the fin planform. The sign convention followed is that of
%   body axes (positive x towards the leading edge and positive y towards
%   the starboard fin).
% 
%   Meant for internal use only.

try narginchk(1,2), catch ME, throwAsCaller(ME), end

% copy properties from input object
AR = ThisFinGeometry.aspectRatio;
b = ThisFinGeometry.fullspan;
TR = ThisFinGeometry.taperRatio;
lambda_deg = ThisFinGeometry.sweepAngle_deg;
xBar = ThisFinGeometry.sweepLocation;
cRoot = ThisFinGeometry.rootChord;

% assign location of origin w.r.t. leading edge of root chord
origin = [0, 0]; if ~isempty(varargin), origin = varargin{:}; end

% assign (x, y) coordinates to leading and trailing edges of root chord ...
rootLE = [0, 0] - origin;
rootTE = [-cRoot, 0] - origin;

% ... leading edges of right and left tip chord ...
lambdaLE_deg = atand( tand(lambda_deg) + 4/AR * (1-TR)/(1+TR) * xBar );
rightTipLE = [-b/2 * tand(lambdaLE_deg), b/2] - origin;
leftTipLE  = [-b/2 * tand(lambdaLE_deg), -b/2] - origin;

% ... trailing edges of right and left tip chord ...
lambdaTE_deg = atand( tand(lambdaLE_deg) - 4/AR * (1-TR)/(1+TR) );
rightTipTE = [-cRoot - b/2 * tand(lambdaTE_deg), b/2] - origin;
% WARNING: if you write -cRoot -b/2*..., it reads it as -cRoot, -b/2*...
leftTipTE  = [-cRoot - b/2 * tand(lambdaTE_deg), -b/2] - origin;

% vertically concatenate all the coordinates [x, y]
datapoints = [rootLE; rightTipLE; rightTipTE; rootTE; leftTipTE; leftTipLE; rootLE];

end

