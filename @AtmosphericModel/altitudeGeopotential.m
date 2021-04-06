function h = altitudeGeopotential(ThisAtmosphericModel, altitudeGeometric, varargin)
%GEOPOTENTIALALTITUDE Summary of this function goes here
%   Detailed explanation goes here

hG = altitudeGeometric;
if ~isempty(varargin)
    hG = ThisAtmosphericModel.convertUnit(altitudeGeometric, varargin{1});
end

h =  hG * ThisAtmosphericModel.RADIUS_OF_EARTH ./ ...
    (hG + ThisAtmosphericModel.RADIUS_OF_EARTH);

end

