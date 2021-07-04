function val = pressure(ThisAtmosphericModel, altitudeGeometric, varargin)
%TEMPERATURE Summary of this function goes here
%   Detailed explanation goes here

p = ThisAtmosphericModel.lookup('pressuresStatic', altitudeGeometric, varargin{:});

dfltUnit = ThisAtmosphericModel.SaveUnits.pressure;
unitOut = setOptionalInputs({dfltUnit}, varargin(2:end));
val = Unit.convert(p, dfltUnit, unitOut);

end
