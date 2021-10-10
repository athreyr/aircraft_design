function val = density(ThisAtmosphericModel, altitudeGeometric, varargin)
%density    Density from geometric altitude, with units
%   AM.density(altitudeGeometric, |unitIn, |unitOut) returns the
%   interpolated value of density (in unit unitOut) at each altitude in the
%   N-D array altitudeGeometric (presumed to be in unit unitIn). The units
%   are optional, and their default values are AM.DisplayUnits.altitude and
%   AM.DisplayUnits.density respectively.
% 
%   See also pressure, temperature, geopotentialAltitude, densityAltitude.

narginchk(2,4)

rho = ThisAtmosphericModel.lookup('densities', altitudeGeometric, varargin);
rhoUnit = ThisAtmosphericModel.SaveUnits.density;

unitOutDflt = ThisAtmosphericModel.DisplayUnits.density;
unitOut = setOptionalInputs({unitOutDflt}, varargin(2:end));
val = Unit.convert(rho, rhoUnit, unitOut);

end
