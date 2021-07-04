function h = altitudeGeopotential(ThisAtmosphericModel, altitudeGeometric, varargin)
%altitudeGeopotential returns that from geometric altitude (in saved units)
% 
%   This method converts the input N-D array of geometric altitudes into
%   their corresponding geopotential ones (of the same shape).
% 
%   Input units can optionally be specified, which allows the conversion of
%   the input values into the units associated with the class object.

hG = altitudeGeometric;
if ~isempty(varargin)
    hG = ThisAtmosphericModel.convertUnit(altitudeGeometric, varargin{1});
end

h =  hG * ThisAtmosphericModel.RADIUS_OF_EARTH ./ ...
    (hG + ThisAtmosphericModel.RADIUS_OF_EARTH);

end

