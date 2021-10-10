function val = pressure(ThisAtmosphericModel, altitudeGeometric, varargin)
%pressure    Static pressure from geometric altitude, with units.
%   AM.pressure(altitudeGeometric, |unitIn, |unitOut) returns the
%   interpolated value of static pressure (in unit unitOut) at each
%   altitude in the N-D array altitudeGeometric (presumed to be in unit
%   unitIn). The units are optional, and their default values are
%   AM.DisplayUnits.altitude and AM.DisplayUnits.pressure respectively.
% 
%   See also temperature, density, geopotentialAltitude, pressureAltitude.

narginchk(2,4)

p = ThisAtmosphericModel.lookup('pressuresStatic', altitudeGeometric, varargin);
pUnit = ThisAtmosphericModel.SaveUnits.pressure;

unitOutDflt = ThisAtmosphericModel.DisplayUnits.pressure;
unitOut = setOptionalInputs({unitOutDflt}, varargin(2:end));
val = Unit.convert(p, pUnit, unitOut);

end
