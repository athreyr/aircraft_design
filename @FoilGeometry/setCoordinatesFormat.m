function ThisFoilGeometry = setCoordinatesFormat(ThisFoilGeometry)
%DETERMINECOORDINATESFORMAT Summary of this function goes here
%   Detailed explanation goes here

x = ThisFoilGeometry.abcissas;

ThisFoilGeometry.coordinatesFormat = 'selig';

nCoords = numel(x);
if rem(nCoords, 2), return, end

% nCommonX = nCoords/2;
% if norm(x(1:nCoords/2) - x(nCoords/2+1:end)) < 1e

if x(1) < x(2), ThisFoilGeometry.coordinatesFormat = 'lednicer'; end

end

