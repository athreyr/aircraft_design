function val = lapseRate(ThisAtmosphericModel, hG, varargin)
%lapseRate      Lapse rate at specified geometric altitude, with units
%   AM.lapseRate(hG, |unitIn, |unitOut) returns the lapse rate (in unit
%   unitOut) at the geometric altitude hG (in unit unitIn). The units are
%   optional, and their default values are AM.DisplayUnits.altitude and
%   AM.DisplayUnits.temperature / AM.DisplayUnits.altitude respectively.
% 
%   See also temperature, pressure, density.

narginchk(2,4)

DispUnits = ThisAtmosphericModel.DisplayUnits;
SaveUnits = ThisAtmosphericModel.SaveUnits;

unitInDflt = DispUnits.altitude;
unitIn = setOptionalInputs({unitInDflt}, varargin);

h = ThisAtmosphericModel.geopotentialAltitude(hG, unitIn, SaveUnits.altitude);

hRegLim = ThisAtmosphericModel.regionLimitsGeopotential;
iRegion = find(h < hRegLim, 1) - 1;

try
    lapseRate = ThisAtmosphericModel.lapseRates(iRegion);
catch ME
    if strcmp(ME.identifier, 'MATLAB:badsubscript')
        ME = MException('AD:AtmosphericModel:altitudeOutOfBounds', ...
            ['Input altitude %g %s is outside the ranges of altitude limits ', ...
            '%g, %g %s.'], ...
            h, unitIn, hRegLim(1), hRegLim(end), SaveUnits.altitude);
    end
    ME.throw
end

lapseRateUnit = [SaveUnits.temperature,'/',SaveUnits.altitude];

unitOutDflt = [DispUnits.temperature,'/',DispUnits.altitude];
unitOut = setOptionalInputs({unitOutDflt}, varargin(2:end));

val = Unit.convert(lapseRate, lapseRateUnit, unitOut);

end
