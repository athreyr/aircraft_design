function val = lookup(ThisAtmosphericModel, propq, altitudeGeometric, varargin)
%lookup returns value of queried property after interpolating with altitude
% 
%   This is a hidden method because users are just supposed to use the
%   wrapper functions temperature, density, etc. to get the required values
%   from the lookup table.
% 
%   The input argument queriedPropertyName has to be an exact match with
%   one of the fields of Table (dynamic field referencing).
% 
%   Also, only one property can be looked up at a time (altitudes can be
%   N-D arrays, though).

% narginchk(3, 4)
dfltUnit = ThisAtmosphericModel.SaveUnits.altitude;
unitIn = setOptionalInputs({dfltUnit}, varargin);

hG = Unit.convert(altitudeGeometric, unitIn, dfltUnit);

hq =  ThisAtmosphericModel.altitudeGeopotential(hG);
            
val = zeros(size(hG));
val(:) = interp1(ThisAtmosphericModel.altitudesGeopotential, ...
    ThisAtmosphericModel.(propq), hq);

end

