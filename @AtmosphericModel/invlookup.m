function hG = invlookup(ThisAtmosphericModel, propname, propval, varargin)
%invlookup      Geometric altitudes at which properties have queried values
% 
%   This is a hidden method because users are just supposed to use the
%   wrapper functions pressureAltitude, densityAltitude, etc. to get the
%   required altitudes from inverse lookup of the table.
% 
%   The input argument propname has to be an exact match with one of the
%   properties of ThisAtmosphericModel (dynamic field referencing).
% 
%   Also, only one property can be used for inverse lookup at a time
%   (values can be N-D arrays, though).

narginchk(3, 4)

h = zeros(size(propval));
h(:) = interp1(ThisAtmosphericModel.(propname), ...
    ThisAtmosphericModel.altitudesGeopotential, propval);

hG = ThisAtmosphericModel.geometricAltitude(h, [], varargin{:});

end
