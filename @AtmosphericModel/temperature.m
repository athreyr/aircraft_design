function val = temperature(ThisAtmosphericModel, altitudeGeometric, varargin)
%temperature    Temperature from geometric altitude, with units
%   AM.temperature(altitudeGeometric, |unitIn, |unitOut, |isRelTemp)
%   returns the interpolated value of Outside Air Temperature (OAT) (in 
%   unit unitOut) at each altitude in the N-D array altitudeGeometric
%   (presumed to be in unit unitIn). The units are optional, and their
%   default values are AM.DisplayUnits.altitude and
%   AM.DisplayUnits.temperature respectively.
% 
%   Conversion between relative temperature units (e.g. '0R' and '0C') is
%   in beta stage, but supported by setting isRelTemp = true (default is
%   false).
% 
%   See also pressure, density, geopotentialAltitude, convert.

narginchk(2,5)

T = ThisAtmosphericModel.lookup('temperatures', altitudeGeometric, varargin);
TUnit = ThisAtmosphericModel.SaveUnits.temperature;

% if user hasn't entered unitOut but has specified isRelTemp, it should be
% ignored, so first create unitOut with default value of empty char
unitOut = setOptionalInputs({''}, varargin(2:end));

if isempty(unitOut) % user hasn't entered unitOut
    isRelTemp = false;
else
    isRelTemp = setOptionalInputs({false}, varargin(3:end));
end

unitOutDflt = ThisAtmosphericModel.DisplayUnits.temperature;
unitOut = setOptionalInputs({unitOutDflt}, varargin(2:end));

val = Unit.convert(T, TUnit, unitOut, isRelTemp);

end
