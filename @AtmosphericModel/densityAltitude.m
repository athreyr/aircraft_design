function hG = densityAltitude(ThisAtmosphericModel, density, varargin)
%TEMPERATURE Summary of this function goes here
%   Detailed explanation goes here

dfltUnit = ThisAtmosphericModel.SaveUnits.density;
unitIn = setOptionalInputs({dfltUnit}, varargin);
rho = Unit.convert(density, unitIn, dfltUnit);

hG = ThisAtmosphericModel.invlookup('densities', rho, varargin{2:end});

end
