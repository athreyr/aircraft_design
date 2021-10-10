function hG = densityAltitude(ThisAtmosphericModel, rho, varargin)
%densityAltitude   Geometric altitude where density has specified value
%   AM.densityAltitude(rho, |unitIn, |unitOut) returns the geometric
%   altitudes (in unit unitOut) at which the values of densities are equal
%   to the N-D array rho (in unit unitIn). The units are optional, and
%   their default values are AM.DisplayUnits.density and
%   AM.DisplayUnits.altitude, respectively.
% 
%   See also geometricAltitude, pressureAltitude, density.

narginchk(2,4)

unitInDflt = ThisAtmosphericModel.DisplayUnits.density;
unitIn = setOptionalInputs({unitInDflt}, varargin);

density = Unit.convert(rho, unitIn, ThisAtmosphericModel.SaveUnits.density);

hG = ThisAtmosphericModel.invlookup('densities', density, varargin{2:end});

end
