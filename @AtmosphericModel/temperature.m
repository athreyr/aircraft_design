function val = temperature(ThisAtmosphericModel, altitudeGeometric, varargin)
%TEMPERATURE Summary of this function goes here
%   Detailed explanation goes here

T = ThisAtmosphericModel.lookup('temperatures', altitudeGeometric, varargin{:});

dfltUnit = ThisAtmosphericModel.SaveUnits.temperature;

[unitOut, isRelTemp] = setOptionalInputs({dfltUnit, false}, varargin(2:end));
% DON'T ALLOW isRelTemp = true IF UNIT SYMBOL IS EMPTY ---------- !!!!!!!!

val = Unit.convert(T, dfltUnit, unitOut, isRelTemp);

end
