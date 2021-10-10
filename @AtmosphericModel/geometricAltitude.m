function val = ...
    geometricAltitude(ThisAtmosphericModel, altitudeGeopotential, varargin)
%geometricAltitude   Geometric altitude from geopotential, with units
%   AM.geometricAltitude(altitudeGeopotential, |unitIn, |unitOut) converts
%   the N-D array of input geopotential altitudes to geometric ones (of the
%   same shape). Both input and output units can optionally be specified.
%   By default, they are both AM.DisplayUnits.altitude. If you specify
%   input unit and no output unit, output unit is same as input unit.
% 
%   See also pressureAltitude, densityAltitude, geopotentialAltitude.

narginchk(2,4)

DispUnits = ThisAtmosphericModel.DisplayUnits;
SaveUnits = ThisAtmosphericModel.SaveUnits;

unitIn = setOptionalInputs({DispUnits.altitude}, varargin);
% only varargin(1), that too if it isn't empty, will be considered
unitOut = setOptionalInputs({unitIn}, varargin(2:end));
% unitOut = unitIn, unless user has specified something

h = Unit.convert(altitudeGeopotential, unitIn, SaveUnits.radius);

hG = ThisAtmosphericModel.RADIUS_OF_EARTH * h ./ ...
    (ThisAtmosphericModel.RADIUS_OF_EARTH - h);

val = Unit.convert(hG, SaveUnits.radius, unitOut);

end
