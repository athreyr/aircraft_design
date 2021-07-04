function val = density(ThisAtmosphericModel, altitudeGeometric, varargin)
%TEMPERATURE Summary of this function goes here
%   Detailed explanation goes here

rho = ThisAtmosphericModel.lookup('densities', altitudeGeometric, varargin{:});

dfltUnit = ThisAtmosphericModel.SaveUnits.density;
unitOut = setOptionalInputs({dfltUnit}, varargin(2:end));
val = Unit.convert(rho, dfltUnit, unitOut);

end
