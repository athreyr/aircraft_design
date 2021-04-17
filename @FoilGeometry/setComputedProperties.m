function ThisFoilGeometry = setComputedProperties(ThisFoilGeometry)
%COMPUTEPROPERTIES Summary of this function goes here
%   Detailed explanation goes here

% abcissas = ThisFoilGeometry.abcissas;
% ordinates = ThisFoilGeometry.ordinates;

% use fixAirfoil here
% check for compatible array sizes in x and y (make both column vectors)
% check for valid filenames, vars
% write default file for inputs
% spline interpolate in x and y to make the points good

% coordFormat = FoilGeometry.determineCoordinatesFormat([abcissas, ordinates]);
ThisFoilGeometry = ThisFoilGeometry.setCoordinatesFormat;

% [x, y] = FoilGeometry.switchCoordinatesFormat(abcissas, ordinates, ...
%                                               coordFormat, 'selig');
[x, y] = ThisFoilGeometry.switchCoordinatesFormat('selig');
dS = [0; sqrt(diff(x).^2 + diff(y).^2)];
S = sum(dS);
Cperimeter = [sum(x.*dS), sum(y.*dS)] / S;

% [xcoords, ycoords] = FoilGeometry.switchCoordinatesFormat(abcissas, ...
%                                         ordinates, coordFormat, 'lednicer');
[xcoords, ycoords] = ThisFoilGeometry.switchCoordinatesFormat('lednicer');
nPts = numel(xcoords) / 2;
xcommon = (xcoords(1:nPts) + xcoords(nPts+1:end)) / 2;
yupper = ycoords(1:nPts);
ylower = ycoords(nPts+1:end);
tChord = yupper - ylower;
camberPts = (yupper + ylower) / 2;

dA = [0; diff(xcommon)/2 .* (tChord(1:end-1) + tChord(2:end))];
A = sum(dA);
xPts = [0; (xcommon(1:end-1) + xcommon(2:end))/2];
Carea = [sum(xPts .* dA), sum(camberPts .* dA)] / A;

% ThisFoilGeometry.coordinatesFormat = coordFormat;
ThisFoilGeometry.perimeter = S;
ThisFoilGeometry.area = A;
ThisFoilGeometry.centroidPerimeter = Cperimeter;
ThisFoilGeometry.centroidArea = Carea;
ThisFoilGeometry.thicknessChord = [tChord, xcommon];
ThisFoilGeometry.camber = [camberPts, xcommon];

end

