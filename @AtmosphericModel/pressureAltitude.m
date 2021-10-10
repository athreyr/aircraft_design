function hG = pressureAltitude(ThisAtmosphericModel, p, varargin)
%pressureAltitude   Geometric altitude where pressure has specified value
%   AM.pressureAltitude(p, |unitIn, |unitOut) returns the geometric
%   altitudes (in unit unitOut) at which the values of static pressures are
%   equal to the N-D array p (in unit unitIn). The units are optional, and
%   their default values are AM.DisplayUnits.pressure and
%   AM.DisplayUnits.altitude, respectively.
% 
%   See also geometricAltitude, densityAltitude, pressure.

narginchk(2,4)

unitInDflt = ThisAtmosphericModel.DisplayUnits.pressure;
unitIn = setOptionalInputs({unitInDflt}, varargin);

pressure = Unit.convert(p, unitIn, ThisAtmosphericModel.SaveUnits.pressure);

hG = ThisAtmosphericModel.invlookup('pressuresStatic', pressure, varargin{2:end});

end
