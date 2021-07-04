function val = ...
    geometricAltitude(ThisAtmosphericModel, altitudeGeopotential, varargin)
%geometricAltitude   Geometric altitude from geopotential, with units
%   AM.geometricAltitude(altitudeGeopotential, |unitIn, |unitOut) converts
%   the N-D array of input geopotential altitudes to geometric ones (of the
%   same shape). Both input and output units can optionally be specified.
%   By default, they are both AM.SaveUnits.altitude. If you specify input
%   unit and no output unit, output unit is same as input unit.

narginchk(2,4)

DefaultUnits = ThisAtmosphericModel.SaveUnits;

unitIn = setOptionalInputs({DefaultUnits.altitude}, varargin);
% only varargin(1), if it isn't empty, will be considered
unitOut = setOptionalInputs({unitIn}, varargin(2:end));

h = Unit.convert(altitudeGeopotential, unitIn, DefaultUnits.radius);

hG = ThisAtmosphericModel.RADIUS_OF_EARTH * h ./ ...
    (ThisAtmosphericModel.RADIUS_OF_EARTH - h);

val = Unit.convert(hG, DefaultUnits.radius, unitOut);

end
