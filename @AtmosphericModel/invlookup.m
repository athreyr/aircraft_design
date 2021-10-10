function hG = invlookup(ThisAtmosphericModel, propname, val, hGUnit)
%invlookup      Geometric altitudes at which properties have queried values
%   AM.invlookup(propname, val, hGUnit) returns the geometric altitude at
%   which the queried property propname has the value val, after converting
%   it to hGUnit (which if left empty, does the same as
%   AM.DisplayUnits.altitude).
% 
%   This is a hidden method because users are just supposed to use the
%   wrapper functions pressureAltitude, densityAltitude, etc. to get the
%   required altitudes from inverse lookup of the table.
% 
%   The input argument propname has to be an exact match with one of the
%   properties of AM (dynamic field referencing).
% 
%   Also, only one property can be used for inverse lookup at a time
%   (values can be N-D arrays, though).
% 
%   See also pressureAltitude, densityAltitude.

h = zeros(size(val));
h(:) = interp1(ThisAtmosphericModel.(propname), ...
    ThisAtmosphericModel.altitudesGeopotential, val);

unitOut = setOptionalInputs( ...
    {ThisAtmosphericModel.DisplayUnits.altitude}, {hGUnit});

hG = ThisAtmosphericModel.geometricAltitude(h, ...
    ThisAtmosphericModel.SaveUnits.altitude, unitOut);

end
