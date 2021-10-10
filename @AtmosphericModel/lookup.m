function val = lookup(ThisAtmosphericModel, propname, hG, units)
%lookup     Value of queried property after interpolating with altitude
%   AM.lookup(propname, hG, units) returns the value of the queried 
%   property propname at geometric altitudes hG, after converting it
%   from units{1} (which if empty, will do the same as
%   AM.DisplayUnits.altitude).
% 
%   This is a hidden method because users are just supposed to use the
%   wrapper functions temperature, density, etc. to get the required values
%   from the lookup table.
% 
%   propname has to be an exact match with one of the properties of AM
%   (dynamic field referencing). Only one property can be looked up at a
%   time (altitudeGeometric can be an N-D array, though).
% 
%   See also temperature, pressure, density.

% if no units are passed from wrappers, pass nothing to geopotentialAltitude
if isempty(units), unitIn = ''; else, unitIn = units{1}; end

% compute geopotential altitudes in saved unit (for accurate interpolation)
hq =  ThisAtmosphericModel.geopotentialAltitude(hG, unitIn, ...
    ThisAtmosphericModel.SaveUnits.altitude);
            
val = zeros(size(hG));
val(:) = interp1(ThisAtmosphericModel.altitudesGeopotential, ...
    ThisAtmosphericModel.(propname), hq);

end

