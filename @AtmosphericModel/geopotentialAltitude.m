function hVal = ...
    geopotentialAltitude(ThisAtmosphericModel, altitudeGeometric, varargin)
%geopotentialAltitude   Geopotential altitude from geometric, with units
%   AM.geopotentialAltitude(altitudeGeometric, |unitIn, |unitOut) converts
%   the N-D array of input geometric altitudes to geopotential ones (of the
%   same shape). Both input and output units can optionally be specified.
%   By default, they are both AM.SaveUnits.altitude. If you specify input
%   unit and no output unit, output unit is same as input unit.

narginchk(2,4)

SaveUnits = ThisAtmosphericModel.SaveUnits;
% DispUnits = ThisAtmosphericModel.DisplayUnits;

unitIn = setOptionalInputs({SaveUnits.altitude}, varargin);
% only varargin(1), if it isn't empty, will be considered
unitOut = setOptionalInputs({unitIn}, varargin(2:end));
% unitOut = unitIn, unless user has specified something
% [unitIn, unitOut] = ...
%     setOptionalInputs({SaveUnits.altitude, DispUnits.altitude}, varargin);

hG = Unit.convert(altitudeGeometric, unitIn, SaveUnits.radius);

h =  hG * ThisAtmosphericModel.RADIUS_OF_EARTH ./ ...
    (hG + ThisAtmosphericModel.RADIUS_OF_EARTH);

hVal = Unit.convert(h, SaveUnits.radius, unitOut);

end
