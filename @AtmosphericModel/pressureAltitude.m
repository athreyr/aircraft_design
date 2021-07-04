function hG = pressureAltitude(ThisAtmosphericModel, pressure, varargin)
%TEMPERATURE Summary of this function goes here
%   Detailed explanation goes here

dfltUnit = ThisAtmosphericModel.SaveUnits.pressure;
unitIn = setOptionalInputs({dfltUnit}, varargin);
p = Unit.convert(pressure, unitIn, dfltUnit);

hG = ThisAtmosphericModel.invlookup('pressuresStatic', p, varargin{2:end});

end
