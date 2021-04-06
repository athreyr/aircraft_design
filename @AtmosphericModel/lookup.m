function queryResult = lookup(ThisAtmosphericModel,queriedPropertyName,...
                              altitudeGeometric,varargin)
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

queryAltitude =  ThisAtmosphericModel.geopotentialAltitude(altitudeGeometric);
            
queryResult = zeros(size(altitudeGeometric));
queryResult(:) = interp1(ThisAtmosphericModel.Table.altitudeGeopotential, ...
                         ThisAtmosphericModel.Table.(queriedPropertyName), ...
                         queryAltitude);
end

