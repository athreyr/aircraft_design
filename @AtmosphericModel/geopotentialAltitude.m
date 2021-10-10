function val = ...
    geopotentialAltitude(ThisAtmosphericModel, altitudeGeometric, varargin)
%geopotentialAltitude   Geopotential altitude from geometric, with units
%   AM.geopotentialAltitude(altitudeGeometric, |unitIn, |unitOut) converts
%   the N-D array of input geometric altitudes to geopotential ones (of the
%   same shape). Both input and output units can optionally be specified.
%   By default, they are both AM.DisplayUnits.altitude. If you specify
%   input unit and no output unit, output unit is same as input unit.
% 
%   See also temperature, pressure, density, geometricAltitude.

narginchk(2,4)

DispUnits = ThisAtmosphericModel.DisplayUnits;
SaveUnits = ThisAtmosphericModel.SaveUnits;

unitIn = setOptionalInputs({DispUnits.altitude}, varargin);
% only varargin(1), that too if it isn't empty, will be considered
unitOut = setOptionalInputs({unitIn}, varargin(2:end));
% unitOut = unitIn, unless user has specified something

hG = Unit.convert(altitudeGeometric, unitIn, SaveUnits.radius);

h =  hG * ThisAtmosphericModel.RADIUS_OF_EARTH ./ ...
    (hG + ThisAtmosphericModel.RADIUS_OF_EARTH);

val = Unit.convert(h, SaveUnits.radius, unitOut);

end
